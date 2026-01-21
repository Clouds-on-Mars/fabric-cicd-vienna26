# Troubleshooting Guide

[← Back to Workshop Home](./README.md)

## Quick Links

- [Installation Issues](#installation-issues)
- [Authentication Problems](#authentication-problems)
- [Deployment Failures](#deployment-failures)
- [Git Sync Errors](#git-sync-errors)
- [Pipeline Issues](#pipeline-issues)
- [Data & Schema Problems](#data--schema-problems)
- [Common Commands](#common-commands)
- [Getting Help](#getting-help)

---

## Installation Issues

### fabric-cli Installation Fails

**Problem**: `pip install ms-fabric-cli` fails with permission errors
```bash
ERROR: Could not install packages due to an OSError
```

**Solution**:
```bash
# Option 1: Install in user space
pip install --user ms-fabric-cli

# Option 2: Use virtual environment (recommended)
python -m venv fabric-env
source fabric-env/bin/activate  # On Windows: fabric-env\Scripts\activate
pip install ms-fabric-cli

# Option 3: Force reinstall
pip install --force-reinstall ms-fabric-cli
```

### fabric-cli Command Not Found

**Problem**: After installation, `fab` command is not recognized
```bash
bash: fab: command not found
```

**Solution**:
```bash
# Check if fabric-cli is installed
pip show ms-fabric-cli

# Add Python scripts to PATH
export PATH="$PATH:$(python -m site --user-base)/bin"

# For permanent fix, add to ~/.bashrc or ~/.zshrc
echo 'export PATH="$PATH:$(python -m site --user-base)/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Python Version Incompatibility

**Problem**: fabric-cli requires Python 3.10+
```bash
ERROR: This version of ms-fabric-cli requires Python 3.10 or later
```

**Solution**:
```bash
# Check Python version
python --version

# Install Python 3.10+ if needed
# macOS
brew install python@3.11

# Ubuntu/Debian
sudo apt update && sudo apt install python3.11

# Windows - download from python.org
```

---

## Authentication Problems

### Service Principal Authentication Fails

**Problem**: Cannot authenticate with service principal
```bash
Error: Authentication failed. Invalid client secret or certificate
```

**Solution**:
```bash
# Verify service principal credentials
az ad sp show --id $FABRIC_CLIENT_ID

# Re-export credentials with correct values
export FABRIC_TENANT_ID="your-tenant-id"
export FABRIC_CLIENT_ID="your-client-id"
export FABRIC_CLIENT_SECRET="your-client-secret"

# Test authentication
fab auth login

# Alternative: Use certificate authentication
fab auth login --cert-path ./cert.pem --cert-password "password"
```

### Token Expiration

**Problem**: Operations fail with "token expired" error
```bash
Error: The access token has expired. Please re-authenticate.
```

**Solution**:
```bash
# Clear cached credentials
fab auth logout

# Re-authenticate
fab auth login

# For automated scripts, implement token refresh
fab auth login --refresh-token
```

### Insufficient Permissions

**Problem**: Access denied when deploying items
```bash
Error: Forbidden. User does not have permission to perform this action
```

**Solution**:
1. Verify workspace permissions in Fabric portal:
   - Navigate to workspace settings
   - Check "Manage access" for your user/service principal

2. Grant necessary permissions:
   - Navigate to workspace settings in Fabric portal
   - Add service principal with "Member" or "Admin" role
   - For deployment pipelines: Grant "Pipeline Admin" role

3. Check API permissions:
   - Fabric API: `Workspace.ReadWrite.All`
   - Power BI API: `Dataset.ReadWrite.All`
   - Azure DevOps: `Code.ReadWrite`

---

## Deployment Failures

### first_deployment.sh Script Fails

**Problem**: Bootstrap deployment script exits with error
```bash
Error during deployment: Item already exists
```

**Solution**:
```bash
# Option 1: Delete items manually in Fabric portal and retry
./first_deployment.sh

# Option 2: Use force flag (if supported)
./first_deployment.sh --force

# Option 3: Check workspace items using fabric-cli
fab ls /DEWorkshop_username.Workspace
```

### Notebook Deployment Missing Dependencies

**Problem**: Notebook fails with "Lakehouse not attached"
```bash
Error: No default lakehouse attached to notebook
```

**Solution**:
```python
# In notebook, programmatically attach lakehouse
from notebookutils import mssparkutils

# Attach lakehouse
mssparkutils.notebook.updateNBTrust({
    "defaultLakehouse": {
        "workspaceId": "workspace-guid",
        "lakehouseId": "lakehouse-guid"
    }
})

# Or use deployment rules in pipeline
{
  "rules": [{
    "type": "notebook-lakehouse-binding",
    "source": "Transformations.Notebook",
    "target": "Lakehouse_Silver.Lakehouse"
  }]
}
```

### Semantic Model Connection Errors

**Problem**: Report shows "Cannot connect to data source"
```bash
Error: The data source for this report is not available
```

**Solution**:
1. Update connection strings using fabric-cli:
```bash
# Navigate to workspace
fab cd /DEWorkshop_username.Workspace

# Get semantic model properties
fab get MySemanticModel.SemanticModel

# Export semantic model definition
fab export MySemanticModel.SemanticModel -o ./backup/
```

2. Use Fabric Deployment Rules for automatic remapping (recommended):
   - Configure deployment rules in the Deployment Pipeline UI
   - Set data source rules for the semantic model
   - Rules will automatically remap connections during deployment
```

---

## Git Sync Errors

### Merge Conflicts

**Problem**: Git sync fails with merge conflicts
```bash
Error: Automatic merge failed; fix conflicts and then commit the result
```

**Solution**:
1. Pull latest changes:
```bash
git pull origin main
```

2. Identify conflicts:
```bash
git status
# Shows conflicted files
```

3. Resolve in Fabric UI:
   - Navigate to Source Control
   - Click "Resolve conflicts"
   - Choose "Keep workspace" or "Keep Git"
   - Commit resolution

4. Or resolve locally:
```bash
# Edit conflicted files
vim conflicted-file.json

# Mark as resolved
git add conflicted-file.json
git commit -m "Resolved merge conflict"
git push
```

### Large File Errors

**Problem**: Git push fails with "file too large"
```bash
Error: File notebooks/Large.ipynb is 120 MB; exceeds GitHub's limit of 100 MB
```

**Solution**:
```bash
# Option 1: Use Git LFS
git lfs track "*.ipynb"
git add .gitattributes
git commit -m "Track notebooks with LFS"

# Option 2: Exclude from sync
echo "notebooks/Large.ipynb" >> .gitignore

# Option 3: Split notebook
# In Fabric UI, split into smaller notebooks
```

### Branch Protection Errors

**Problem**: Cannot push to protected branch
```bash
Error: Protected branch update failed
```

**Solution**:
1. Create feature branch:
```bash
git checkout -b feature/my-changes
git push origin feature/my-changes
```

2. Create pull request:
```bash
gh pr create --title "My changes" --body "Description"
```

3. Or temporarily disable protection:
   - Azure DevOps: Project Settings → Repositories → Branch Policies
   - Disable "Require pull request"
   - Make changes
   - Re-enable protection

### Remote Repository Renamed

**Problem**: Push fails with error referencing old repo name  
```bash
error: failed to push some refs to 'github.com:DaniBunny/Fabric-DE-CICD.git'
```

**Solution**:
```bash
# Update remote to new repository name
git remote set-url origin git@github.com:DaniBunny/Fabric-DE-CICD.git

# Verify remote URL
git remote -v

# Push changes
git push origin main
```

### Branch Does Not Exist

**Problem**: Push fails with `src refspec <branch> does not match any`
```bash
error: src refspec improvements does not match any
error: failed to push some refs to 'github.com:DaniBunny/Fabric-DE-CICD.git'
```

**Solution**:
```bash
# List local branches to verify branch name
git branch

# Create and switch to the branch if it doesn't exist
git checkout -b improvements

# Add and commit your changes
git add .
git commit -m "Your commit message"

# Push the branch to remote
git push origin improvements
```

---

## Pipeline Issues

### Deployment Pipeline Stage Assignment Fails

**Problem**: Cannot assign workspace to pipeline stage
```bash
Error: Workspace is already assigned to another pipeline
```

**Solution**:
1. Check existing assignments:
```bash
fab pipeline list-workspaces --pipeline "DEWorkshop_Pipeline"
```

2. Unassign from other pipeline:
```bash
fab pipeline unassign-workspace \
  --pipeline "OldPipeline" \
  --stage "Development"
```

3. Reassign to new pipeline:
```bash
fab pipeline assign-workspace \
  --pipeline "DEWorkshop_Pipeline" \
  --stage "Development" \
  --workspace "DEWorkshop_username_Feature"
```

### Variable Library Not Resolving

**Problem**: Deployment fails with "Variable not found"
```bash
Error: Variable #{WORKSPACE_ID}# could not be resolved
```

**Solution**:
1. Verify variable library exists:
```bash
fab pipeline get-variables --pipeline "DEWorkshop_Pipeline"
```

2. Create/update variables:
```bash
fab pipeline set-variable \
  --pipeline "DEWorkshop_Pipeline" \
  --stage "Production" \
  --name "WORKSPACE_ID" \
  --value "guid-here"
```

3. Check variable syntax in rules:
```json
{
  "targetWorkspace": "#{WORKSPACE_ID}#",  // Correct
  "targetWorkspace": "${WORKSPACE_ID}"     // Incorrect
}
```

### Deployment Rules Not Applied

**Problem**: Items deploy but connections aren't updated
```bash
Warning: Deployment completed but rules were not applied
```

**Solution**:
1. Verify rule syntax:
```json
{
  "deploymentRules": [{
    "name": "UpdateLakehouseBinding",
    "type": "NotebookLakehouseBinding",
    "config": {
      "sourcePath": "*.Notebook",
      "targetLakehouse": "Lakehouse_Silver"
    }
  }]
}
```

2. Check rule prerequisites:
   - Target items must exist
   - Names must match exactly (case-sensitive)
   - Permissions must allow modifications

3. Enable rule debugging:
```bash
fab pipeline deploy \
  --pipeline "DEWorkshop_Pipeline" \
  --source "Development" \
  --target "Production" \
  --debug-rules
```

---

## Data & Schema Problems

### Schema Drift Between Environments

**Problem**: Production deployment fails due to schema mismatch
```bash
Error: Column 'new_field' does not exist in target table
```

**Solution**:
1. Implement safe schema evolution:
```python
# In transformation notebook
from pyspark.sql import functions as F

# Check if column exists
if 'new_field' not in df.columns:
    df = df.withColumn('new_field', F.lit(None))

# Safe write with schema merge
df.write \
  .mode("append") \
  .option("mergeSchema", "true") \
  .saveAsTable("silver.enhanced_sales")
```

2. Use deployment hooks for migration:
```yaml
# azure-pipelines.yml
- task: PythonScript@0
  displayName: 'Run Schema Migration'
  inputs:
    scriptSource: 'inline'
    script: |
      from fabric_cicd import migrations
      migrations.apply_schema_changes(
        source_env='development',
        target_env='production'
      )
```

### Data Load Failures

**Problem**: Pipeline fails with "File not found" in shortcuts
```bash
Error: The specified path does not exist in the target location
```

**Solution**:
1. Verify shortcut targets:
```bash
fab item get-shortcuts \
  --workspace "DEWorkshop_username" \
  --lakehouse "Lakehouse_Bronze"
```

2. Update shortcut paths:
```python
# Recreate shortcut with correct path
from notebookutils import mssparkutils

mssparkutils.lakehouse.createShortcut(
    name="external_data",
    target_workspace_id="workspace-guid",
    target_lakehouse_id="lakehouse-guid",
    target_path="/Tables/source_data"
)
```

3. Use environment-specific shortcuts:
```json
{
  "shortcuts": {
    "development": "/dev/data/",
    "production": "/prod/data/"
  }
}
```

### Performance Issues

**Problem**: Queries running slowly after deployment
```bash
Warning: Query execution time exceeded threshold
```

**Solution**:
1. Optimize table properties:
```python
# Enable Z-ordering
spark.sql("""
  OPTIMIZE silver.fact_sales 
  ZORDER BY (date_key, product_id)
""")

# Update statistics
spark.sql("ANALYZE TABLE silver.fact_sales COMPUTE STATISTICS")
```

2. Check partition strategy:
```python
# Repartition for better performance
df.repartition(200, "date_key") \
  .write \
  .partitionBy("year", "month") \
  .mode("overwrite") \
  .saveAsTable("silver.fact_sales_optimized")
```

---

## Common Commands

### Quick Diagnostics

```bash
# Check fabric-cli version
fab --version

# Verify authentication
fab auth status

# List workspaces
fab ls /

# Check workspace items
fab ls /DEWorkshop_username.Workspace

# Navigate to a workspace
fab cd /DEWorkshop_username.Workspace

# Get item properties
fab get Lakehouse_Silver.Lakehouse
```

> **Note**: Deployment pipeline status and Git sync are managed through the Fabric portal UI, not CLI commands.

### Emergency Recovery

```bash
# Export workspace items
fab cd /DEWorkshop_username.Workspace
fab export Lakehouse_Silver.Lakehouse -o ./backup/
fab export MyNotebook.Notebook -o ./backup/

# Import items to a different workspace
fab cd /DEWorkshop_username_Recovery.Workspace
fab import MyNotebook.Notebook -i ./backup/MyNotebook.Notebook/
```

> **Note**: For Git sync and deployment pipeline rollbacks, use the Fabric portal UI:
> - **Git sync**: Workspace Settings → Git integration → "Update all" or "Commit all"
> - **Rollback**: Open deployment pipeline → History → Select previous deployment → Revert

### Performance Monitoring

Performance monitoring is available through the Fabric portal:

1. **Capacity Metrics**: Admin portal → Capacities → View metrics
2. **Workspace Usage**: Workspace settings → Usage metrics
3. **Query Performance**: Lakehouse SQL endpoint → Query history

---

## Getting Help

### Documentation Resources

- **Official Docs**: [Microsoft Fabric Documentation](https://learn.microsoft.com/fabric/)
- **CLI Reference**: [fabric-cli GitHub](https://github.com/microsoft/fabric-cli)
- **API Reference**: [Fabric REST API](https://learn.microsoft.com/rest/api/fabric/)
- **Community**: [Microsoft Fabric Community](https://community.fabric.microsoft.com/)

### Support Channels

1. **Workshop Issues**:
   - Check this troubleshooting guide first
   - Review module-specific troubleshooting sections
   - Contact workshop instructor

2. **Fabric Platform Issues**:
   - Microsoft Support Portal
   - Azure Support (for service principal issues)
   - Power BI Support (for report/semantic model issues)

3. **Community Help**:
   - Stack Overflow: Tag `microsoft-fabric`
   - GitHub Issues: For fabric-cli problems
   - Microsoft Q&A: For official responses

### Debug Mode

Enable verbose logging for detailed error information:

```bash
# Enable debug mode in fabric-cli config
fab config set debug_enabled true

# Run commands to see detailed output
fab ls /

# For Python/fabric-cicd debugging
export PYTHONVERBOSE=1
python deploy_script.py 2>&1 | tee deployment.log
```

### Common Error Codes

| Code | Meaning | Solution |
|------|---------|----------|
| 401 | Unauthorized | Check authentication, refresh token |
| 403 | Forbidden | Verify permissions, check workspace access |
| 404 | Not Found | Confirm item exists, check spelling |
| 409 | Conflict | Item already exists, use update instead |
| 429 | Rate Limited | Wait and retry, implement exponential backoff |
| 500 | Server Error | Retry operation, check service health |
| 503 | Service Unavailable | Check Fabric service status page |

---

## Workshop-Specific Issues

### Module 1: Environment Setup
- **Issue**: Workspace creation fails → Check capacity allocation
- **Issue**: Git connection fails → Verify repository permissions

### Module 2: First Deployment
- **Issue**: Scripts not found → Check working directory
- **Issue**: Items don't appear → Refresh workspace, check filters

### Module 3: Version Control
- **Issue**: Changes don't sync → Check .gitignore, verify tracking

### Module 4: Branch Management
- **Issue**: Can't create branch → Check branch policies
- **Issue**: Workspace isolation fails → Verify unique names

### Module 5: Deployment Pipelines
- **Issue**: Can't create pipeline → Check license/capacity
- **Issue**: Rules don't apply → Verify JSON syntax

### Module 6: End-to-End Pipeline
- **Issue**: Stage deployment fails → Check dependencies
- **Issue**: Test environment issues → Verify test data

### Module 7: Azure DevOps
- **Issue**: Pipeline auth fails → Check service connection
- **Issue**: YAML syntax errors → Use pipeline validator

### Module 8: Schema Evolution
- **Issue**: Migration fails → Check data compatibility
- **Issue**: Rollback needed → Use backup strategy

---

**Need more help?** Create an issue in the workshop repository with:
1. Error message (full text)
2. Module and exercise number
3. Steps to reproduce
4. Environment details (OS, Python version, fabric-cli version)
5. Debug logs if available
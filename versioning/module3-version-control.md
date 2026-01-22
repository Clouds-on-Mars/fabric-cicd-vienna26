# Module 3: Version Control Basics - Mastering Git Integration

> [!NOTE]
> **Difficulty:** Intermediate | [← Back to Deployment](../deployment/module2-first-deployment.md) | [Next: Branch Management →](../deployment/module4-branch-management.md)

## Module Objectives

Learn the fundamental Git workflows that enable team collaboration:

✅ Connect your Fabric workspace to a Git repository  
✅ Push changes from Fabric to Git (Fabric → Git)  
✅ Pull changes from Git to Fabric (Git → Fabric)  
✅ Understand what gets versioned (and what doesn't)  
✅ Handle conflicts and synchronization issues  

> [!TIP]
> **Why Version Control?**  
> Git integration enables multiple developers to work on the same solution, track changes, review code, and deploy safely across environments.

An important pattern to understand is that once your workspace is connected to Git, updates made from git to Fabric affect all users of that workspace.

To achieve isolation, workspaces should be connected to feature branches or separate branches for each environment (development, test, production). This way, changes can be tested in isolation before being merged into the main branch that is connected to the production workspace. There are multiple strategies and Fabric is flexible to support various branching models.

Refer to the [Best practices for CI/CD in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/cicd/best-practices-cicd) for more information.

## Module Exercise Flow

You'll complete 5 hands-on exercises:

| Exercise | Part | Duration | Status |
|----------|------|----------|--------|
| **1** | Setup Azure DevOps Project | 5 min | ⬜ Ready |
| **2** | Connect Workspace to Git | 5 min | ⬜ Ready |
| **3** | Push Changes (Fabric → Git) | 10 min | ⬜ Ready |
| **4** | Pull Changes (Git → Fabric) | 10 min | ⬜ Ready |
| **5** | Review What Gets Versioned | 5 min | ⬜ Ready |

> **Track Your Progress:** Check off each exercise as you complete it!

## The Two-Way Sync Pattern

```mermaid
graph LR
    A[Fabric Workspace] <-->|Bi-directional Sync| B[Git Repository]
    B --> C[Azure DevOps/GitHub]
    C --> D[Other Developers]
    C --> E[CI/CD Pipelines]
```

### Key Workflows You'll Practice:

| Direction | Use Case | Example |
|-----------|----------|---------|  
| **Fabric → Git** | Save your work | Edit notebook in Fabric, commit to Git |
| **Git → Fabric** | Apply team changes | Pull colleague's updates into your workspace |

## Pre-Module Checklist

> [!IMPORTANT]
> Ensure all items are checked before proceeding:

- ✅ Completed [Module 2: First Deployment](../deployment/module2-first-deployment.md)
- ✅ Fabric portal is open in your browser
- ✅ Workspace `DEWorkshop_<username>` exists with all artifacts
- ✅ Can access Azure DevOps with workshop credentials

### Your Workspace Should Look Like This:

![Expected workspace state](../screenshots/versioning-start-portal.png)

---

## Exercise 1: Setup Azure DevOps Project (5 minutes)

> **Goal:** Create your personal Azure DevOps project and initialize Git repository for the workshop.

### Step 1.1: Login to Azure DevOps

1. **Navigate to Azure DevOps:**
   - Open your browser to: `https://dev.azure.com`
   - Use the workshop credentials provided by your instructor

2. **Verify access:**
   - You should see the Azure DevOps dashboard
   - Click on the "[FABRIC-CICD-VIENNA/workshop](https://dev.azure.com/FABRIC-CICD-VIENNA/workshop)" project

> [!IMPORTANT]
> Use the exact credentials provided by your instructor for this workshop.

### Step 1.2: Fork Repository

> [!IMPORTANT]
> Use the exact username provided by your instructor for this workshop.
> This is a shared Azure DevOps project for the workshop, getting your username wrong will affect the workshop downstream and can also interfere with the work of other attendees.

1. **Navigate to Repos:**
   - Click **Repos** in the left navigation
   - Click on **Files** in the left navigation
   - You should see the files for the workshop.v.fab.works001 repository by default

![Azure DevOps git repo workshop.v.fab.works001](../screenshots/versioning-start-user000-repo.png)

2. **Fork the repositoru:**
   - Click **Initialize** button in the empty repository
   - Check ☑️ **Add a README**
   - Leave ☐ **Add a .gitignore** unchecked
   - Click **Initialize**

![Azure DevOps git repo initialization](../screenshots/versioning-start-user000-fork-1.png)

Make sure you use the correct username. Use capitalization as shown in the example.

![Azure DevOps git repo fork pane](../screenshots/versioning-start-user000-fork-2.png)

2. **Verify repository setup:**
   - You should see a `README.md`, `deploy-to-fabric.py` and `deploy-to-fabric.yml` file in the main branch of your repository.
   - The repository URL should be: `https://dev.azure.com/FABRIC-CICD-VIENNA/workshop/_git/User###`

For example, the following would be a `workshop.v.fab.works001` repository fork ready to go:

![Azure DevOps project after initialization](../screenshots/versioning-start-repo-initialized.png)

### ✅ Exercise 1 Checkpoint

**Before continuing, verify:**
- [ ] Project `workshop.v.fab.worksNNN` created successfully (e.g. `https://dev.azure.com/FABRIC-CICD-VIENNA/workshop/_git/workshop.v.fab.works001`)
- [ ] Repository initialized with README.md file
- [ ] You can access Repos section
- [ ] Main branch is active and visible

**Exercise 1 Complete!** Your Azure DevOps project is ready for Git integration.

---

## Exercise 2: Connect to Git (5 minutes)

> **Goal:** Link your Fabric workspace to your newly created Git repository.

### Step 2.1: Open Git Integration Settings

1. **In your Fabric workspace:**
   - Ensure you're in `DEWorkshop_<username>` e.g. `DEWorkshop_v.fab.works001@rocksonearth.onmicrosoft.com`
   - Click the ** Workspace Settings** icon (top right)

2. **Navigate to the Git integration tab:**
   - Click **Azure DevOps** 
   - Make sure your Entra Account is selected. If not add the account information.
   - Click **Connect**

### Step 2.2: Configure Repository Connection

> [!IMPORTANT]
> Use these exact settings for your personal project:

| Setting | Value | Notes |
|---------|-------|-------|
| **Git provider** | Azure DevOps | Select from dropdown |
| **Organization** | `FABRIC-CICD-VIENNA` | Your workshop org |
| **Project** | `DEWorkshop-<username>` | Your personal project |
| **Repository** | `DEWorkshop-<username>` | Your git repository |
| **Branch** | `main` | Default branch |
| **Folder** | `` | Folder for your workspace |

For example, the following would be a `workshop.v.fab.works001` repository configuration:

![Fabric connect to git pane](../screenshots/versioning-start-connect-and-sync.png)

### Step 2.3: Perform Initial Sync

**Click "Connect and sync"**
    - If folder creation confirmation appears, confirm with **Create and sync**.

![Fabric connect to git pane folder confirmation](../screenshots/versioning-start-connect-and-sync-folder.png)

### Step 2.4: Upload one additional file to the repository

This will make life easier later in Module 7. We will upload the `parameter.yml` file that will be used in Module 7 now, so it get pushed to all branches as we go through the workshop.

#### In Azure DevOps:
1. Navigate to **Repos** → **Files** to your repository (User###)
2. Click on the icon by the `DE_Workshop` folder name like below and click ***Upload file(s)***

![upload menu](../screenshots/versioning-start-upload-parameter-1.png)

3. Select the `parameter.yml` file from your local machine and click **Commit** to upload it.

![upload pane](../screenshots/versioning-start-upload-parameter-2.png)

**Make sure the file `parameter.yml` is uploaded to the DE_Workshop like screenshot bellow:**

![file uploaded](../screenshots/versioning-start-upload-parameter-3.png)

### ✅ Exercise 2 Checkpoint

**Before continuing, verify:**
- [ ] Workspace shows "Git synced" indicator
- [ ] Azure DevOps shows your workspace artifacts
- [ ] All artifacts appear in the repository

**Exercise 2 Complete!** You've connected Fabric to Git.

### Step 2.4: Verify Sync Success

#### In Azure DevOps:
1. Navigate to **Repos** → **Files**
2. Verify these folders exist in your repository:

![Azure DevOps after sync](../screenshots/versioning-start-devops-after-sync.png)

#### In Fabric:
1. Navigate to your Fabric workspace
2. Verify Synced status

![Fabric workspace after sync](../screenshots/versioning-start-portal-after-sync.png)

---

## Exercise 3: Fabric → Git Workflow (10 minutes)

> **Goal:** Make a change in Fabric and push it to your Git repository.
> 
> [!NOTE]
> This simulates your daily workflow of developing in Fabric and saving changes.

### Step 2.1: Modify a Lakehouse Shortcut

1. **Open Lakehouse_Silver:**
   - Click on `Lakehouse_Silver` in your workspace
   - Expand **Tables** section
   - Find the `t3` shortcut

2. **Rename the shortcut:**
   - Click **⋯** (ellipsis) next to `t3`
   - Select **Manage shortcut**
   - Change **Name** from `t3` to `t3_test`
   - Click **Check icon to save**

3. **Verify the change:**
   - Click **⋯** → **Refresh** on Tables section
   - Confirm `t3_test` appears instead of `t3`
   - Click on `t3_test` to preview data

### Step 2.2: Commit Changes to Git

1. **Open Source Control panel:**
   - Click **Source control** button in workspace header
   - You'll see pending changes:
   ```
   Changes (1)
   M  Lakehouse_Silver
   ```

    ![Pending changes](../screenshots/versioning-start-push-changes-to-git.png)

2. **Review and commit:**
   - Click **Changes** to see details
   - Add commit message:
   ```
   feat: Renamed table shortcut t3 to t3_test
   ```
   - Click **Commit**

3. **Verify in Azure DevOps:**
   - Go to **Repos** → **Commits**
   - Find your commit with timestamp
   - Click to view changed files
   - Check `shortcuts.metadata.json` shows:
   ```json
   "name": "t3_test"  // Changed from "t3"
   ```

    ![Changes in DevOps](../screenshots/versioning-start-devops-with-changes.png)

> [!WARNING]
> **Critical Concept: Dependencies**  
> When you rename database objects (tables, shortcuts), you MUST update all dependent code:  
> - Notebooks referencing the table
> - Semantic models using the table
> - Reports with direct queries
> 
> Always commit these changes together to maintain consistency!

### ✅ Exercise 3 Checkpoint

**Before continuing, verify:**
- [ ] Shortcut renamed to `t3_test` in Fabric
- [ ] Changes committed to Git with message
- [ ] Commit visible in Azure DevOps history
- [ ] `shortcuts.metadata.json` shows the new name

**Exercise 3 Complete!** You've pushed changes from Fabric to Git.

---

## Exercise 4: Git → Fabric Workflow (10 minutes)

> **Goal:** Edit files directly in Git and sync changes back to Fabric.
>
> [!NOTE]
> This simulates receiving changes from teammates or making quick fixes in Git.
> 
> **DevOps Pattern:** We'll "fix forward" rather than reverting - this maintains a clean history.

### Step 3.1: Edit in Azure DevOps

1. **Navigate to the file:**
   - In Azure DevOps, go to **Repos** → **Files**
   - Browse to:
   ```
   DE_Workshop/
   └── Lakehouse_Silver.Lakehouse/
       └── shortcuts.metadata.json
   ```

2. **Edit the file:**
   - Click **Edit** button
   - Find this line:
   ```json
   "name": "t3_test"
   ```
   - Change it back to:
   ```json
   "name": "t3"
   ```

3. **Commit the fix:**
   - Commit message:
   ```
   fix: Revert shortcut name back to t3
   ```
   - Click **Commit**

    ![Fixes in DevOps](../screenshots/versioning-start-devops-fix-name-commit.png)

### Step 3.2: Pull Changes to Fabric

1. **Check for updates:**
   - Return to Fabric workspace
   - Notice the banner:
   ```
    Updates available from Git
   ```
   - Or click **Source control** to see:
   ```
   ↓ 1 incoming change
   ```

2. **Pull the changes:**
   - Click **Updates** tab
   - Review what will be updated:
   ```
   Incoming changes:
   ~ Lakehouse_Silver (modified)
   ```
   - Click **Update all**

    ![Updates from git](../screenshots/versioning-start-pull-updates-from-git.png)

3. **Verify the fix:**
   - Open `Lakehouse_Silver`
   - Refresh Tables section
   - Confirm `t3` is back (not `t3_test`)
   - Preview data to ensure it works

> [!SUCCESS]
> You've completed a full round-trip: Fabric → Git → Fabric! 

### ✅ Exercise 4 Checkpoint

**Before continuing, verify:**
- [ ] File edited in Azure DevOps and committed
- [ ] Fabric shows "Updates available" notification
- [ ] Updates pulled successfully to workspace
- [ ] Shortcut renamed back to `t3` in Lakehouse_Silver
- [ ] Data preview works correctly

**Exercise 4 Complete!** You've pulled changes from Git to Fabric.

---

## Exercise 5: Understanding What Gets Versioned (5 minutes)

> **Goal:** Learn what Fabric tracks in Git and what it doesn't.

### What's Included in Git

| Item Type | What's Versioned | What's NOT Versioned |
|-----------|------------------|---------------------|
| **Lakehouses** | • Structure & metadata<br>• Shortcut definitions<br>• Security roles | • Actual data in tables<br>• Files in OneLake |
| **Notebooks** | • All code cells<br>• Markdown content<br>• Cell metadata | • Execution results<br>• Runtime state |
| **Pipelines** | • Pipeline structure<br>• Activity definitions<br>• Parameters | • Run history<br>• Cached results |
| **Semantic Models** | • Table definitions<br>• Relationships<br>• Measures & calculations | • Imported data<br>• Refresh history |
| **Reports** | • Layout & visuals<br>• DAX queries<br>• Bookmarks | • Cached data<br>• User personalizations |
| **Connections** | • Connection metadata<br>• Endpoint URLs | • Passwords & secrets<br>• OAuth tokens |

### Key Implications

> [!IMPORTANT]
> **The Power of Git Integration:**
> - **Multiple workspaces** can sync from the same Git branch
> - **Changes in Git** automatically flow to all connected workspaces
> - **Deployment pipelines** can promote changes across environments
> - **Code reviews** ensure quality before changes reach production

### Deployment Patterns:

```mermaid
graph TD
    A[Developer makes change] --> B[Commit to feature branch]
    B --> C[Pull Request & Review]
    C --> D[Merge to main]
    D --> E[Auto-deploy to Dev]
    E --> F[Test & Validate]
    F --> G[Deploy to Prod]
```

**Learn more:** [Best practices for CI/CD in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/cicd/best-practices-cicd)

### ✅ Exercise 4 Checkpoint

**Review completed:**
- [ ] Understand what items sync to Git
- [ ] Know what data doesn't sync
- [ ] Grasp deployment implications
- [ ] Ready to use Git for collaboration

**Exercise 5 Complete!** You understand Fabric's Git integration model.

## Troubleshooting Guide

### Common Issues & Solutions

| Problem | Cause | Solution |
|---------|-------|----------|
| **"Updates available" won't go away** | Local changes conflict | Commit or discard local changes first |
| **"Permission denied" on commit** | No write access to repo | Ask admin for Contributor role |
| **Items missing after sync** | Wrong folder path | Check Git integration settings |
| **Sync seems stuck** | Large artifacts | Wait 2-3 minutes, then refresh |
| **Can't see Git options** | Not workspace admin | Request admin access |

### Quick Fixes:

```bash
# Check sync status
Click Source control → View status

# Force refresh
F5 or Ctrl+R in browser

# Disconnect and reconnect
Workspace settings → Git integration → Disconnect
```

---

## Resync if You're Behind (Module 3)

If your Git repo is in a strange state or you're getting merge errors:

1. **Check Git status**
   ```bash
   git status
   ```
2. **If there are uncommitted changes you don't care about**
   ```bash
   git reset --hard
   git clean -fd
   ```
3. **If the Fabric workspace is out of sync**
   - Go to **Workspace Settings** → **Git integration**
   - Click **Disconnect**
   - Reconnect to the same repo/branch
   - Choose **Overwrite from Git** to reset workspace state

4. **If everything is totally broken**
   - Move out of the folder:
     ```bash
     cd ..
     ```
   - Re-clone the repository:
     ```bash
     git clone https://github.com/Clouds-on-Mars/fabric-cicd-vienna26.git
     cd fabric-cicd-vienna26
     ```
   - Reactivate your virtualenv and continue from the current exercise.

If you're unsure whether it's safe to reset, pause and ask an instructor before running these commands.

---

## What You Learned in Module 3

By completing this module, you:

- ✅ Connected your Fabric workspace to an Azure DevOps Git repository
- ✅ Performed basic Git operations (commit, push, pull)
- ✅ Understood how Fabric's Git integration syncs workspace changes
- ✅ Practiced the full round-trip: Fabric → Git → Fabric
- ✅ Learned what gets versioned (metadata) vs. what doesn't (data)

---

##  Module Complete!

### Exercise Summary

| Exercise | Completed | What You Learned |
|----------|-----------|------------------|
| **1. Connect to Git** | ✅ | Linked workspace to Azure DevOps repository |
| **2. Branch Hierarchy** | ✅ | Created test and development branches |
| **3. Fabric → Git** | ✅ | Pushed changes from Fabric UI to version control |
| **4. Git → Fabric** | ✅ | Pulled teammate changes into your workspace |
| **5. Version Tracking** | ✅ | Understood what's tracked vs. what's not |

### ✅ Skills You've Mastered:

- **Connected** Fabric workspace to Git repository
- ⬆️ **Pushed** changes from Fabric to Git
- ⬇️ **Pulled** changes from Git to Fabric
- **Understood** what gets versioned vs. what doesn't
- **Practiced** the complete development loop

### 🏆 You Can Now:
- Collaborate with team members through Git
- Track all changes to your data engineering artifacts
- Review code before deploying to production
- Maintain multiple environments from one codebase

## What's Next?

> [!IMPORTANT]
> ### ✅ Module 3 Complete! Ready to Continue?
> 
> **Your Progress:** [1] ✅ → [2] ✅ → [3] ✅ → **[4]** → [5] → [6] → [7] → [8]
> 
> ### **NEXT MODULE: Branch Management**
> 
> **Location:** [`/deployment/module4-branch-management.md`](../deployment/module4-branch-management.md)  
> **You'll Learn:**
> - Create feature branches for isolated development
> - Deploy branches to separate workspaces
> - Test changes without affecting main
> - Merge strategies and conflict resolution
> 
> **[→ Click here to start Module 4: Branch Management](../deployment/module4-branch-management.md)**

> [!TIP]
> **Pro Tip:** From now on, all your changes are tracked! Make meaningful commit messages - your future self will thank you.

---

| [← Module 2: First Deployment](../deployment/module2-first-deployment.md) | [Home](../README.md) | [Module 4: Branch Management →](../deployment/module4-branch-management.md) |
|:-----------------------------------------------------------|:--------------------:|-------------------------------------------------------------:|

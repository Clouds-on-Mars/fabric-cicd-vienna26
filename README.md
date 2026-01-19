# Git and CI/CD Mastery Inside Fabric Data Engineering

## Data Community Day Vienna 2026 — Workshop Guide

> **January 22, 2026 | 9:00 AM – 5:00 PM CET**  
> **JUFA Wien City, Mautner Markhof-Gasse 50, 1110 Wien**

Build, version, and deploy Microsoft Fabric solutions at scale. Learn Git, CI/CD, Terraform, and automation for modern data engineering.

---

### About This Workshop

Modern data engineering demands more than just building pipelines—it requires robust version control, seamless collaboration, and reliable deployment across environments. Yet, many teams struggle to manage complex Microsoft Fabric solutions across development and production stages.

This hands-on workshop solves that problem by guiding you through a complete, end-to-end implementation of a data engineering solution using Microsoft Fabric.

You'll learn how to integrate Lakehouse, Spark Notebooks, Warehouses, Data Pipelines, Semantic Models, and Power BI into a cohesive system—all under Git source control and deployed through automated CI/CD pipelines using modern tooling.

### What You'll Master

1. **Infrastructure as Code** — Deploy and manage Fabric workspaces, capacities, and security configurations using Terraform
2. **Command-line Automation** — Leverage `fabric-cli` for scripted workspace management, artifact deployment, and operational tasks
3. **Advanced CI/CD Patterns** — Implement sophisticated deployment pipelines using `fabric-cicd` framework for environment promotion and release management
4. **Git Integration Strategies** — Configure workspace-to-repository mappings, branching strategies, and merge conflict resolution
5. **Environment Management** — Design and implement variable substitution, deployment gates, and rollback mechanisms across dev/staging/production environments

By the end of this workshop, you'll have hands-on experience with the complete toolchain needed to manage enterprise-grade Fabric solutions—from infrastructure provisioning through production deployment. Whether you're a data engineer, platform architect, or DevOps practitioner, this workshop will equip you with the skills to confidently manage Fabric-based solutions at scale using industry-standard automation tools.

### Your Trainers

- **[Bartosz Burger](https://www.linkedin.com/in/bartoszburger/)**
- **[Michal Kachniarz](https://www.linkedin.com/in/michalkachniarz/)**
- **[Przemyslaw Harazny](https://www.linkedin.com/in/przemyslaw-harazny/)**
- **[Estera Kot](https://www.linkedin.com/in/esterakot/)**

---

### What You'll Build

You'll implement a complete data engineering solution with professional DevOps practices:
- **Medallion Architecture**: Bronze → Silver data layers using Microsoft Fabric Lakehouses
- **Version Control**: Full Git integration for all Fabric artifacts
- **CI/CD Automation**: Automated deployments across dev, test, and production environments
- **Real-world Scenarios**: Handle schema changes, data migrations, and cross-environment promotions

### Who This Workshop Is For

Whether you're a data engineer, architect, or DevOps practitioner, this workshop will equip you with the skills to confidently manage Fabric-based solutions at scale. No prior Fabric CI/CD experience required, but basic familiarity with Microsoft Fabric and Git concepts is helpful.

## Prerequisites

Before starting, ensure you have:

1. **Microsoft Fabric Capacity** (Trial or Premium)
2. **Git Repository Access** (GitHub or Azure DevOps)
3. **Development Environment**:
   - Python 3.12+ installed
   - Git command line tools
   - VS Code with Python and Fabric extensions (recommended)
4. **Permissions**:
   - Fabric workspace admin rights
   - Repository write access

## Learning Objectives

By the end of this workshop, you will:

- Build a complete Data Engineering solution with Microsoft Fabric git and deployment pipelines  
- Configure Fabric workspaces for Git integration and synchronization  
- Master bi-directional changes: Fabric UI → Git and Git → Fabric  
- Implement environment variables and deployment rules  
- Deploy CI/CD pipelines that handle code, schema, and data changes  
- Take home production-ready code samples for your organization  

## Visual Overview

Want to understand the workshop at a glance? Check our **[Visual Workshop Diagrams](./workshop-diagrams.md)**:
- **Workshop Flow** - Complete journey with checkpoints and timing
- **Purpose & Architecture** - What you'll build and why
- **Skills Progression** - From beginner to advanced
- **Business Value** - ROI and transformation benefits
- **Before vs After** - Your transformation journey

## Solution Architecture

You'll build a practical data engineering solution using public datasets, designed to demonstrate real-world complexity:

![Diagram of the solution you will build today](screenshots/novelty-solution.png)

**Key Components:**
- **2 Lakehouses**: Bronze (raw data) and Silver (processed data)
- **3 Spark Notebooks**: Data transformation logic
- **2 Copy Jobs**: Data loading
- **1 Semantic Model**: Business logic layer
- **1 Power BI Report**: End-user analytics

## Workshop Modules

> [!IMPORTANT]
> **START HERE**: Each module builds on the previous one. Complete them in sequence for the best learning experience.
> 
> **Exercise Tracking**: Each module contains 4-6 exercises with clear checkpoints. Track your progress within each module!

### Getting Started (9:00 AM - 10:30 AM)

| Time | Module | Duration | What You'll Do |
|------|--------|----------|----------------|
| 9:00 AM | **[Module 1: Environment Setup](./configuration/start.md)** | 30 min | • Install fabric-cli tool<br>• Configure Fabric workspace<br>• Connect to Git repository<br>• Validate round-trip sync |
| 9:30 AM | **[Module 2: First Deployment](./deployment/bootstrap.md)** | 30 min | • Deploy the baseline solution<br>• Explore medallion architecture<br>• Run initial deployment pipeline<br>• Verify Power BI report<br>**→ CHECKPOINT #1** |
| 10:00 AM | **[Module 3: Version Control Basics](./versioning/start.md)** | 30 min | • Make changes in Fabric UI<br>• Commit to Git<br>• Pull changes from Git<br>• Resolve conflicts |

**Morning Break: 10:30 AM - 11:00 AM**

### Advanced Deployment (11:00 AM - 1:00 PM)

| Time | Module | Duration | What You'll Do |
|------|--------|----------|----------------|
| 11:00 AM | **[Module 4: Branch Management](./deployment/branch-out.md)** | 60 min | • Create feature branches<br>• Deploy to isolated workspaces<br>• Test changes safely<br>• Merge strategies |
| 12:00 PM | **[Module 5: Deployment Pipelines](./deployment/start.md)** | 60 min | • Configure deployment stages<br>• Set environment variables<br>• Create mapping rules<br>• Automate promotions<br>**→ CHECKPOINT #2** |

**Lunch Break: 1:00 PM - 2:00 PM**

### CI/CD Automation (2:00 PM - 5:00 PM)

| Time | Module | Duration | What You'll Do |
|------|--------|----------|----------------|
| 2:00 PM | **[Module 6: End-to-End Pipeline](./deployment/full-run.md)** | 45 min | • Deploy across dev/test/prod<br>• Validate each environment<br>• Monitor deployment status<br>• Troubleshoot issues |
| 2:45 PM | **[Module 7: Azure DevOps Integration](./deployment/azuredevops.md)** | 30 min | • Set up Azure Pipelines<br>• Configure service connections<br>• Automate with YAML<br>• Schedule deployments<br>**→ CHECKPOINT #3** |

**Afternoon Break: 3:15 PM - 3:45 PM**

| Time | Module | Duration | What You'll Do |
|------|--------|----------|----------------|
| 3:45 PM | **[Module 8: Schema Evolution](./versioning/data-artifact-changes.md)** | 45 min | • Handle column changes<br>• Manage table splits<br>• Cross-engine dependencies<br>• Data migration patterns |
| 4:30 PM | **Wrap-up & Q&A** | 30 min | • Review key concepts<br>• Discuss your scenarios<br>• Get additional resources<br>• Plan next steps |

> [!TIP]
> **Flexible Pacing**: While times are suggested, work at your own pace. If you finish early, explore the advanced scenarios or help others!

## Instructor Checkpoints

The workshop includes **3 mandatory instructor checkpoints** to ensure all participants stay synchronized:

| Checkpoint | After Module | Purpose | Key Validations |
|------------|--------------|---------|-----------------|
| **#1** | Module 2 | Foundation Ready | • Medallion architecture deployed<br>• Git sync working<br>• All participants have working environment |
| **#2** | Module 5 | Pipeline Working | • Deployment pipeline configured<br>• Variable libraries set up<br>• Rules successfully applied |
| **#3** | Module 7 | Automation Ready | • Azure DevOps integrated<br>• Service principals configured<br>• CI/CD pipeline operational |

> [!IMPORTANT]
> **Wait for instructor confirmation** at each checkpoint before proceeding. These synchronization points ensure no one gets left behind on critical technical foundations.

## Key Tools You'll Use

The `fabric-cli` and `fabric-cicd` are essential tools for implementing DevOps practices with Microsoft Fabric. For a detailed comparison, see [fabric-cli vs fabric-cicd: Capabilities and Use Cases](fabric-cli-and-cicd.md).

### fabric-cli
A powerful command-line interface for automating Fabric operations:
- Deploy workspaces and artifacts
- Manage environment configurations
- Integrate with CI/CD pipelines
- [Documentation](https://github.com/microsoft/fabric-cli)

### fabric-cicd
Production-ready patterns and templates for Fabric DevOps:
- Deployment templates and scripts
- Environment management strategies
- Testing and validation approaches
- [Documentation](https://github.com/microsoft/fabric-cicd)

## Quick Reference

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Can't connect to Fabric | Check capacity is running and you have admin rights |
| Git sync fails | Ensure workspace is linked to correct branch |
| Deployment errors | Verify artifact dependencies and naming conventions |
| Missing permissions | Request workspace admin or contributor role |

### Need Help?

- **During Workshop**: Ask instructors or fellow participants
- **Documentation**: Each module includes detailed step-by-step instructions
- **Community**: Join the conversation in our workshop channel
- **Known Issues**: Check the [troubleshooting guide](./troubleshooting.md)

## Progress Checklist

Use this checklist to track your progress:

- [ ] Environment setup complete
- [ ] First deployment successful
- [ ] Made changes through Fabric UI and Git
- [ ] Created feature branch and workspace
- [ ] Configured deployment pipeline
- [ ] Deployed to all environments (dev/test/prod)
- [ ] Set up Azure DevOps automation
- [ ] Handled schema changes successfully

## After the Workshop

### Next Steps
1. **Apply to Your Projects**: Implement these patterns in your organization
2. **Explore Advanced Scenarios**: Dive into the additional resources below
3. **Share Knowledge**: Enable your team with Fabric CI/CD best practices
4. **Contribute**: Submit improvements or new scenarios to this repository

### Roadmap

We're continuously expanding this workshop with:
- GitHub Actions integration
- Terraform infrastructure as code
- Advanced view patterns in Git
- Multi-tenant deployment strategies

![Diagram of the complete solution roadmap](screenshots/future-solution-roadmap.png)

## Additional Resources

### Related Microsoft Fabric Workshops

| Workshop | Best For | Link |
|----------|----------|------|
| **Lakehouse Fundamentals** | Learning data integration patterns | [Build Your First Lakehouse](https://github.com/ekote/Build-Your-First-End-to-End-Lakehouse-Solution) |
| **Production Operations** | Monitoring and optimization | [Fabric Toolbox](https://github.com/microsoft/fabric-toolbox) |
| **Power BI CI/CD** | Report deployment automation | [Power BI CI/CD Sample](https://github.com/RuiRomano/fabric-cli-powerbi-cicd-sample) |
| **Data Warehousing** | Understanding medallion architecture | [FabCon DW Workshop](https://aka.ms/FabConDW) |

### Recommended Learning Path

1. **Foundation** → Complete a Lakehouse or Data Warehousing workshop
2. **DevOps** → This workshop (Git/CI/CD)
3. **Operations** → Add monitoring and optimization
4. **Specialization** → Explore specific scenarios (Power BI, Real-Time, etc.)

## Contributing

We welcome contributions! Please:
- Submit issues for bugs or feature requests
- Create pull requests for improvements
- Share your organization's patterns and practices
- Help expand the scenario library

## Contact & Support

- **Workshop Issues**: [GitHub Issues](https://github.com/Clouds-on-Mars/fabric-cicd-vienna26/issues)
- **General Questions**: [Microsoft Fabric Community](https://community.fabric.microsoft.com/)
- **Documentation**: [Microsoft Fabric Docs](https://learn.microsoft.com/fabric)

---

**Ready to start?** → [Begin with Module 1: Environment Setup](./configuration/start.md)

**Enjoy the workshop!**

---

<p align="center">
  <sub>Last updated: January 2026 | Data Community Day Vienna 2026</sub>
</p>

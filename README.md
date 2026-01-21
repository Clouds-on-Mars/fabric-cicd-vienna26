# Git and CI/CD Mastery Inside Fabric Data Engineering

**Data Community Day Vienna 2026** | January 22, 2026 | JUFA Wien City

Build, version, and deploy Microsoft Fabric solutions at scale.

---

## Quick Start

### Step 0: Claim Your Workshop Credentials

Before you begin, claim your Fabric login credentials:

1. Go to the [**Workshop Credentials Sheet**](https://docs.google.com/spreadsheets/d/1Xz7DP_iV_xuMCDLoFELGTHVsb49bpNMuQhqn1wPNDv4/edit?usp=sharing)
2. Find an available row (one without a name in the "Claimed By" column)
3. **Put your name** in the "Claimed By" column to reserve those credentials
4. Use the **Login** and **Password** from that row to sign into Microsoft Fabric

>  **Important**: Each participant should claim only ONE set of credentials.

### Workshop Modules

| Step | Action |
|:----:|--------|
| 1 | [Set up your environment](./configuration/module1-environment-setup.md) |
| 2 | [Deploy baseline solution](./deployment/module2-first-deployment.md) |
| 3 | [Learn version control](./versioning/module3-version-control.md) |
| 4 | [Build CI/CD pipelines](./deployment/module5-deployment-pipelines.md) |

---

## If You Get Stuck During the Workshop

1. **Check the module page you're on**
   - Scroll to the bottom of the current module (e.g. Module 1, 2, 3…)
   - Look for the **Resync** or **Troubleshooting** section for that module.

2. **Use the central troubleshooting guide**
   - Open [`troubleshooting.md`](./troubleshooting.md)
   - Find the section matching your problem (setup, Fabric login, Git, pipelines, etc.).

3. **Ask for help**
   - If you're still blocked after 5 minutes, raise your hand or ask the trainers.
   - It's better to ask early than to fall behind.

> You don't need to read everything. Use these steps as your "panic button" when something doesn't work.

---

## Workshop Modules

### Morning Session (9:00 - 13:00)

| Module | Time | Description |
|--------|------|-------------|
| [**1. Environment Setup**](./configuration/module1-environment-setup.md) | 30 min | Install tools, configure workspace, connect Git |
| [**2. First Deployment**](./deployment/module2-first-deployment.md) | 30 min | Deploy medallion architecture solution |
| [**3. Version Control**](./versioning/module3-version-control.md) | 30 min | Commit, pull, resolve conflicts |
| *Break* | 30 min | |
| [**4. Branch Management**](./deployment/module4-branch-management.md) | 60 min | Feature branches, isolated workspaces |
| [**5. Deployment Pipelines**](./deployment/module5-deployment-pipelines.md) | 60 min | Stages, variables, automation |

### Afternoon Session (14:00 - 17:00)

| Module | Time | Description |
|--------|------|-------------|
| [**6. End-to-End Pipeline**](./deployment/full-run.md) | 45 min | Deploy across dev/test/prod |
| [**7. Azure DevOps**](./deployment/azuredevops.md) | 45 min | YAML pipelines, service connections |
| *Break* | 30 min | |
| [**8. Schema Evolution**](./versioning/data-artifact-changes.md) | 45 min | Handle breaking changes |
| **Wrap-up & Q&A** | 30 min | Review and next steps |

### Post-Workshop (Optional)

| Module | Time | Description |
|--------|------|-------------|
| [**0. Terraform**](./infrastructure/module0-terraform.md) | 30 min | Deploy workspaces via Infrastructure as Code |

---

## What You'll Build

```
Bronze Lakehouse → Spark Notebooks → Silver Lakehouse → Semantic Model → Power BI
        ↓                                      ↓
   [Git Repository] ←→ [CI/CD Pipeline] → [Dev/Test/Prod Workspaces]
```

**Components**: 2 Lakehouses, 3 Notebooks, 2 Copy Jobs, 1 Semantic Model, 1 Report

---

## Prerequisites

- Git repository access (GitHub or Azure DevOps)
- Python 3.11+, Git CLI, VS Code
- Workspace admin permissions

---

## Key Tools

| Tool | Purpose | Docs |
|------|---------|------|
| **fabric-cli** | Command-line automation | [GitHub](https://github.com/microsoft/fabric-cli) |
| **fabric-cicd** | Deployment patterns | [GitHub](https://github.com/microsoft/fabric-cicd) |

See [fabric-cli vs fabric-cicd comparison](./fabric-cli-and-cicd.md)

---

## Resources

| Resource | Link |
|----------|------|
| Visual Diagrams | [workshop-diagrams.md](./workshop-diagrams.md) |
| Troubleshooting | [troubleshooting.md](./troubleshooting.md) |
| Terraform Module | [infrastructure/](./infrastructure/) |
| Azure DevOps Samples | [AzDO/](./AzDO/) |

---

## Reference & Advanced Materials

These are optional supporting materials you can use during or after the workshop:

| Material | Description |
|----------|-------------|
| [`troubleshooting.md`](./troubleshooting.md) | Central troubleshooting guide for common problems |
| [`fabric-cli-and-cicd.md`](./fabric-cli-and-cicd.md) | Conceptual comparison of `fabric-cli` and `fabric-cicd` |
| [`workshop-diagrams.md`](./workshop-diagrams.md) | Visual diagrams of the solution and workshop flow |
| [`deck/`](./deck/) | Slide decks used by instructors (you don't need them open while coding) |
| [`AzDO/`](./AzDO/) | Azure DevOps sample YAML and templates for deeper exploration |
| [`infrastructure/`](./infrastructure/) | Terraform-based infrastructure as code (Module 0 – optional/pre-work) |

---

## Trainers

[Bartosz Burger](https://www.linkedin.com/in/bartoszburger/) | [Michal Kachniarz](https://www.linkedin.com/in/michalkachniarz/) | [Przemyslaw Harazny](https://www.linkedin.com/in/przemyslaw-harazny/) | [Estera Kot](https://www.linkedin.com/in/esterakot/)

---

**Ready?** → [Start Module 1](./configuration/module1-environment-setup.md)

<sub>Data Community Day Vienna 2026 | [Issues](https://github.com/Clouds-on-Mars/fabric-cicd-vienna26/issues)</sub>

### Repository Structure (Modules ⇄ Files)

```text
Fabric-DE-CICD/
  configuration/
    module1-environment-setup.md     # Module 1: Environment Setup
  deployment/
    module2-first-deployment.md      # Module 2: First Deployment
    module4-branch-management.md     # Module 4: Branch Management
    module5-deployment-pipelines.md  # Module 5: Deployment Pipelines
    full-run.md                      # Module 6: End-to-End Pipeline
    azuredevops.md                   # Module 7: Azure DevOps Pipelines
  versioning/
    module3-version-control.md       # Module 3: Version Control Basics
    data-artifact-changes.md         # Module 8: Schema Changes (Advanced)
  infrastructure/
    module0-terraform.md             # Module 0: Terraform (Optional)
  troubleshooting.md                 # Troubleshooting guide
  fabric-cli-and-cicd.md             # Tool comparison
  workshop-diagrams.md               # Visual diagrams
```

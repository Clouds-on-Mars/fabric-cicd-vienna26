# Git and CI/CD Mastery Inside Fabric Data Engineering

**Data Community Day Vienna 2026** | January 22, 2026 | JUFA Wien City

Build, version, and deploy Microsoft Fabric solutions at scale.

---

## Quick Start

| Step | Action |
|:----:|--------|
| 1 | [Set up your environment](./configuration/start.md) |
| 2 | [Deploy baseline solution](./deployment/bootstrap.md) |
| 3 | [Learn version control](./versioning/start.md) |
| 4 | [Build CI/CD pipelines](./deployment/start.md) |

---

## Workshop Modules

### Pre-Workshop (Optional)

| Module | Time | Description |
|--------|------|-------------|
| [**0. Terraform**](./infrastructure/terraform.md) | 30 min | Deploy workspaces via Infrastructure as Code |

### Morning Session (9:00 - 13:00)

| Module | Time | Description |
|--------|------|-------------|
| [**1. Environment Setup**](./configuration/start.md) | 30 min | Install tools, configure workspace, connect Git |
| [**2. First Deployment**](./deployment/bootstrap.md) | 30 min | Deploy medallion architecture solution |
| [**3. Version Control**](./versioning/start.md) | 30 min | Commit, pull, resolve conflicts |
| *Break* | 30 min | |
| [**4. Branch Management**](./deployment/branch-out.md) | 60 min | Feature branches, isolated workspaces |
| [**5. Deployment Pipelines**](./deployment/start.md) | 60 min | Stages, variables, automation |

### Afternoon Session (14:00 - 17:00)

| Module | Time | Description |
|--------|------|-------------|
| [**6. End-to-End Pipeline**](./deployment/full-run.md) | 45 min | Deploy across dev/test/prod |
| [**7. Azure DevOps**](./deployment/azuredevops.md) | 30 min | YAML pipelines, service connections |
| *Break* | 30 min | |
| [**8. Schema Evolution**](./versioning/data-artifact-changes.md) | 45 min | Handle breaking changes |
| **Wrap-up & Q&A** | 30 min | Review and next steps |

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

- Microsoft Fabric Capacity (Trial or Premium)
- Git repository access (GitHub or Azure DevOps)
- Python 3.12+, Git CLI, VS Code
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

## Trainers

[Bartosz Burger](https://www.linkedin.com/in/bartoszburger/) | [Michal Kachniarz](https://www.linkedin.com/in/michalkachniarz/) | [Przemyslaw Harazny](https://www.linkedin.com/in/przemyslaw-harazny/) | [Estera Kot](https://www.linkedin.com/in/esterakot/)

---

**Ready?** → [Start Module 1](./configuration/start.md)

<sub>Data Community Day Vienna 2026 | [Issues](https://github.com/Clouds-on-Mars/fabric-cicd-vienna26/issues)</sub>

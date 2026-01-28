# AI Context Shared

**Last Updated**: 2026-01-28 (Automation Test)

Shared AI context files for BonoJovi's Rust projects.

## Purpose

This repository contains common AI context files that are shared across multiple projects via Git submodules:

- [Promps](https://github.com/BonoJovi/Promps) - Visual Prompt Builder (Free)
- [Promps-Pro](https://github.com/BonoJovi/Promps-Pro) - Visual Prompt Builder (Pro)
- [Promps-Ent](https://github.com/BonoJovi/Promps-Ent) - Visual Prompt Builder (Enterprise)
- [Promps-Edu](https://github.com/BonoJovi/Promps-Edu) - Visual Prompt Builder (Education)
- [KakeiBonByRust](https://github.com/BonoJovi/KakeiBonByRust) - Personal finance manager
- [Baconian](https://github.com/BonoJovi/Baconian) - Scientific method assistant

## Structure

```
ai-context-shared/
├── .github/workflows/   # GitHub Actions for auto-update
│   ├── notify-dependents.yml
│   └── update-submodule-template.yml
├── scripts/             # Utility scripts
│   └── pull-all-repos.sh
├── developer/           # Developer profile
│   └── YOSHIHIRO_NAKAHARA_PROFILE.md
├── analytics/           # Cross-project SEO tracking
│   └── SEO_Keywords_Tracking.md
├── methodology/         # Development methodology
│   ├── AI_COLLABORATION.md
│   ├── DESIGN_PHILOSOPHY.md
│   └── SCALE_ARCHITECTURE.md
├── insights/            # Architectural and development insights
│   ├── AI_COGNITIVE_AUGMENTATION.md
│   ├── NECESSITY_DRIVEN_DESIGN.md
│   └── ...
├── workflows/           # Common workflow guides
│   ├── CRITICAL_OPERATIONS.md
│   ├── DOCUMENTATION_CREATION.md
│   └── GITHUB_PROJECTS.md
└── README.md
```

## Usage

### As a Git Submodule

In your project:

```bash
# Add as submodule
git submodule add https://github.com/BonoJovi/ai-context-shared.git .ai-context/shared

# Update to latest
git submodule update --remote
```

### Reference from CLAUDE.md

```markdown
**Shared Context** (via submodule):
- Developer Profile: `@.ai-context/shared/developer/YOSHIHIRO_NAKAHARA_PROFILE.md`
- Methodology: `@.ai-context/shared/methodology/AI_COLLABORATION.md`
- Insights: `@.ai-context/shared/insights/`
```

## Contents

### developer/
Developer profile containing background, skills, and career context.

### analytics/
SEO keyword tracking for the BonoJovi account across all projects.

### methodology/
Core development methodologies:
- **AI_COLLABORATION.md**: AI-assisted development patterns (Three-layer PDCA, etc.)
- **DESIGN_PHILOSOPHY.md**: Architectural principles
- **SCALE_ARCHITECTURE.md**: Scale-aware design considerations

### insights/
Architectural and development insights derived from real-world experience:
- AI cognitive augmentation
- Necessity-driven design
- Software as organism
- Why refactoring fails
- And more...

### workflows/
Common workflow documentation:
- **CRITICAL_OPERATIONS.md**: Release checklists, repository verification (prevents common mistakes)
- **DOCUMENTATION_CREATION.md**: Guidelines for creating documentation
- **GITHUB_PROJECTS.md**: GitHub project management

## Automated Submodule Updates

When this repository is pushed to `main`, GitHub Actions automatically notifies all dependent repositories to update their submodules.

### How it works

1. Push to `ai-context-shared` main branch
2. GitHub Actions sends `repository_dispatch` to all dependent repos
3. Each repo's workflow updates the submodule and commits
4. Run `pull-all-repos.sh` locally to sync

### Local sync script

```bash
# Safe pull (skips repos with uncommitted changes)
./scripts/pull-all-repos.sh

# Force pull (stashes uncommitted changes)
./scripts/pull-all-repos.sh --force
```

### Setup for new dependent repository

1. Copy `.github/workflows/update-submodule-template.yml` to the repo
2. Rename to `update-ai-context-shared.yml`
3. Add repo to `notify-dependents.yml` in this repository

## Why Shared?

These files represent:
1. **Common knowledge** - Developer profile, methodology, insights
2. **Cross-project tracking** - SEO analytics
3. **Reusable processes** - Documentation creation, project management

By sharing via submodule:
- Single source of truth
- Updates propagate to all projects
- No manual synchronization needed

## License

MIT License - Same as parent projects.

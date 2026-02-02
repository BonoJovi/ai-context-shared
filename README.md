# AI Context Shared

**Last Updated**: 2026-02-03

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
├── scripts/             # Utility scripts
├── developer/           # Developer profile
│   └── YOSHIHIRO_NAKAHARA_PROFILE.md
├── analytics/           # Cross-project SEO tracking
│   ├── ONLINE_IMPACT_SUMMARY.md      # Condensed summary (~100 lines)
│   ├── SEO_Keywords_Tracking.md
│   └── archive/                       # Detailed analysis
├── methodology/         # Development methodology
│   ├── AI_COLLABORATION.md           # Core AI collaboration patterns
│   ├── DESIGN_PHILOSOPHY.md          # Architectural principles
│   └── SCALE_ARCHITECTURE.md         # Scale-aware design
├── insights/            # Consolidated insights
│   ├── INSIGHTS_OVERVIEW.md          # Summary (~300 lines, 93% reduction)
│   └── archive/                       # Original detailed files (9 files)
├── workflows/           # Common workflow guides
│   ├── CRITICAL_OPERATIONS.md
│   ├── DOCUMENTATION_CREATION.md
│   └── GITHUB_PROJECTS.md
├── references/          # Extracted detailed content
│   └── CPU_ARCHITECTURE_ANALOGY.md   # Detailed CPU/PDCA analogy
├── projects/            # Project paths
│   └── PROJECT_PATHS.md
└── README.md
```

## Token Optimization (2026-02-03)

This repository was optimized to reduce token usage:

| Category | Before | After | Reduction |
|----------|--------|-------|-----------|
| insights/ | 4,257 lines | ~300 lines | 93% |
| analytics/ | 1,209 lines | ~472 lines | 61% |
| AI_COLLABORATION.md | 1,692 lines | ~1,160 lines | 31% |
| DESIGN_PHILOSOPHY.md | 1,222 lines | ~1,033 lines | 15% |
| DOCUMENTATION_CREATION.md | 653 lines | ~590 lines | 10% |
| **Total** | **~9,258 lines** | **~5,500 lines** | **~41%** |

**Strategy**: Consolidate detailed content into overview files, move originals to `archive/` folders.

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
- **ONLINE_IMPACT_SUMMARY.md**: Condensed impact metrics and opportunities
- **SEO_Keywords_Tracking.md**: SEO keyword tracking across all projects
- **archive/**: Detailed regional analysis, bot analysis, GA4 deep dives

### methodology/
Core development methodologies:
- **AI_COLLABORATION.md**: AI-assisted development patterns (Three-layer PDCA, etc.)
- **DESIGN_PHILOSOPHY.md**: Architectural principles
- **SCALE_ARCHITECTURE.md**: Scale-aware design considerations

### insights/
- **INSIGHTS_OVERVIEW.md**: Consolidated summary of all insights
- **archive/**: Original detailed files (9 documents covering software philosophy, AI collaboration, refactoring, etc.)

### workflows/
Common workflow documentation:
- **CRITICAL_OPERATIONS.md**: Release checklists, repository verification
- **DOCUMENTATION_CREATION.md**: Guidelines for creating documentation
- **GITHUB_PROJECTS.md**: GitHub project management

### references/
Extracted detailed content:
- **CPU_ARCHITECTURE_ANALOGY.md**: Detailed CPU/PDCA parallel explanation (extracted from AI_COLLABORATION.md)

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

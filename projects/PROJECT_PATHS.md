# Project Paths

**Last Updated**: 2026-01-22
**Purpose**: Project directory paths for AI context persistence across /compact

---

## Rust Projects

| Project | Path |
|---------|------|
| **KakeiBonByRust** | `$HOME/Data1/Linux/Projects/Rust/KakeiBonByRust/` |
| **Promps** | `$HOME/Data1/Linux/Projects/Rust/Promps/` |

---

## Project Status Summary

### KakeiBonByRust
- **Description**: Household budget app for low-vision users
- **Tech Stack**: Rust, Tauri v2, SQLite
- **Tests**: 800+ test cases
- **Key TODO**: ARIA support planned for v1.4.0 (2026-05)

### Promps
- **Description**: AI prompt generator with Blockly.js GUI
- **Tech Stack**: Rust, Tauri v2, Blockly.js
- **Tests**: 102 tests (Backend 26 + Frontend 76)
- **Current Phase**: Phase 3-2

---

## Utility Scripts

| Script | Path | Description |
|--------|------|-------------|
| **analytics.sh** | `$HOME/Data1/Linux/Projects/Rust/promps-website/scripts/analytics.sh` | Cloudflare Analytics for promps.org |

**Note**: User has symlinks in `~/bin/` for global access.

---

## Notes

- All projects use Git submodule `ai-context-shared/` for shared context
- TODO files are located at `<project>/TODO.md`
- AI context files are located at `<project>/.ai-context/`

# Critical Operations Checklist

**Purpose**: Prevent common mistakes in AI-assisted development
**When to check**: At session start, before commits, before releases

---

## 1. Session Start - Repository Verification

**ALWAYS verify before making changes:**

```bash
pwd                    # Confirm working directory
git remote -v          # Confirm repository
git branch --show-current  # Confirm branch
```

**Why**: Prevents editing wrong repository (especially with multiple projects open)

---

## 2. Release Checklist - Version Files

**Update ALL version files (not just one!):**

| File | Field | Example |
|------|-------|---------|
| `Cargo.toml` | `version = "X.Y.Z"` | Rust package version |
| `tauri.conf.json` | `"version": "X.Y.Z"` | Tauri app version |
| `package.json` | `"version": "X.Y.Z"` | npm/release name |

**Verification command:**
```bash
grep -h "version" Cargo.toml tauri.conf.json package.json | head -3
```

**Common mistake**: Updating only Cargo.toml, forgetting package.json

---

## 3. Pre-Commit Checklist

- [ ] All tests passing (`cargo test`)
- [ ] No unintended files staged (`git status`)
- [ ] Correct branch (`git branch --show-current`)
- [ ] Pull before push (`git pull --rebase`)

---

## 4. Release Workflow Summary

1. **Update versions** (3 files above)
2. **Update documentation** (README.md, ESSENTIAL.md, etc.)
3. **Run tests** (cargo test + npm test)
4. **Commit & push** to dev
5. **Cherry-pick to main** (for stable releases)
6. **Create tag on main** (`git tag vX.Y.Z`)
7. **Push tag** (`git push origin vX.Y.Z`)
8. **Verify GitHub Actions** build completes

---

## 5. Quick Verification Commands

```bash
# All-in-one pre-release check
pwd && git remote -v && git branch --show-current && \
grep -h "version" Cargo.toml tauri.conf.json package.json 2>/dev/null | head -3
```

---

**Remember**: When in doubt, verify first. A few seconds of checking prevents hours of fixing.

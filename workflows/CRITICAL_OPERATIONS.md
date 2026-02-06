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

### AI Must Ask User

**When to ask which repository to work on:**
- At the start of development work
- When switching between tasks
- When working with related repositories (e.g., Free/Pro versions, main/website repos)

**Example prompt:**
> "Which repository should I make changes to? (e.g., Promps, Promps-Pro, promps-website)"

**Why**: User may have multiple related repositories. Assuming the wrong one leads to wasted effort and potential confusion.

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

## 3. Branch Operation Rules

**コードの編集は必ず `dev` ブランチで行う。**

- 新機能・修正・スクリプト追加など、すべてのコード変更は `dev` で実施
- `main` ブランチでは cherry-pick もしくは merge のみとする（特に理由がない限り）
- フロー: `dev` で作業 → テスト → `dev` から `main` へ merge

**Why**: 全エディション（Free/Pro/Ent）で統一されたワークフローを維持し、ビルドテスト時のブランチ切り替え手順を一貫させるため

**GitHubへのタグプッシュ前に、必ずローカルでpre-releaseチェックスクリプトを実行する。**

```bash
./scripts/pre-release-check.sh
```

- バージョン整合性・ビルド・テストを一括で検証してからタグをプッシュする
- CI失敗を未然に防ぎ、リリースの手戻りを回避するため

---

## 4. Pre-Commit Checklist

- [ ] All tests passing (`cargo test`)
- [ ] No unintended files staged (`git status`)
- [ ] Correct branch (`git branch --show-current`)
- [ ] Pull before push (`git pull --rebase`)

---

## 5. Release Workflow Summary

1. **Update versions** (3 files above)
2. **Update documentation** (README.md, ESSENTIAL.md, etc.)
3. **Run tests** (cargo test + npm test)
4. **Commit & push** to dev
5. **Cherry-pick to main** (for stable releases)
6. **Create tag on main** (`git tag vX.Y.Z`)
7. **Push tag** (`git push origin vX.Y.Z`)
8. **Verify GitHub Actions** build completes

---

## 6. Quick Verification Commands

```bash
# All-in-one pre-release check
pwd && git remote -v && git branch --show-current && \
grep -h "version" Cargo.toml tauri.conf.json package.json 2>/dev/null | head -3
```

---

**Remember**: When in doubt, verify first. A few seconds of checking prevents hours of fixing.

# 快速建立 Workflow Repository

## 5 分鐘快速設置

### Step 1: 創建 GitHub Repository

1. 前往 GitHub，點擊 "New repository"
2. Repository name: `github-workflow-template`
3. Description: `Reusable GitHub workflow configuration`
4. 選擇 Public 或 Private
5. 點擊 "Create repository"

### Step 2: 準備本地目錄

```bash
# 創建本地目錄
mkdir github-workflow-template
cd github-workflow-template

# 初始化 Git
git init
git remote add origin https://github.com/your-org/github-workflow-template.git
```

### Step 3: 組織檔案結構

從您下載的檔案中，按以下結構組織：

```bash
# 創建目錄
mkdir -p workflows templates scripts docs

# === 移動 Workflow 檔案 ===
# 將以下檔案移到 workflows/ 目錄：
workflows/
├── ci-checks-simplified.yml    # 最小化版本
├── ci-checks.yml               # 完整版本
└── branch-management.yml       # 分支管理

# === 移動模板檔案 ===
# 將以下檔案移到 templates/ 目錄：
templates/
├── pull_request_template.md
└── CODEOWNERS                  # 需要自訂團隊資訊

# === 移動腳本 ===
# 將以下檔案移到 scripts/ 目錄：
scripts/
├── setup.sh                    # 設置腳本
└── update.sh                   # 更新腳本

# === 移動文檔 ===
# 將以下檔案移到 docs/ 目錄：
docs/
├── SUBMODULE_SETUP.md         # Submodule 使用指南
├── MINIMAL_SETUP.md           # 最小化版本說明
├── VERSION_COMPARISON.md      # 版本比較
├── QUICK_REFERENCE.md         # 快速參考
└── START_HERE.md              # 開始指南
```

### Step 4: 完整的命令序列

```bash
# 在您的下載目錄執行

# 創建目標目錄
mkdir -p github-workflow-template/{workflows,templates,scripts,docs}
cd github-workflow-template

# 複製 workflow 檔案
cp /path/to/downloads/ci-checks-simplified.yml workflows/
cp /path/to/downloads/ci-checks.yml workflows/
cp /path/to/downloads/branch-management.yml workflows/

# 複製模板
cp /path/to/downloads/pull_request_template.md templates/
cp /path/to/downloads/CODEOWNERS templates/

# 複製腳本
cp /path/to/downloads/setup.sh scripts/
cp /path/to/downloads/update.sh scripts/
chmod +x scripts/*.sh  # 設置為可執行

# 複製文檔
cp /path/to/downloads/SUBMODULE_SETUP.md docs/
cp /path/to/downloads/MINIMAL_SETUP.md docs/
cp /path/to/downloads/VERSION_COMPARISON.md docs/
cp /path/to/downloads/QUICK_REFERENCE.md docs/
cp /path/to/downloads/START_HERE.md docs/

# 複製主要 README
cp /path/to/downloads/WORKFLOW_REPO_README.md README.md
```

### Step 5: 自訂 CODEOWNERS

編輯 `templates/CODEOWNERS`，將範例團隊名稱替換為您的實際團隊：

```bash
# 編輯檔案
vim templates/CODEOWNERS

# 或使用其他編輯器
code templates/CODEOWNERS
```

將以下內容更新為您的團隊資訊：
```
# 將 @your-org/core-team 改為您的實際團隊
*       @your-org/core-team

# 將 @your-org/frontend-team 改為您的前端團隊
*.jsx   @your-org/frontend-team

# 將 @your-org/backend-team 改為您的後端團隊
/src/api/   @your-org/backend-team
```

### Step 6: 初始提交

```bash
# 初始化 Git（如果還沒有）
git init

# 添加所有檔案
git add .

# 提交
git commit -m "Initial commit: GitHub workflow template"

# 連接遠端並推送
git remote add origin https://github.com/your-org/github-workflow-template.git
git branch -M main
git push -u origin main
```

### Step 7: 創建第一個 Tag

```bash
# 創建版本標籤
git tag -a v1.0.0 -m "Release v1.0.0 - Initial stable release"
git push origin v1.0.0
```

完成！您的 workflow repository 已經建立完成。

---

## 最終目錄結構

您的 repository 應該看起來像這樣：

```
github-workflow-template/
├── README.md
├── workflows/
│   ├── ci-checks-simplified.yml
│   ├── ci-checks.yml
│   └── branch-management.yml
├── templates/
│   ├── pull_request_template.md
│   └── CODEOWNERS
├── scripts/
│   ├── setup.sh
│   └── update.sh
└── docs/
    ├── SUBMODULE_SETUP.md
    ├── MINIMAL_SETUP.md
    ├── VERSION_COMPARISON.md
    ├── QUICK_REFERENCE.md
    └── START_HERE.md
```

---

## 在新專案中使用

### 方法 1: 使用自動化腳本（推薦）

```bash
# 在您的新專案中
cd my-new-project

# 添加 submodule
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 執行設置腳本
./.github-workflow/scripts/setup.sh

# 提交
git add .
git commit -m "chore: setup workflow"
git push
```

### 方法 2: 手動設置

```bash
# 添加 submodule
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 創建目錄
mkdir -p .github/workflows

# 複製檔案（選擇最小化版本）
cp .github-workflow/workflows/ci-checks-simplified.yml .github/workflows/ci-checks.yml
cp .github-workflow/workflows/branch-management.yml .github/workflows/
cp .github-workflow/templates/pull_request_template.md .github/
cp .github-workflow/templates/CODEOWNERS .github/

# 提交
git add .github/ .github-workflow/ .gitmodules
git commit -m "chore: setup workflow"
git push
```

---

## 驗證設置

### 檢查 1: Repository 結構

```bash
# 在 workflow repository 中
tree -L 2

# 應該看到：
# ├── workflows/
# ├── templates/
# ├── scripts/
# └── docs/
```

### 檢查 2: 腳本可執行性

```bash
# 檢查腳本權限
ls -l scripts/

# 應該看到：
# -rwxr-xr-x ... setup.sh
# -rwxr-xr-x ... update.sh
```

### 檢查 3: Git 狀態

```bash
git status

# 應該看到：
# On branch main
# nothing to commit, working tree clean
```

### 檢查 4: 測試在專案中使用

```bash
# 創建測試專案
mkdir test-project
cd test-project
git init

# 添加 workflow
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 執行設置
./.github-workflow/scripts/setup.sh

# 檢查結果
ls -la .github/workflows/
# 應該看到：
# ci-checks.yml
# branch-management.yml
```

---

## 常見問題

### Q: 腳本沒有執行權限？
```bash
chmod +x .github-workflow/scripts/*.sh
```

### Q: 如何更新 CODEOWNERS 範例？
```bash
# 編輯 templates/CODEOWNERS
vim templates/CODEOWNERS

# 提交
git add templates/CODEOWNERS
git commit -m "docs: update CODEOWNERS example"
git push
```

### Q: 如何添加新的 workflow？
```bash
# 在 workflows/ 目錄創建新檔案
vim workflows/my-new-workflow.yml

# 提交
git add workflows/my-new-workflow.yml
git commit -m "feat: add new workflow"
git push

# 創建新版本
git tag -a v1.1.0 -m "Add new workflow"
git push origin v1.1.0
```

### Q: 如何測試變更？
```bash
# 創建測試分支
git checkout -b test-changes

# 進行修改...
git add .
git commit -m "test: workflow changes"

# 在測試專案中使用測試分支
cd ../test-project
git submodule add -b test-changes \
  https://github.com/your-org/github-workflow-template .github-workflow
```

---

## 下一步

1. **自訂配置**: 根據團隊需求調整 CODEOWNERS 和 workflow 設定
2. **文檔更新**: 更新 README.md 添加您的使用說明
3. **通知團隊**: 告知團隊成員新的 workflow repository
4. **在專案中使用**: 在實際專案中添加並測試
5. **持續改進**: 根據反饋持續優化配置

---

## 額外資源

- GitHub Submodules: https://git-scm.com/book/en/v2/Git-Tools-Submodules
- GitHub Actions: https://docs.github.com/en/actions
- Reusable Workflows: https://docs.github.com/en/actions/using-workflows/reusing-workflows

---

恭喜！您已成功建立 workflow repository，現在可以在多個專案中重用這些配置了。

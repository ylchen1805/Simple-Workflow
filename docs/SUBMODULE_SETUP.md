# 將 Workflow 作為 Submodule 使用

## 概述

將 workflow 配置獨立成一個 repository，然後在各個專案中作為 submodule 引入，可以實現：
- 多個專案共享同一套 workflow 配置
- 統一管理和更新
- 保持配置一致性

---

## 方案一：符號連結（推薦）

### Step 1: 創建 Workflow Repository

創建一個名為 `github-workflow-template` 的 repository，結構如下：

```
github-workflow-template/
├── README.md
├── workflows/
│   ├── ci-checks.yml              # 或 ci-checks-simplified.yml
│   └── branch-management.yml
├── templates/
│   ├── pull_request_template.md
│   └── CODEOWNERS
├── docs/
│   ├── SETUP.md
│   └── USAGE.md
└── scripts/
    └── setup.sh                    # 自動設置腳本
```

### Step 2: 在新專案中添加 Submodule

```bash
# 在您的專案根目錄
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 初始化 submodule
git submodule update --init --recursive
```

### Step 3: 創建符號連結

**在 Unix/Linux/macOS:**
```bash
# 創建 .github 目錄（如果不存在）
mkdir -p .github

# 創建符號連結
ln -s ../.github-workflow/workflows .github/workflows
ln -s ../.github-workflow/templates/pull_request_template.md .github/pull_request_template.md
ln -s ../.github-workflow/templates/CODEOWNERS .github/CODEOWNERS

# 提交
git add .github .github-workflow .gitmodules
git commit -m "chore: add workflow submodule"
git push
```

**在 Windows:**
```bash
# 使用管理員權限
mklink /D .github\workflows .github-workflow\workflows
mklink .github\pull_request_template.md .github-workflow\templates\pull_request_template.md
mklink .github\CODEOWNERS .github-workflow\templates\CODEOWNERS
```

### Step 4: 設置 .gitignore（重要）

在專案根目錄的 `.gitignore` 中添加：
```
# 不要忽略符號連結本身
!.github/workflows
!.github/pull_request_template.md
!.github/CODEOWNERS
```

---

## 方案二：自動複製腳本

如果不想使用符號連結（例如某些環境不支援），可以使用自動複製腳本。

### Step 1: 創建自動設置腳本

在 workflow repository 中創建 `scripts/setup.sh`:

```bash
#!/bin/bash

echo "設置 GitHub Workflow..."

# 獲取腳本所在目錄
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$WORKFLOW_DIR")"

# 創建目錄
mkdir -p "$PROJECT_ROOT/.github/workflows"

# 複製檔案
echo "複製 workflow 檔案..."
cp "$WORKFLOW_DIR/workflows/"*.yml "$PROJECT_ROOT/.github/workflows/"

echo "複製 PR 模板..."
cp "$WORKFLOW_DIR/templates/pull_request_template.md" "$PROJECT_ROOT/.github/"

echo "複製 CODEOWNERS (如果存在)..."
if [ -f "$WORKFLOW_DIR/templates/CODEOWNERS" ]; then
    cp "$WORKFLOW_DIR/templates/CODEOWNERS" "$PROJECT_ROOT/.github/"
fi

echo ""
echo "設置完成！"
echo ""
echo "檔案已複製到："
echo "  - .github/workflows/"
echo "  - .github/pull_request_template.md"
echo "  - .github/CODEOWNERS"
echo ""
echo "下一步："
echo "1. 檢查並自訂 CODEOWNERS 檔案"
echo "2. 在 GitHub 設置分支保護規則"
echo "3. git add .github/"
echo "4. git commit -m 'chore: setup workflow'"
echo "5. git push"
```

賦予執行權限：
```bash
chmod +x scripts/setup.sh
```

### Step 2: 在新專案中使用

```bash
# 添加 submodule
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 執行設置腳本
./.github-workflow/scripts/setup.sh

# 提交
git add .github/
git commit -m "chore: setup workflow from template"
git push
```

### Step 3: 更新 Workflow

當 workflow repository 更新時：
```bash
# 更新 submodule
git submodule update --remote .github-workflow

# 重新執行設置腳本
./.github-workflow/scripts/setup.sh

# 檢查差異並提交
git diff .github/
git add .github/
git commit -m "chore: update workflow configuration"
git push
```

---

## 方案三：GitHub Actions 複用 (Reusable Workflows)

GitHub Actions 支援從其他 repository 引用 workflow。

### Step 1: 創建 Reusable Workflow

在 workflow repository 的 `workflows/ci-checks.yml` 中添加：

```yaml
name: CI Checks

on:
  workflow_call:
    inputs:
      branch_name:
        required: false
        type: string
        default: ${{ github.head_ref }}

jobs:
  branch-naming-check:
    name: Branch Naming Convention
    runs-on: ubuntu-latest
    
    steps:
      - name: Check branch name
        run: |
          BRANCH_NAME="${{ inputs.branch_name }}"
          
          if [[ "$BRANCH_NAME" == "main" || "$BRANCH_NAME" == "dev" || "$BRANCH_NAME" == "test" ]]; then
            echo "✓ Permanent branch"
            exit 0
          fi
          
          if [[ ! "$BRANCH_NAME" =~ ^(feat|fix|docs|refactor|perf|test|security|project)/.+ ]]; then
            echo "✗ Invalid branch name: $BRANCH_NAME"
            exit 1
          fi
          
          echo "✓ Valid branch name: $BRANCH_NAME"
```

### Step 2: 在新專案中引用

在新專案的 `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
    branches:
      - main
      - dev
      - test

jobs:
  call-ci-checks:
    uses: your-org/github-workflow-template/.github/workflows/ci-checks.yml@main
```

**優點**：
- 不需要複製檔案
- 自動使用最新版本
- 集中管理

**缺點**：
- PR 模板和 CODEOWNERS 仍需要複製
- workflow 必須是 public repository 或在同一組織內

---

## 推薦的 Workflow Repository 結構

```
github-workflow-template/
├── README.md
├── .github/
│   └── workflows/                  # 用於 reusable workflows
│       ├── ci-checks.yml
│       └── branch-management.yml
├── workflows/                      # 用於複製到專案
│   ├── ci-checks-simplified.yml
│   ├── ci-checks.yml
│   └── branch-management.yml
├── templates/
│   ├── pull_request_template.md
│   ├── CODEOWNERS.example
│   └── README.md
├── docs/
│   ├── SETUP.md                    # 設置指南
│   ├── MINIMAL_SETUP.md            # 最小化版本
│   ├── FULL_SETUP.md               # 完整版本
│   └── USAGE.md                    # 使用指南
└── scripts/
    ├── setup.sh                    # 自動設置腳本
    ├── update.sh                   # 更新腳本
    └── validate.sh                 # 驗證腳本
```

---

## 完整設置腳本範例

創建 `scripts/setup.sh`:

```bash
#!/bin/bash

set -e

echo "======================================"
echo "GitHub Workflow 設置腳本"
echo "======================================"
echo ""

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 獲取目錄
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$WORKFLOW_DIR")"

# 選擇版本
echo "請選擇要安裝的版本："
echo "1) 最小化版本 (推薦 - 不需要 npm)"
echo "2) 完整版本 (包含 lint, test 等)"
echo ""
read -p "請輸入選項 [1/2]: " VERSION_CHOICE

if [ "$VERSION_CHOICE" = "1" ]; then
    WORKFLOW_FILE="ci-checks-simplified.yml"
    echo -e "${GREEN}已選擇：最小化版本${NC}"
else
    WORKFLOW_FILE="ci-checks.yml"
    echo -e "${GREEN}已選擇：完整版本${NC}"
fi

echo ""
echo "開始設置..."
echo ""

# 創建目錄
mkdir -p "$PROJECT_ROOT/.github/workflows"

# 複製 workflow 檔案
echo "1. 複製 workflow 檔案..."
cp "$WORKFLOW_DIR/workflows/$WORKFLOW_FILE" "$PROJECT_ROOT/.github/workflows/ci-checks.yml"
cp "$WORKFLOW_DIR/workflows/branch-management.yml" "$PROJECT_ROOT/.github/workflows/"
echo -e "${GREEN}   ✓ 完成${NC}"

# 複製 PR 模板
echo "2. 複製 PR 模板..."
cp "$WORKFLOW_DIR/templates/pull_request_template.md" "$PROJECT_ROOT/.github/"
echo -e "${GREEN}   ✓ 完成${NC}"

# 複製 CODEOWNERS (如果需要)
echo ""
read -p "是否需要 CODEOWNERS 檔案？ [y/N]: " NEED_CODEOWNERS
if [[ "$NEED_CODEOWNERS" =~ ^[Yy]$ ]]; then
    cp "$WORKFLOW_DIR/templates/CODEOWNERS.example" "$PROJECT_ROOT/.github/CODEOWNERS"
    echo -e "${YELLOW}   ! 請編輯 .github/CODEOWNERS 並更新團隊資訊${NC}"
fi

echo ""
echo "======================================"
echo -e "${GREEN}設置完成！${NC}"
echo "======================================"
echo ""
echo "已安裝的檔案："
echo "  - .github/workflows/ci-checks.yml"
echo "  - .github/workflows/branch-management.yml"
echo "  - .github/pull_request_template.md"
if [[ "$NEED_CODEOWNERS" =~ ^[Yy]$ ]]; then
    echo "  - .github/CODEOWNERS"
fi
echo ""
echo "下一步："
echo "1. 檢查並自訂配置檔案"
echo "2. 在 GitHub 設置分支保護規則："
echo "   - Settings -> Branches -> Add rule"
echo "   - main: 2 人審查 + All Checks Summary"
echo "   - dev:  1 人審查 + All Checks Summary"
echo "   - test: 1 人審查"
echo "3. 提交變更："
echo "   git add .github/"
echo "   git commit -m 'chore: setup GitHub workflow'"
echo "   git push"
echo ""
```

創建 `scripts/update.sh`:

```bash
#!/bin/bash

set -e

echo "======================================"
echo "更新 GitHub Workflow"
echo "======================================"
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$WORKFLOW_DIR")"

# 檢查是否有本地修改
if [ -f "$PROJECT_ROOT/.github/workflows/ci-checks.yml" ]; then
    echo "檢測到現有配置..."
    echo ""
    read -p "是否要覆蓋現有配置？這將失去您的自訂修改 [y/N]: " CONFIRM
    
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "已取消更新"
        exit 0
    fi
fi

# 更新 submodule
echo "更新 workflow repository..."
cd "$WORKFLOW_DIR"
git pull origin main

# 重新執行設置
cd "$PROJECT_ROOT"
"$SCRIPT_DIR/setup.sh"

echo ""
echo "======================================"
echo "更新完成！"
echo "======================================"
echo ""
echo "請檢查變更並提交："
echo "  git diff .github/"
echo "  git add .github/"
echo "  git commit -m 'chore: update workflow configuration'"
echo "  git push"
```

---

## 使用範例

### 初次設置

```bash
# 1. 創建新專案
mkdir my-new-project
cd my-new-project
git init

# 2. 添加 workflow submodule
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 3. 執行設置腳本
./.github-workflow/scripts/setup.sh

# 4. 提交
git add .github/ .github-workflow/ .gitmodules
git commit -m "chore: initial setup with workflow"
git push -u origin main
```

### 更新 Workflow

```bash
# 更新到最新版本
./.github-workflow/scripts/update.sh

# 或手動更新
git submodule update --remote .github-workflow
./.github-workflow/scripts/setup.sh
```

---

## 最佳實踐

### 1. 版本控制
在 workflow repository 使用 Git tags:
```bash
# 在 workflow repository
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

專案中指定特定版本:
```bash
cd .github-workflow
git checkout v1.0.0
cd ..
git add .github-workflow
git commit -m "chore: lock workflow to v1.0.0"
```

### 2. 文檔維護
在 workflow repository 的 README.md 中維護：
- 版本歷史
- 變更日誌
- 使用說明
- 常見問題

### 3. 自動化測試
為 workflow repository 添加測試：
```yaml
# .github/workflows/test.yml
name: Test Workflows

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate workflow syntax
        run: |
          for file in workflows/*.yml; do
            echo "Validating $file"
            # 使用 actionlint 或其他工具驗證
          done
```

### 4. 團隊協作
- 建立 CONTRIBUTING.md 說明如何貢獻
- 使用 Pull Request 來更新 workflow
- Code review workflow 的變更

---

## 常見問題

### Q: 符號連結在 Windows 上不工作？
A: 使用方案二的複製腳本，或在 Windows 上使用 Git Bash 並以管理員權限執行。

### Q: 如何為不同專案使用不同的配置？
A: 可以在專案中創建 `.github/workflows/ci-checks.override.yml` 來覆蓋部分設定。

### Q: Submodule 更新後如何同步？
A: 執行 `git submodule update --remote` 後重新執行設置腳本。

### Q: 可以使用私有 repository 作為 submodule 嗎？
A: 可以，確保團隊成員都有訪問權限。

---

## 總結

**推薦方案**：
- **小團隊/簡單需求**：方案二（複製腳本）- 簡單直接
- **大團隊/複雜需求**：方案一（符號連結）+ 方案三（Reusable Workflows）結合使用

**核心優勢**：
- 統一管理所有專案的 workflow
- 更新一處，所有專案受益
- 減少重複配置
- 版本控制和回溯

立即開始建立您的 workflow repository 吧！

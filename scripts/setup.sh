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
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 獲取目錄
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$WORKFLOW_DIR")"

echo -e "${BLUE}腳本位置: $SCRIPT_DIR${NC}"
echo -e "${BLUE}Workflow 目錄: $WORKFLOW_DIR${NC}"
echo -e "${BLUE}專案根目錄: $PROJECT_ROOT${NC}"
echo ""

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
echo "1. 創建目錄結構..."
mkdir -p "$PROJECT_ROOT/.github/workflows"
echo -e "${GREEN}   ✓ 完成${NC}"

# 複製 workflow 檔案
echo "2. 複製 workflow 檔案..."
if [ -f "$WORKFLOW_DIR/workflows/$WORKFLOW_FILE" ]; then
    cp "$WORKFLOW_DIR/workflows/$WORKFLOW_FILE" "$PROJECT_ROOT/.github/workflows/ci-checks.yml"
    echo -e "${GREEN}   ✓ 已複製 ci-checks.yml${NC}"
else
    echo -e "${RED}   ✗ 找不到 $WORKFLOW_FILE${NC}"
    exit 1
fi

if [ -f "$WORKFLOW_DIR/workflows/branch-management.yml" ]; then
    cp "$WORKFLOW_DIR/workflows/branch-management.yml" "$PROJECT_ROOT/.github/workflows/"
    echo -e "${GREEN}   ✓ 已複製 branch-management.yml${NC}"
else
    echo -e "${RED}   ✗ 找不到 branch-management.yml${NC}"
    exit 1
fi

# 複製 PR 模板
echo "3. 複製 PR 模板..."
if [ -f "$WORKFLOW_DIR/templates/pull_request_template.md" ]; then
    cp "$WORKFLOW_DIR/templates/pull_request_template.md" "$PROJECT_ROOT/.github/"
    echo -e "${GREEN}   ✓ 完成${NC}"
else
    echo -e "${YELLOW}   ! 找不到 PR 模板${NC}"
fi

# 複製 CODEOWNERS (如果需要)
echo ""
read -p "是否需要 CODEOWNERS 檔案？ [y/N]: " NEED_CODEOWNERS
if [[ "$NEED_CODEOWNERS" =~ ^[Yy]$ ]]; then
    if [ -f "$WORKFLOW_DIR/templates/CODEOWNERS" ]; then
        cp "$WORKFLOW_DIR/templates/CODEOWNERS" "$PROJECT_ROOT/.github/"
        echo -e "${GREEN}   ✓ 已複製 CODEOWNERS${NC}"
        echo -e "${YELLOW}   ! 請編輯 .github/CODEOWNERS 並更新團隊資訊${NC}"
    elif [ -f "$WORKFLOW_DIR/templates/CODEOWNERS.example" ]; then
        cp "$WORKFLOW_DIR/templates/CODEOWNERS.example" "$PROJECT_ROOT/.github/CODEOWNERS"
        echo -e "${GREEN}   ✓ 已複製 CODEOWNERS${NC}"
        echo -e "${YELLOW}   ! 請編輯 .github/CODEOWNERS 並更新團隊資訊${NC}"
    else
        echo -e "${YELLOW}   ! 找不到 CODEOWNERS 模板${NC}"
    fi
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
echo -e "${BLUE}下一步：${NC}"
echo ""
echo "1. 檢查並自訂配置檔案（特別是 CODEOWNERS）"
echo ""
echo "2. 在 GitHub 設置分支保護規則："
echo "   Settings -> Branches -> Add rule"
echo ""
echo "   main 分支："
echo "   - Branch name pattern: main"
echo "   - [V] Require a pull request before merging"
echo "   - Require approvals: 2"
echo "   - [V] Require status checks to pass"
echo "   - Required checks: All Checks Summary"
echo "   - [V] Require conversation resolution"
echo "   - [V] Require linear history"
echo ""
echo "   dev 分支："
echo "   - Branch name pattern: dev"
echo "   - [V] Require a pull request before merging"
echo "   - Require approvals: 1"
echo "   - [V] Require status checks to pass"
echo "   - Required checks: All Checks Summary"
echo "   - [V] Require conversation resolution"
echo "   - [V] Require linear history"
echo ""
echo "   test 分支："
echo "   - Branch name pattern: test"
echo "   - [V] Require a pull request before merging"
echo "   - Require approvals: 1"
echo "   - [V] Require conversation resolution"
echo ""
echo "3. 提交變更："
echo "   git add .github/"
echo "   git commit -m 'chore: setup GitHub workflow'"
echo "   git push"
echo ""
echo "4. 參考文檔："
if [ "$VERSION_CHOICE" = "1" ]; then
    echo "   查看 .github-workflow/docs/MINIMAL_SETUP.md"
else
    echo "   查看 .github-workflow/docs/IMPLEMENTATION_GUIDE.md"
fi
echo ""

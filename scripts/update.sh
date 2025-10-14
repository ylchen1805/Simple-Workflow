#!/bin/bash

set -e

echo "======================================"
echo "更新 GitHub Workflow"
echo "======================================"
echo ""

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$WORKFLOW_DIR")"

echo -e "${BLUE}專案根目錄: $PROJECT_ROOT${NC}"
echo ""

# 檢查是否有現有配置
if [ ! -f "$PROJECT_ROOT/.github/workflows/ci-checks.yml" ]; then
    echo -e "${RED}錯誤: 找不到現有的 workflow 配置${NC}"
    echo "請先執行 setup.sh 進行初始設置"
    exit 1
fi

# 備份現有配置
BACKUP_DIR="$PROJECT_ROOT/.github-backup-$(date +%Y%m%d-%H%M%S)"
echo "1. 備份現有配置到: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r "$PROJECT_ROOT/.github/"* "$BACKUP_DIR/"
echo -e "${GREEN}   ✓ 備份完成${NC}"
echo ""

# 顯示變更
echo "2. 檢查 workflow repository 更新..."
cd "$WORKFLOW_DIR"

# 獲取當前版本
CURRENT_COMMIT=$(git rev-parse HEAD)
CURRENT_BRANCH=$(git branch --show-current)

echo -e "${BLUE}   當前版本: $CURRENT_COMMIT${NC}"
echo -e "${BLUE}   當前分支: $CURRENT_BRANCH${NC}"

# 拉取更新
echo ""
echo "3. 拉取最新更新..."
git fetch origin
LATEST_COMMIT=$(git rev-parse origin/$CURRENT_BRANCH)

if [ "$CURRENT_COMMIT" = "$LATEST_COMMIT" ]; then
    echo -e "${GREEN}   ✓ 已經是最新版本${NC}"
    echo ""
    read -p "是否仍要重新安裝配置？ [y/N]: " FORCE_INSTALL
    
    if [[ ! "$FORCE_INSTALL" =~ ^[Yy]$ ]]; then
        echo "已取消更新"
        rm -rf "$BACKUP_DIR"
        exit 0
    fi
else
    echo -e "${YELLOW}   發現新版本: $LATEST_COMMIT${NC}"
    echo ""
    echo "變更內容："
    git log --oneline $CURRENT_COMMIT..$LATEST_COMMIT
    echo ""
    
    read -p "是否要更新到最新版本？ [Y/n]: " CONFIRM_UPDATE
    
    if [[ "$CONFIRM_UPDATE" =~ ^[Nn]$ ]]; then
        echo "已取消更新"
        rm -rf "$BACKUP_DIR"
        exit 0
    fi
    
    git pull origin $CURRENT_BRANCH
    echo -e "${GREEN}   ✓ 已更新到最新版本${NC}"
fi

echo ""
echo "4. 重新安裝配置..."

# 檢測當前使用的版本
if grep -q "ci-checks-simplified" "$PROJECT_ROOT/.github/workflows/ci-checks.yml" 2>/dev/null; then
    DETECTED_VERSION="1"
    echo -e "${BLUE}   檢測到：最小化版本${NC}"
else
    DETECTED_VERSION="2"
    echo -e "${BLUE}   檢測到：完整版本${NC}"
fi

read -p "是否要切換版本？ [y/N]: " SWITCH_VERSION

if [[ "$SWITCH_VERSION" =~ ^[Yy]$ ]]; then
    echo ""
    echo "請選擇版本："
    echo "1) 最小化版本 (不需要 npm)"
    echo "2) 完整版本 (包含 lint, test 等)"
    echo ""
    read -p "請輸入選項 [1/2]: " VERSION_CHOICE
else
    VERSION_CHOICE=$DETECTED_VERSION
fi

# 執行安裝
cd "$PROJECT_ROOT"

if [ "$VERSION_CHOICE" = "1" ]; then
    WORKFLOW_FILE="ci-checks-simplified.yml"
else
    WORKFLOW_FILE="ci-checks.yml"
fi

# 複製檔案
echo ""
echo "5. 更新檔案..."

if [ -f "$WORKFLOW_DIR/workflows/$WORKFLOW_FILE" ]; then
    cp "$WORKFLOW_DIR/workflows/$WORKFLOW_FILE" "$PROJECT_ROOT/.github/workflows/ci-checks.yml"
    echo -e "${GREEN}   ✓ 已更新 ci-checks.yml${NC}"
fi

if [ -f "$WORKFLOW_DIR/workflows/branch-management.yml" ]; then
    cp "$WORKFLOW_DIR/workflows/branch-management.yml" "$PROJECT_ROOT/.github/workflows/"
    echo -e "${GREEN}   ✓ 已更新 branch-management.yml${NC}"
fi

if [ -f "$WORKFLOW_DIR/templates/pull_request_template.md" ]; then
    cp "$WORKFLOW_DIR/templates/pull_request_template.md" "$PROJECT_ROOT/.github/"
    echo -e "${GREEN}   ✓ 已更新 pull_request_template.md${NC}"
fi

# 詢問是否更新 CODEOWNERS
if [ -f "$PROJECT_ROOT/.github/CODEOWNERS" ]; then
    echo ""
    read -p "是否要更新 CODEOWNERS？（會覆蓋現有內容）[y/N]: " UPDATE_CODEOWNERS
    
    if [[ "$UPDATE_CODEOWNERS" =~ ^[Yy]$ ]]; then
        if [ -f "$WORKFLOW_DIR/templates/CODEOWNERS" ]; then
            cp "$WORKFLOW_DIR/templates/CODEOWNERS" "$PROJECT_ROOT/.github/"
            echo -e "${GREEN}   ✓ 已更新 CODEOWNERS${NC}"
            echo -e "${YELLOW}   ! 請編輯 .github/CODEOWNERS 並更新團隊資訊${NC}"
        fi
    fi
fi

echo ""
echo "======================================"
echo -e "${GREEN}更新完成！${NC}"
echo "======================================"
echo ""
echo "變更摘要："
echo ""

# 顯示差異
cd "$PROJECT_ROOT"
if git diff --quiet .github/; then
    echo -e "${YELLOW}沒有檔案變更${NC}"
else
    echo "已變更的檔案："
    git diff --name-only .github/ | sed 's/^/  - /'
    echo ""
    echo "詳細差異："
    git diff .github/ | head -50
    echo ""
    echo "（顯示前 50 行，完整差異請使用: git diff .github/）"
fi

echo ""
echo -e "${BLUE}下一步：${NC}"
echo ""
echo "1. 檢查變更:"
echo "   git diff .github/"
echo ""
echo "2. 如果變更正確，提交:"
echo "   git add .github/"
echo "   git add .github-workflow/"
echo "   git commit -m 'chore: update workflow configuration'"
echo "   git push"
echo ""
echo "3. 如果要回退到舊版本:"
echo "   cp -r $BACKUP_DIR/* .github/"
echo "   git checkout .github/"
echo ""
echo -e "${GREEN}備份位置: $BACKUP_DIR${NC}"
echo "（確認更新無誤後可刪除）"
echo ""

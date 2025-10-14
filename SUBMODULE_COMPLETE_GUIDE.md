# Submodule 方案 - 完整指南

## 概述

將 GitHub Workflow 配置作為獨立 repository，然後在各專案中作為 submodule 引入，實現：
- 多專案共享統一配置
- 集中管理與更新
- 版本控制與回溯

---

## 完整檔案清單（19個檔案）

### 核心配置檔案（用於 Workflow Repository）
1. **ci-checks-simplified.yml** (9.8KB) - 最小化版本 CI 檢查
2. **ci-checks.yml** (6.3KB) - 完整版本 CI 檢查
3. **branch-management.yml** (8.2KB) - 分支自動化管理
4. **pull_request_template.md** (2.4KB) - PR 模板
5. **CODEOWNERS** (2.4KB) - 程式碼擁有者配置

### 自動化腳本
6. **setup.sh** (4.8KB) - 自動設置腳本
7. **update.sh** (5.3KB) - 自動更新腳本

### Submodule 專用文檔
8. **SUBMODULE_SETUP.md** (13KB) - Submodule 完整使用指南
9. **WORKFLOW_REPO_README.md** (7.0KB) - Workflow Repository 的 README
10. **QUICK_SETUP_WORKFLOW_REPO.md** (7.6KB) - 5分鐘快速建立指南

### 通用文檔
11. **START_HERE.md** (3.5KB) - 快速開始
12. **MINIMAL_SETUP.md** (7.4KB) - 最小化版本設置
13. **VERSION_COMPARISON.md** (7.3KB) - 版本對比
14. **QUICK_REFERENCE.md** (6.3KB) - 日常快速參考

### 完整版本文檔（可選）
15. **README.md** (11KB) - 完整版總覽
16. **IMPLEMENTATION_GUIDE.md** (13KB) - 完整版實作指南
17. **GITHUB_WORKFLOW_SETUP.md** (7.5KB) - 完整版工作流程
18. **WORKFLOW_DIAGRAMS.md** (9.1KB) - 視覺化流程圖

### 範例檔案
19. **package-scripts-example.json** (3.1KB) - NPM 腳本範例（僅完整版）

---

## 三步驟實施計劃

### 階段一：建立 Workflow Repository（15分鐘）

**目標**: 創建可重用的 workflow repository

**步驟**:
1. 閱讀 [QUICK_SETUP_WORKFLOW_REPO.md](./QUICK_SETUP_WORKFLOW_REPO.md)
2. 在 GitHub 創建新 repository: `github-workflow-template`
3. 按照指南組織檔案結構
4. 推送到 GitHub
5. 創建第一個版本標籤 v1.0.0

**檔案清單**:
```
github-workflow-template/
├── README.md                    <- 使用 WORKFLOW_REPO_README.md
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

### 階段二：在新專案中使用（5分鐘）

**目標**: 將 workflow 添加到您的專案

**方式 A - 使用自動化腳本（推薦）**:
```bash
# 1. 添加 submodule
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 2. 執行設置
./.github-workflow/scripts/setup.sh

# 3. 提交
git add .
git commit -m "chore: setup workflow"
git push
```

**方式 B - 手動設置**:
```bash
# 1. 添加 submodule
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 2. 複製檔案（選擇版本）
mkdir -p .github/workflows
cp .github-workflow/workflows/ci-checks-simplified.yml .github/workflows/ci-checks.yml
cp .github-workflow/workflows/branch-management.yml .github/workflows/
cp .github-workflow/templates/pull_request_template.md .github/
cp .github-workflow/templates/CODEOWNERS .github/

# 3. 提交
git add .
git commit -m "chore: setup workflow"
git push
```

### 階段三：設置 GitHub 分支保護（10分鐘）

**目標**: 啟用分支保護規則

在 GitHub Repository 的 Settings -> Branches 設置：

**Main 分支**:
- Require approvals: 2
- Require status checks: All Checks Summary
- Require conversation resolution
- Require linear history

**Dev 分支**:
- Require approvals: 1
- Require status checks: All Checks Summary
- Require conversation resolution
- Require linear history

**Test 分支**:
- Require approvals: 1
- Require conversation resolution

---

## 文檔使用指南

### 如果您要建立 Workflow Repository
**按順序閱讀**:
1. [QUICK_SETUP_WORKFLOW_REPO.md](./QUICK_SETUP_WORKFLOW_REPO.md) - 快速建立
2. [WORKFLOW_REPO_README.md](./WORKFLOW_REPO_README.md) - 作為 repository 的 README
3. [SUBMODULE_SETUP.md](./SUBMODULE_SETUP.md) - 詳細的 submodule 使用方式

### 如果您要在專案中使用
**按順序閱讀**:
1. [START_HERE.md](./START_HERE.md) - 選擇版本
2. [MINIMAL_SETUP.md](./MINIMAL_SETUP.md) - 最小化版本（推薦）
3. [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) - 日常使用參考

### 如果您需要比較版本
**閱讀**:
- [VERSION_COMPARISON.md](./VERSION_COMPARISON.md) - 詳細的版本對比

---

## 方案優勢

### 集中管理
- 單一 repository 管理所有 workflow 配置
- 更新一次，所有專案受益
- 統一的標準和最佳實踐

### 版本控制
- 使用 Git tags 管理版本
- 專案可以鎖定特定版本
- 輕鬆回溯到舊版本

### 團隊協作
- 清晰的更新流程
- Pull Request 審查 workflow 變更
- 文檔化的變更歷史

### 靈活性
- 支援多個版本（最小化 vs 完整）
- 專案可以自訂配置
- 漸進式升級路徑

---

## 典型工作流程

### 日常開發
```bash
# 開發者在專案中工作
git checkout test
git checkout -b feat/new-feature
# ... 開發 ...
git push origin feat/new-feature
# 在 GitHub 創建 PR
# CI 自動檢查通過
# Code Review
# 合併
```

### 更新 Workflow
```bash
# 在 workflow repository 中更新
cd github-workflow-template
git checkout -b update-ci
# ... 修改 workflows/ ...
git add .
git commit -m "feat: improve CI checks"
git push origin update-ci
# 創建 PR，審查，合併
git checkout main
git pull
git tag -a v1.1.0 -m "Improve CI checks"
git push origin v1.1.0
```

### 專案更新到新版本
```bash
# 在專案中
cd my-project
./.github-workflow/scripts/update.sh
# 檢查變更
git diff .github/
# 提交
git add .
git commit -m "chore: update workflow to v1.1.0"
git push
```

---

## 最佳實踐建議

### 1. 版本管理
- 使用語義化版本（1.0.0, 1.1.0, 2.0.0）
- 每個穩定版本打 tag
- 維護 CHANGELOG.md

### 2. 測試
- 建立測試專案驗證 workflow 變更
- 重大變更先在開發分支測試
- 確保向後兼容

### 3. 溝通
- 重大變更提前通知團隊
- 提供清晰的升級指南
- 建立反饋管道

### 4. 文檔
- 保持 README 更新
- 記錄已知問題
- 提供範例和常見問題解答

---

## 與其他方案比較

### vs. 直接複製
**Submodule 方案優勢**:
- 統一管理，一次更新全部生效
- 版本控制，可以回溯
- 減少重複配置

**直接複製優勢**:
- 更簡單，沒有 submodule 複雜性
- 每個專案完全獨立
- 不需要網路連接

### vs. GitHub Actions Reusable Workflows
**Submodule 方案優勢**:
- 可以管理 PR 模板和 CODEOWNERS
- 離線也可以查看配置
- 更靈活的版本控制

**Reusable Workflows 優勢**:
- 不需要複製檔案
- 自動使用最新版本
- GitHub 原生支援

**推薦**: 結合使用兩種方案

---

## 常見問題

### Q: 如何在多個專案間共享但允許自訂？
```bash
# 在專案中覆蓋特定配置
# 創建 .github/workflows/ci-checks.override.yml
# 或直接修改複製過來的檔案
```

### Q: 如何處理不同專案的不同需求？
```bash
# 方案 1: 在 workflow repository 提供多個版本
workflows/
├── ci-checks-minimal.yml
├── ci-checks-standard.yml
└── ci-checks-advanced.yml

# 方案 2: 使用 workflow 變數
# 在專案的 .github/workflows/ci-checks.yml 中設置變數
```

### Q: Submodule 更新麻煩嗎？
不麻煩！使用 `update.sh` 腳本一鍵更新：
```bash
./.github-workflow/scripts/update.sh
```

### Q: 可以鎖定版本嗎？
可以！
```bash
cd .github-workflow
git checkout v1.0.0
cd ..
git add .github-workflow
git commit -m "chore: lock workflow to v1.0.0"
```

---

## 立即開始

### 第一步：建立 Workflow Repository
閱讀並執行: [QUICK_SETUP_WORKFLOW_REPO.md](./QUICK_SETUP_WORKFLOW_REPO.md)

### 第二步：在專案中使用
閱讀: [SUBMODULE_SETUP.md](./SUBMODULE_SETUP.md)

### 第三步：日常使用
參考: [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)

---

## 支援與資源

### 文檔
- 所有文檔都在此包中
- 保持在 workflow repository 的 docs/ 目錄

### 社群
- GitHub Issues
- 團隊頻道
- 定期分享會

### 外部資源
- [Git Submodules 官方文檔](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub Actions 文檔](https://docs.github.com/en/actions)
- [Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)

---

**總結**: Submodule 方案是管理多專案 workflow 配置的優雅解決方案，特別適合有多個專案的團隊。按照本指南，30 分鐘內即可完成完整設置！

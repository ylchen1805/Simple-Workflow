# GitHub Workflow Template Repository

這是一個可重用的 GitHub Workflow 配置模板，可作為 submodule 添加到多個專案中。

## 快速開始

### 在新專案中使用

```bash
# 1. 添加為 submodule
git submodule add https://github.com/your-org/github-workflow-template .github-workflow

# 2. 初始化
git submodule update --init --recursive

# 3. 執行設置腳本
./.github-workflow/scripts/setup.sh

# 4. 提交
git add .github/ .github-workflow/ .gitmodules
git commit -m "chore: setup workflow from template"
git push
```

### 更新 Workflow

```bash
# 更新到最新版本
./.github-workflow/scripts/update.sh
```

---

## Repository 結構

建議的 workflow repository 目錄結構：

```
github-workflow-template/
├── README.md                       # 本檔案
├── workflows/                      # Workflow 配置檔案
│   ├── ci-checks-simplified.yml    # 最小化版本（推薦）
│   ├── ci-checks.yml               # 完整版本
│   └── branch-management.yml       # 分支自動化管理
├── templates/                      # 模板檔案
│   ├── pull_request_template.md    # PR 模板
│   ├── CODEOWNERS                  # 程式碼擁有者（需自訂）
│   └── CODEOWNERS.example          # CODEOWNERS 範例
├── scripts/                        # 自動化腳本
│   ├── setup.sh                    # 初始設置腳本
│   └── update.sh                   # 更新腳本
└── docs/                           # 文檔
    ├── SUBMODULE_SETUP.md          # Submodule 使用指南
    ├── MINIMAL_SETUP.md            # 最小化版本說明
    ├── VERSION_COMPARISON.md       # 版本比較
    └── QUICK_REFERENCE.md          # 快速參考
```

---

## 建立您的 Workflow Repository

### Step 1: 創建 Repository

在 GitHub 上創建新 repository：
```
名稱: github-workflow-template
描述: Reusable GitHub workflow configuration
可見性: Private/Public（根據需求）
```

### Step 2: 組織檔案

將下載的檔案按以下結構組織：

```bash
# 創建目錄結構
mkdir -p workflows templates scripts docs

# 移動 workflow 檔案
mv ci-checks-simplified.yml workflows/
mv ci-checks.yml workflows/
mv branch-management.yml workflows/

# 移動模板檔案
mv pull_request_template.md templates/
mv CODEOWNERS templates/CODEOWNERS.example

# 移動腳本
mv setup.sh scripts/
mv update.sh scripts/
chmod +x scripts/*.sh

# 移動文檔
mv SUBMODULE_SETUP.md docs/
mv MINIMAL_SETUP.md docs/
mv VERSION_COMPARISON.md docs/
mv QUICK_REFERENCE.md docs/
mv START_HERE.md docs/
```

### Step 3: 自訂 CODEOWNERS

編輯 `templates/CODEOWNERS.example`，更新為您的團隊資訊：

```
# 預設擁有者
*       @your-org/core-team

# 前端
/src/components/     @your-org/frontend-team
*.jsx               @your-org/frontend-team

# 後端
/src/api/           @your-org/backend-team
/src/services/      @your-org/backend-team

# DevOps
/.github/           @your-org/devops-team
```

### Step 4: 提交到 Repository

```bash
git add .
git commit -m "Initial commit: workflow template"
git push -u origin main
```

---

## 使用方式

### 方式一：使用腳本（推薦）

```bash
# 在專案中添加 submodule
git submodule add <your-workflow-repo-url> .github-workflow

# 執行設置
./.github-workflow/scripts/setup.sh
```

### 方式二：手動複製

```bash
# 添加 submodule
git submodule add <your-workflow-repo-url> .github-workflow

# 手動複製檔案
mkdir -p .github/workflows
cp .github-workflow/workflows/ci-checks-simplified.yml .github/workflows/ci-checks.yml
cp .github-workflow/workflows/branch-management.yml .github/workflows/
cp .github-workflow/templates/pull_request_template.md .github/
```

### 方式三：符號連結

```bash
# 添加 submodule
git submodule add <your-workflow-repo-url> .github-workflow

# 創建符號連結
mkdir -p .github
ln -s ../.github-workflow/workflows .github/workflows
ln -s ../.github-workflow/templates/pull_request_template.md .github/pull_request_template.md
```

---

## 版本管理

### 使用 Git Tags

為 workflow 版本創建 tags：

```bash
# 在 workflow repository
git tag -a v1.0.0 -m "Release version 1.0.0 - Initial stable release"
git tag -a v1.1.0 -m "Release version 1.1.0 - Add security checks"
git push origin --tags
```

### 在專案中鎖定版本

```bash
# 進入 submodule
cd .github-workflow

# 切換到特定版本
git checkout v1.0.0

# 回到專案根目錄
cd ..

# 提交版本鎖定
git add .github-workflow
git commit -m "chore: lock workflow to v1.0.0"
```

### 升級到新版本

```bash
cd .github-workflow
git fetch --tags
git checkout v1.1.0
cd ..
./.github-workflow/scripts/update.sh
```

---

## 維護與更新

### 更新 Workflow 配置

1. 在 workflow repository 中進行修改
2. 測試修改（建議有測試專案）
3. 創建新的 tag
4. 通知團隊更新

### 測試變更

建議創建一個測試專案來驗證 workflow 變更：

```bash
# 創建測試專案
mkdir test-project
cd test-project
git init

# 添加 workflow（使用開發分支）
git submodule add -b develop <your-workflow-repo-url> .github-workflow

# 測試
./.github-workflow/scripts/setup.sh
```

---

## 最佳實踐

### 1. 文檔維護
- 保持 README.md 更新
- 記錄每個版本的變更
- 提供清晰的使用範例

### 2. 版本控制
- 使用語義化版本（Semantic Versioning）
- 為每個穩定版本打 tag
- 維護 CHANGELOG.md

### 3. 溝通
- 重大變更提前通知團隊
- 提供升級指南
- 建立反饋機制

### 4. 測試
- 在測試專案中驗證變更
- 確保向後兼容
- 提供回退方案

---

## 兩個版本說明

### 最小化版本（ci-checks-simplified.yml）
- 不需要 npm、eslint、jest 等工具
- 純 GitHub 管理
- 適合小型團隊和快速啟動

包含檢查：
- 分支命名驗證
- PR 格式檢查
- Commit 訊息檢查
- 基本安全檢查

### 完整版本（ci-checks.yml）
- 需要 npm 和相關開發工具
- 完整的自動化檢查
- 適合大型團隊和成熟專案

包含檢查：
- 所有最小化版本的檢查
- ESLint 程式碼檢查
- 單元測試
- 整合測試
- 建置驗證
- 程式碼覆蓋率

詳細比較請參考：[docs/VERSION_COMPARISON.md](docs/VERSION_COMPARISON.md)

---

## 常見問題

### Q: 如何選擇版本？
A: 如果您想「純 GitHub 管理，不要額外工具」→ 選擇最小化版本

### Q: 可以自訂 workflow 嗎？
A: 可以，在專案中直接編輯 `.github/workflows/` 下的檔案

### Q: 如何更新所有使用此 template 的專案？
A: 每個專案需要執行 `update.sh` 腳本來更新

### Q: Submodule 和直接複製哪個好？
A: Submodule 便於統一管理和更新；直接複製更靈活但需要手動更新

---

## 支援

- 文檔: [docs/](docs/)
- Issues: https://github.com/your-org/github-workflow-template/issues
- 團隊頻道: #github-workflow-support

---

## 授權

MIT License

---

## 變更日誌

### v1.0.0 (2024-10-15)
- 初始版本發布
- 最小化版本和完整版本
- 自動化腳本
- 完整文檔

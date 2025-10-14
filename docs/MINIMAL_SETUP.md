# 最小化設置 - 純 GitHub 管理

> 不需要本地 npm、eslint、jest 等工具，完全透過 GitHub 管理

## 優勢

- 零本地依賴 - 不需要安裝任何 npm packages
- 純 GitHub 管理 - 所有檢查都在 GitHub Actions 執行
- 簡單快速 - 10 分鐘完成設置
- 開箱即用 - 上傳檔案即可運作

## 您只需要這 4 個檔案

### 必要檔案 (4個)
1. **pull_request_template.md** - PR 模板
2. **branch-management.yml** - 自動分支管理
3. **ci-checks-simplified.yml** - 簡化的 CI 檢查
4. **CODEOWNERS** (可選) - 程式碼擁有者

### 不需要的檔案
- 不需要 package.json
- 不需要 .eslintrc.json
- 不需要 .prettierrc
- 不需要 commitlint.config.js
- 不需要 任何 npm 套件

## 10分鐘快速設置

### Step 1: 準備檔案 (2分鐘)

從下載的檔案中，只需要這些：
```
您的下載/
├── pull_request_template.md          <- 需要
├── branch-management.yml             <- 需要
├── ci-checks-simplified.yml          <- 需要 (新版)
└── CODEOWNERS                         <- 可選
```

### Step 2: 上傳到 Repository (3分鐘)

```bash
# 1. Clone 您的 repository
git clone <your-repo-url>
cd <your-repo>

# 2. 創建目錄
mkdir -p .github/workflows

# 3. 複製檔案
cp /path/to/pull_request_template.md .github/
cp /path/to/ci-checks-simplified.yml .github/workflows/ci-checks.yml
cp /path/to/branch-management.yml .github/workflows/
cp /path/to/CODEOWNERS .github/  # 可選

# 4. 提交
git add .github/
git commit -m "chore: setup GitHub workflow"
git push origin main
```

### Step 3: 設置分支保護 (5分鐘)

#### Main 分支
Settings -> Branches -> Add rule
- Branch name pattern: `main`
- [V] Require a pull request before merging
  - Require approvals: **2**
- [V] Require status checks to pass before merging
  - 搜尋並添加: `All Checks Summary`
- [V] Require conversation resolution before merging
- [V] Require linear history

#### Dev 分支
- Branch name pattern: `dev`
- [V] Require a pull request before merging
  - Require approvals: **1**
- [V] Require status checks to pass before merging
  - 搜尋並添加: `All Checks Summary`
- [V] Require conversation resolution before merging
- [V] Require linear history

#### Test 分支
- Branch name pattern: `test`
- [V] Require a pull request before merging
  - Require approvals: **1**
- [V] Require conversation resolution before merging

**完成！**

## 簡化版的 CI 檢查項目

### 自動檢查（無需本地工具）
1. **分支命名驗證** - 確保使用 `feat/`, `fix/` 等前綴
2. **PR 標題格式** - 檢查 `[TEST]`, `[DEV]`, `[RELEASE]` 前綴
3. **PR 描述檢查** - 確保有填寫描述
4. **檔案變更統計** - 顯示修改的檔案數量
5. **Commit 訊息檢查** - 驗證 conventional commits 格式
6. **基本安全檢查** - 檢測敏感檔案和硬編碼的密碼

### 警告項目（不會阻擋合併）
- PR 標題格式不正確
- Commit 訊息格式建議
- 大型 PR 警告 (>50 個檔案)
- 潛在的敏感檔案

### 阻擋項目（必須修正）
- 分支命名不符合規範

## 工作流程

### 1. 創建功能分支
```bash
git checkout test
git pull origin test
git checkout -b feat/your-feature
```

### 2. 開發與提交
```bash
# 開發您的程式碼...
git add .
git commit -m "feat: add new feature"
git push origin feat/your-feature
```

### 3. 在 GitHub 上創建 PR
1. 前往 GitHub Repository
2. 點擊 "Compare & pull request"
3. 填寫 PR 模板
4. 標題格式：`[TEST] feat: add new feature`
5. 選擇 Reviewer

### 4. 等待 CI 檢查
GitHub Actions 會自動：
- 檢查分支命名
- 驗證 PR 格式
- 統計檔案變更
- 檢查 commit 訊息
- 執行安全掃描

### 5. Code Review 與合併
- Reviewer 審查程式碼
- 批准後合併
- 功能分支自動刪除

### 6. 自動分支重建
- test -> dev 合併後，test 自動重建
- dev -> main 合併後，dev 和 test 自動重建

## 最終檔案結構

```
your-repository/
├── .github/
│   ├── workflows/
│   │   ├── ci-checks.yml              # 簡化的 CI 檢查
│   │   └── branch-management.yml      # 分支自動化
│   ├── pull_request_template.md       # PR 模板
│   └── CODEOWNERS                      # (可選)
├── src/
│   └── your code...
└── README.md
```

**就這麼簡單！** 不需要任何 package.json、eslint 或其他配置檔案。

## 驗證檢查清單

- [ ] `.github/workflows/ci-checks.yml` 已上傳
- [ ] `.github/workflows/branch-management.yml` 已上傳
- [ ] `.github/pull_request_template.md` 已上傳
- [ ] main 分支保護已設置 (2人審查)
- [ ] dev 分支保護已設置 (1人審查)
- [ ] test 分支保護已設置 (1人審查)
- [ ] 測試創建一個 PR 並確認 CI 運作

## 測試流程

### 創建測試 PR
```bash
# 1. 創建測試分支
git checkout test
git pull origin test
git checkout -b feat/test-workflow

# 2. 創建測試檔案
echo "test" > test.txt
git add test.txt
git commit -m "feat: test workflow"
git push origin feat/test-workflow

# 3. 在 GitHub 創建 PR
# 標題: [TEST] feat: test workflow
# 檢查 CI 是否自動運行
```

### 預期結果
- 分支命名檢查通過  
- PR 標題檢查通過  
- 檔案變更統計顯示  
- Commit 訊息檢查通過  
- 安全檢查通過  
- 所有檢查摘要顯示  

## 重要提示

### 關於程式碼品質
雖然這個設置不包含 lint 和測試檢查，但您仍然可以：
- 透過 Code Review 確保品質
- 在 PR 模板中要求自我檢查
- 依賴團隊的程式碼標準

### 如果未來需要更嚴格的檢查
當專案成長後，您隨時可以：
1. 添加 ESLint 檢查
2. 添加自動化測試
3. 添加程式碼覆蓋率要求

但**現在**，您可以完全不需要這些！

## 自訂選項

### 調整分支命名規則
編輯 `ci-checks.yml` 的這一行：
```yaml
if [[ ! "$BRANCH_NAME" =~ ^(feat|fix|docs|refactor|perf|test|security|project)/.+ ]]; then
```

### 調整 PR 標題檢查
如果不需要 `[TEST]`、`[DEV]`、`[RELEASE]` 前綴，可以移除 `pr-validation` job。

### 添加自訂檢查
在 `ci-checks.yml` 中添加新的 job，例如：
```yaml
my-custom-check:
  name: My Custom Check
  runs-on: ubuntu-latest
  steps:
    - name: Do something
      run: echo "Custom check"
```

## 常見問題

### Q: 不使用 lint 工具，如何確保程式碼品質？
A: 透過嚴格的 Code Review！這個設置把重點放在**人工審查**而非自動化工具。

### Q: CI 檢查失敗怎麼辦？
A: 查看 GitHub Actions 的日誌，通常會有清楚的錯誤訊息告訴您如何修正。

### Q: 可以完全跳過 CI 檢查嗎？
A: 如果您是管理員，可以在分支保護設置中取消勾選 "Require status checks"。

### Q: CODEOWNERS 一定要設置嗎？
A: 不一定。如果您的團隊很小或不需要自動指派審查者，可以不使用。

## 支援

如果遇到問題：
1. 查看 GitHub Actions 的執行日誌
2. 檢查分支保護規則是否正確設置
3. 確認檔案位置正確

---

## 完成！

**您已經設置好純 GitHub 管理的工作流程！**

- 不需要本地工具
- 不需要 npm packages
- 所有檢查在 GitHub 執行
- 自動化分支管理

**開始使用您的新工作流程吧！**

---

**檔案清單：**
1. ci-checks-simplified.yml (新版 - 無 npm 依賴)
2. branch-management.yml (分支自動化)
3. pull_request_template.md (PR 模板)
4. CODEOWNERS (可選)

**就這 3-4 個檔案，完成！**

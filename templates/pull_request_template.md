---
name: Pull Request Template
about: Template for pull requests
---

## 📋 PR Type
<!-- Check the type of change your PR introduces -->
- [ ] 🚀 Feature (feat/)
- [ ] 🐛 Bug Fix (fix/)
- [ ] 📝 Documentation (docs/)
- [ ] 🔒 Security (security/)
- [ ] ♻️ Refactor (refactor/)
- [ ] ⚡ Performance (perf/)
- [ ] ✅ Test (test/)
- [ ] 🏗️ Project (project/)

## 🎯 Target Branch
<!-- Check which branch this PR targets -->
- [ ] test (Feature testing)
- [ ] dev (Development integration)
- [ ] main (Production release)

## 📝 Description
<!-- Provide a brief description of the changes -->


## 🔗 Related Issues
<!-- Link related issues using: Closes #123, Fixes #456 -->
Closes #

## 🧪 Testing
<!-- Describe the tests you ran to verify your changes -->
- [ ] Unit tests added/updated
- [ ] Integration tests passed
- [ ] Manual testing completed
- [ ] All existing tests pass

### Test Environment
<!-- If applicable, describe your test environment -->
- OS:
- Browser (if applicable):
- Node version:

## 📸 Screenshots / Recordings
<!-- If applicable, add screenshots or recordings to demonstrate the changes -->


## ✅ Checklist
<!-- Make sure you have completed the following -->
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## 🔄 Migration Notes
<!-- If this PR requires any migration steps, database changes, or configuration updates -->


## 📚 Additional Notes
<!-- Any additional information that reviewers should know -->


---

### For Reviewers
#### Code Review Checklist
- [ ] Code is readable and maintainable
- [ ] Error handling is appropriate
- [ ] Security considerations are addressed
- [ ] Performance impact is acceptable
- [ ] Tests are comprehensive
- [ ] Documentation is updated

#### Merge Strategy
- For **test**: Use "Squash and merge" to keep history clean
- For **dev**: Use "Merge commit" to preserve test history
- For **main**: Use "Merge commit" with detailed release notes

# Git Bash Guide
Run from the extracted project root.

```bash
pwd
ls
git status
```
If this is a new repository:
```bash
git init
git branch -M main
```
Review files:
```bash
git status --short
git diff --check
```
Stage and commit:
```bash
git add README.md docs evidence "git workflow" results scripts suricata tests .gitignore
git status
git diff --cached --stat
git commit -m "Document Suricata practical lab"
```
Create an empty GitHub repository and replace the placeholder URL below with your actual URL:
```bash
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git remote -v
git push -u origin main
```
If `origin` already exists, inspect `git remote -v` rather than adding it again. For later updates: `git add .`, inspect `git diff --cached`, commit, then `git push`. Never push secrets or unauthorized traffic data.

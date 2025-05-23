#!/bin/bash

set -e

REPO_SSH="git@github.com:0xLegendKiller/urls2html.git"
REPO_HTTPS="https://github.com/0xLegendKiller/urls2html.git"
TAG_PREFIX="v"
NEW_TAG="v0.1.1"
COMMIT_MSG="fix: update module path in go.mod and release $NEW_TAG"

# Check if current directory is a git repo
if [ ! -d ".git" ]; then
  echo "No git repo found in current directory."
  echo "Cloning repo..."
  git clone "$REPO_SSH" .
else
  echo "Git repository detected."
fi

# Ensure remote is set to SSH URL
CURRENT_REMOTE=$(git remote get-url origin)
if [ "$CURRENT_REMOTE" != "$REPO_SSH" ]; then
  echo "Changing remote URL to SSH"
  git remote set-url origin "$REPO_SSH"
fi

# Show status and add all changes
git status
git add .

# Commit changes
if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "$COMMIT_MSG"
fi

# Push changes
git push origin main

# Create or update tag and push tags
if git rev-parse "$NEW_TAG" >/dev/null 2>&1; then
  echo "Tag $NEW_TAG exists, deleting and recreating."
  git tag -d "$NEW_TAG"
  git push --delete origin "$NEW_TAG"
fi

git tag "$NEW_TAG"
git push origin "$NEW_TAG"

echo "Done! Repo synced and tagged $NEW_TAG."

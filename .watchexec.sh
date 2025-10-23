#!/usr/bin/env bash

# Watchexec auto-commit-push hook for NixOS flake
# Watches for changes and automatically commits + pushes to GitHub

set -e

# Change to flake directory
cd "$(dirname "$0")"

# Check if there are changes
if jj status | grep -q "Working copy changes:"; then
  echo "Changes detected, committing..."

  # Describe the changes (auto-generate commit message)
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  jj describe -m "chore: Auto-commit flake changes

Updated at: $timestamp

🤖 Generated with watchexec auto-commit hook"

  # Move main bookmark to current commit (required for git export)
  jj bookmark set main -r @

  # Push to GitHub
  echo "Pushing to GitHub..."
  jj git push

  echo "✓ Changes committed and pushed successfully"
else
  echo "No changes detected"
fi

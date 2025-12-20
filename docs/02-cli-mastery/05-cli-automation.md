---
title: "Section 5: CLI Automation & Scripting"
parent: "Part 2: Claude Code CLI Mastery"
nav_order: 4
---

# Section 5: CLI Automation & Scripting

## Pre-Commit Hooks

### Auto Code Review
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Get staged files
STAGED=$(git diff --cached --name-only)

# Review with Claude
echo "$STAGED" | claude "Review for:
- console.log statements
- TODO without tickets
- Hardcoded credentials
Exit 1 if issues found"

exit $?
```

### Auto-Format & Fix
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Fix lint errors
npm run lint -- --fix

# Add fixed files
git add -u

# Review changes
git diff --cached | claude "Quick review of auto-fixes"
```

## CI/CD Integration

### GitHub Actions
```yaml
name: Claude Code Review
on: [pull_request]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Claude CLI
        run: curl -fsSL https://claude.ai/install.sh | sh
      - name: Review PR
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          git diff origin/main... | \
          claude "Review for: security, performance, best practices"
```

### GitLab CI
```yaml
claude-review:
  script:
    - curl -fsSL https://claude.ai/install.sh | sh
    - git diff $CI_MERGE_REQUEST_DIFF_BASE_SHA... | claude "Security review"
```

## Batch Operations

### Multi-File Processing
```bash
#!/bin/bash
# process-all-tests.sh

find tests/ -name "*.test.js" | while read file; do
  claude "Add missing edge case tests to $file" \
    --output "$file"
done
```

### Parallel Processing
```bash
#!/bin/bash
# parallel-review.sh

find src/ -name "*.js" | \
  xargs -P 4 -I {} bash -c 'claude "Review {}" > {}.review'
```

## PowerShell Automation

### Windows Automation
```powershell
# auto-document.ps1

Get-ChildItem -Path src -Filter *.js -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $docs = $content | claude "Generate JSDoc comments"
    Set-Content -Path $_.FullName -Value $docs
}
```

## Error Handling

### Robust Scripts
```bash
#!/bin/bash
set -euo pipefail

# Function with error handling
claude_safe() {
    local output
    if output=$(claude "$@" 2>&1); then
        echo "$output"
        return 0
    else
        echo "Error: Claude CLI failed" >&2
        echo "$output" >&2
        return 1
    fi
}

# Usage
claude_safe "Review code" || exit 1
```

[← Back: Terminal Workflows](04-terminal-workflows) | [Next: CLI vs VS Code →](06-cli-vs-vscode)




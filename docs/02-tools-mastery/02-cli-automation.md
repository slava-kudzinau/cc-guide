---
title: "Section 2: CLI Automation & Scripting"
parent: "Part 2: Tools Mastery (CLI & VS Code Extension)"
nav_order: 2
---

# Section 2: CLI Automation & Scripting

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

**Anti-Pattern**: Committing changes without any review automation  
**Better**: Add pre-commit hooks that catch issues before they reach CI/CD  
**Why**: Issues caught in pre-commit hooks take seconds to fix. Same issues in CI take 5-10 minutes or worse - reach production.

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

**Anti-Pattern**: No error handling in automation scripts  
**Better**: Check exit codes, use `set -e`, add fallbacks  
**Why**: Scripts without error handling silently fail in CI/CD. Always handle errors.

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

What to check in AI-generated code: [PR Review Guide](../07-reference-troubleshooting/05-pr-review-guide).

**Anti-Pattern**: Using expensive Opus model in CI/CD for all checks  
**Better**: Use Haiku for fast checks (linting, formatting), reserve Sonnet/Opus for security reviews  
**Why**: CI runs dozens of times per day. Haiku is 10x faster and 60x cheaper. Use `--model haiku-4.5` for speed.

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

**Anti-Pattern**: Sequential file operations (slow - waits for each file)  
**Better**: Use parallel processing: `xargs -P 4` or `GNU parallel` for batch operations  
**Why**: Processing 100 files sequentially takes 100x time. Parallel processing achieves 4-10x speedup.

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

[← Back: Terminal Workflows](01-terminal-workflows.md) | [Next: VS Code Extension →](03-vscode-extension.md)


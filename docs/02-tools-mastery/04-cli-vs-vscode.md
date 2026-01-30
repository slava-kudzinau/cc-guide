---
title: "Section 4: CLI vs VS Code Extension"
parent: "Part 2: Tools Mastery (CLI & VS Code Extension)"
nav_order: 4
---

# Section 4: CLI vs VS Code Extension - When to Use Each

Quick guide to choosing the right tool for your task.

---

## Quick Decision Matrix

| Task | CLI | Extension | Why |
|------|-----|-----------|-----|
| **Quick file edit** | - | ✓ | Visual diff + inline review |
| **Pre-commit hook** | ✓ | - | Automated, no GUI needed |
| **Learning codebase** | - | ✓ | Interactive exploration |
| **CI/CD pipeline** | ✓ | - | Non-interactive environment |
| **Multi-file refactor** | - | ✓ | Plan Mode for safe changes |
| **Batch processing** | ✓ | - | Loop through files |
| **Debugging** | - | ✓ | Visual context + iteration |
| **Code review** | Both | Both | CLI for automation, Extension for manual |
| **Git workflows** | ✓ | - | Pipe git commands |
| **Testing analysis** | ✓ | - | Analyze test output |

---

## Tool Strengths

### CLI Advantages

**Best for:**
- Automation (scripts, hooks, CI/CD)
- Batch operations (process 100 files)
- Piping (git diff \| claude "review")
- Speed (one-line commands)
- Non-interactive environments
- Terminal-first workflows

**Example use cases:**
```bash
# Pre-commit hook
git diff --cached | claude "security scan"

# CI/CD
npm test 2>&1 | claude "analyze failures"

# Batch processing
find src/ -name "*.js" | xargs -P 4 -I {} claude "review {}"

# Git workflows
git log --oneline -10 | claude "summarize commits"
```

### VS Code Extension Advantages

**Best for:**
- Visual feedback (diffs, syntax highlighting)
- Plan Mode (review before changes)
- Learning (interactive exploration)
- Debugging (iterative problem solving)
- Complex refactoring (coordinated changes)
- UI development (screenshot-to-code)

**Example use cases:**
- Feature development with step-by-step planning
- Visual code review with side-by-side diffs
- Learning unfamiliar codebase interactively
- Multi-file refactoring with safety checks

---

## Scenario-Based Recommendations

### Scenario 1: Daily Feature Development
**Use:** Extension (80%) + CLI (20%)

```
Morning: Extension - "Plan today's feature"
Development: Extension - iterative building with Plan Mode
Before commit: CLI - "git diff | claude 'review'"
```

### Scenario 2: DevOps/Platform Engineering
**Use:** CLI (90%) + Extension (10%)

```bash
# Everything scripted
claude "generate terraform for RDS"
kubectl logs pod | claude "analyze errors"
docker logs container | claude "diagnose crash"

# Extension only for complex debugging
```

### Scenario 3: Code Review
**Use:** CLI (first pass) + Extension (deep review)

```bash
# Step 1: CLI pre-screen
git diff main | claude "quick security scan"

# Step 2: Extension for detailed review
# Open extension → Review each file interactively

# Step 3: CLI for summary
git diff main | claude "generate PR description"
```

### Scenario 4: Learning New Codebase
**Use:** Extension (95%) + CLI (5%)

```
Extension:
- "Explain the project architecture"
- "How does authentication work?" + attach files
- Navigate code while getting explanations

CLI:
- Quick questions: claude "what does this error mean?"
```

---

## Hybrid Workflow Pattern

Combine both tools for maximum productivity:

**Morning Planning (Extension):**
```
- "What should I work on today?"
- Review priorities
- Plan feature implementation
```

**Development (Extension):**
```
- Build features with Plan Mode
- Debug issues visually
- Refactor with safety checks
```

**Pre-Commit (CLI):**
```bash
# .git/hooks/pre-commit
git diff --cached | claude "review for issues"
```

**CI/CD (CLI):**
```yaml
# .github/workflows/pr-review.yml
- run: git diff origin/main | claude "security review"
```

---

## When to Use CLI

**Choose CLI when you need:**
- Scriptability (hooks, CI/CD, automation)
- Composability (piping with other tools)
- Speed (one-line commands)
- Batch operations (process many files)
- Non-interactive execution (cron, automation)
- Terminal-based workflows

**CLI excels at:**
- Pre-commit/pre-push hooks
- CI/CD pipeline integration
- Log analysis
- Batch file processing
- Git workflow automation
- Test output analysis

---

## When to Use Extension

**Choose Extension when you need:**
- Visual feedback (side-by-side diffs)
- Plan Mode (preview changes)
- Interactive exploration
- Learning unfamiliar code
- Complex refactoring safety
- Image/screenshot support

**Extension excels at:**
- Feature development
- Multi-file refactoring
- Visual debugging
- Code learning
- UI development
- Pair programming (screen sharing)

---

## Performance Comparison

### Speed (Simple Task)
- **CLI**: 2-5 seconds (one command)
- **Extension**: 5-10 seconds (open panel, type, review)
- **Winner**: CLI for quick tasks

### Refactoring (Multi-file)
- **CLI**: 5-10 minutes (manual coordination)
- **Extension**: 3-5 minutes (Plan Mode, visual diffs)
- **Winner**: Extension for complex changes

### Automation (100 files)
- **CLI**: 2-3 minutes (parallel processing)
- **Extension**: Not applicable (manual)
- **Winner**: CLI for batch operations

---

## Cost Optimization

**Use Haiku (CLI) for:**
- Linting checks
- Simple formatting
- Quick questions
- Batch reviews

```bash
claude --model haiku-4.5 "review for obvious errors"
```

**Use Sonnet (Extension) for:**
- Feature development
- Complex refactoring
- Architectural decisions
- Deep analysis

**Use Opus for:**
- Security audits
- Critical production code
- Complex architecture design
- High-stakes decisions

Slow or expensive? [Troubleshooting](../07-reference-troubleshooting/02-troubleshooting) (performance, cost).

---

## Summary

**CLI is your automation engine:**
- Scripts, hooks, CI/CD
- Batch processing
- Terminal workflows
- Speed and efficiency

**Extension is your development partner:**
- Interactive coding
- Visual feedback
- Safe refactoring
- Learning and exploration

**Use both together:**
- Extension for development
- CLI for automation
- Best of both worlds

---

[← Back: VS Code Extension](03-vscode-extension.md) | [Next: Advanced CLI Patterns →](05-advanced-cli-patterns.md)


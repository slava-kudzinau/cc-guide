---
title: "What Is Claude Code?"
parent: "Part 0: Introduction - Getting Started"
nav_order: 1
---

# What Is Claude Code?

**Reading time**: 3 minutes

---

## The 30-Second Answer

Claude Code is **Anthropic's official command-line tool and VS Code extension** that brings Claude AI directly into your development workflow. Instead of copy-pasting code to a chat window, Claude works directly in your terminal and editor with full access to your codebase.

---

## The Key Idea

Imagine having an expert developer who:
- **Understands your entire codebase** (not just one file at a time)
- **Follows your existing patterns** (uses your conventions automatically)
- **Works in your terminal or editor** (no context switching)
- **Can be piped like any Unix tool** (`git diff | claude "review"`)

That's Claude Code.

---

## What It's NOT

Let's clear up confusion right away:

❌ **NOT Cursor IDE** - Cursor is a separate product (though you can use both together)
❌ **NOT a ChatGPT plugin** - This is official Anthropic tooling
❌ **NOT just autocomplete** - Claude Code understands full context and can handle multi-file refactoring
❌ **NOT a replacement for your IDE** - It works *with* your existing tools

✅ **IS a command-line tool** - Works in any terminal
✅ **IS a VS Code extension** - Official Anthropic extension
✅ **IS scriptable and automatable** - Perfect for CI/CD
✅ **IS compatible with your workflow** - git, npm, docker, pytest, etc.

---

## Two Ways to Use It

### 1. Claude Code CLI (Terminal)

```bash
# Interactive mode
claude

# One-shot commands
claude "explain what this codebase does"

# Pipe command outputs
git diff | claude "review my changes"
```

**Best for**:
- Terminal users who live in bash/zsh/PowerShell
- Automation and scripting
- CI/CD integration
- Quick command-line questions

### 2. Claude Code VS Code Extension

Open VS Code → Use Claude panel → AI-assisted development with visual feedback

**Best for**:
- GUI-first developers
- Visual coding workflows
- Less comfortable with terminal
- Want to see changes before applying them

**You can use both.** Most developers do - CLI for automation, VS Code for interactive development.

---

## Should You Care?

Answer these questions:

- □ Do you spend time reviewing code?
- □ Do you write tests?
- □ Do you work with unfamiliar codebases?
- □ Do you use git, npm, docker, or pytest in terminal?
- □ Do you want to automate repetitive tasks?

**If you answered yes to ANY of these**: This tool is for you.

---

## What Makes It Different

### vs ChatGPT

| ChatGPT | Claude Code |
|---------|-------------|
| Web interface | Terminal integration |
| Copy-paste code | Direct file editing |
| No codebase context | Full project understanding |
| Manual process | Automatable/scriptable |

**Use both**: ChatGPT for learning concepts, Claude Code for actual work

### vs GitHub Copilot

| Copilot | Claude Code |
|---------|-------------|
| Autocomplete individual lines | Multi-file refactoring |
| Limited context (current file) | Full codebase (200K+ tokens) |
| No terminal integration | Pipes with Unix tools |
| Can't review full PRs | `git diff \| claude "review"` |

**Use both**: Copilot for fast typing, Claude Code for reasoning tasks

### vs Cursor IDE

| Cursor | Claude Code |
|--------|-------------|
| Full IDE replacement | Works with your existing editor |
| All-or-nothing commitment | Use CLI + any editor |
| Visual interface focused | Scriptable/automatable |
| Excellent multi-file editing | Better CI/CD integration |

**Use both**: Many developers use Claude Code CLI + Cursor IDE together

---

## Quick Decision Helper

**"I'm comfortable in terminal"**
→ CLI is perfect for you. Install in one command, use immediately.

**"I prefer visual interfaces"**
→ VS Code extension gives you GUI convenience. Install from Extensions marketplace.

**"I want both"**
→ Install both. They work together seamlessly.

**"I'm still not sure"**
→ That's okay! Next section lets you try it risk-free in 5 minutes.

---

## Real-World Example

Here's what a typical Claude Code session looks like:

```bash
# You're working on a feature
git status

# Claude helps you understand existing code
claude "where do we handle authentication?"
# → "JWT validation is in src/middleware/auth.js:45"

# Make changes to your code...

# Claude reviews before you commit
git diff | claude "review for bugs and security issues"
# → Points out SQL injection vulnerability you missed

# Fix the issue, then commit
git add .
git commit -m "feat: add email validation

Co-authored-by: Claude Code"
```

**What just happened?**
- You stayed in your terminal (no context switching)
- Claude understood your full codebase
- You caught a bug before committing
- All automated and scriptable

---

## You've Got the Basics

Now you understand:
- ✅ Claude Code is Anthropic's official CLI + VS Code extension
- ✅ It works *with* your existing tools, not as a replacement
- ✅ You can use terminal (CLI) or GUI (VS Code Extension) or both
- ✅ It's fundamentally different from ChatGPT, Copilot, and Cursor

**Next**: Let's get it working with your code. No theory - just hands-on practice.

---

[← Back to Intro](README.md) | [Next: Your First Win in 5 Minutes →](02-first-win.md)

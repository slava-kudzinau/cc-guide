---
title: "Section 3: VS Code Extension Guide"
parent: "Part 2: Tools Mastery (CLI & VS Code Extension)"
nav_order: 3
---

# Section 3: VS Code Extension Guide

The Claude Code VS Code extension brings AI-powered development directly into your IDE with visual interfaces, plan mode, and interactive features.

---

## Installation & Setup

### Requirements
- VS Code 1.98.0 or higher
- Anthropic API Key from [console.anthropic.com](https://console.anthropic.com/)

### Installation

**Via VS Code Marketplace:**
1. Open Extensions (`Ctrl+Shift+X` or `Cmd+Shift+X`)
2. Search "Claude Code" by Anthropic
3. Click Install
4. Look for Spark icon in sidebar

**Via Command Line:**
```bash
code --install-extension anthropic.claude-code
```

### Configuration

**Set API Key:**

```bash
# Method 1: Environment variable (Recommended)
export ANTHROPIC_API_KEY="your-key-here"
# Add to ~/.bashrc or ~/.zshrc, then restart VS Code
```

```json
// Method 2: VS Code settings.json
{
  "claudeCode.apiKey": "${env:ANTHROPIC_API_KEY}",
  "claudeCode.provider": "anthropic"
}
```

**Configure Preferences:**

```json
{
  "claudeCode.defaultModel": "claude-sonnet-4-5",
  "claudeCode.planMode": true,
  "claudeCode.streaming": true,
  "claudeCode.autoAccept": false,
  "claudeCode.promptCaching": true
}
```

---

## Interface Overview

### Main Components

```
┌─────────────────────────────────────────────┐
│  Claude Code ⚡                    [+ New]  │
├─────────────────────────────────────────────┤
│  📂 Sessions                                │
│    → Current Session (active)               │
│    → Feature/auth-refactor                  │
│    → Bug/payment-issue                      │
├─────────────────────────────────────────────┤
│  💬 Conversation Area                       │
│  [Messages and responses here]              │
│  [Plan Mode controls when active]           │
├─────────────────────────────────────────────┤
│  📝 Files in Context                        │
│    • src/auth.js                            │
│    • CLAUDE.md                              │
├─────────────────────────────────────────────┤
│  > Type message... [@file] [📎]             │
└─────────────────────────────────────────────┘
```

### Keyboard Shortcuts

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Open panel | `Ctrl+Shift+C` | `Cmd+Shift+C` |
| New session | `Ctrl+Shift+N` | `Cmd+Shift+N` |
| Accept plan | `Ctrl+Enter` | `Cmd+Enter` |
| Reject plan | `Esc` | `Esc` |
| Attach file | `@filename` | `@filename` |
| Inline chat | `Ctrl+K` | `Cmd+K` |

---

## Plan Mode

**What it is:** Preview changes before they're applied. See exactly what will change, where, and why.

**How it works:**

```
You: "Add user authentication"

Claude generates plan:
┌─────────────────────────────────────────┐
│ Plan Preview                            │
├─────────────────────────────────────────┤
│ Files to modify:                        │
│   ✏️ src/middleware/auth.js (new file)  │
│   ✏️ src/routes/users.js               │
│   ✏️ tests/auth.test.js                │
│                                         │
│ Changes: Add JWT middleware + tests     │
│ Risk Level: Medium                      │
│                                         │
│ [Edit Plan] [Accept All] [Reject]       │
└─────────────────────────────────────────┘
```

**Editing plans:**
1. Click "Edit Plan"
2. Remove files you don't want changed
3. Add constraints ("Use bcrypt for hashing")
4. Apply edits

**When to use:**
- Multi-file refactoring
- Large code changes
- Learning how to approach a problem
- Any time you want control before execution

---

## Context Rewind

**What it is:** Undo both conversation AND code changes instantly.

**How to use:**
- Press `ESC` twice quickly (CLI)
- Click Rewind button (VS Code)
- Or `Ctrl+Z` / `Cmd+Z` (VS Code)

**Use cases:**

```bash
You: "Implement OAuth"
Claude: [Implements complex OAuth]
You: <ESC><ESC>  # Instant undo
You: "Implement basic auth instead"
Claude: [Implements simpler basic auth]
```

**Benefits:**
- Fearless exploration of ideas
- Try multiple approaches safely
- No git reset needed
- Learn different solutions

---

## Interactive Features

### File Attachments

**Method 1: @-mentions**
```
You: "Review @src/auth.js for security issues"
# Auto-completion shows matching files
```

**Method 2: Drag and drop**
- Drag files from Explorer into chat

**Method 3: File picker**
- Click 📎 icon
- Browse and select files

**Method 4: Images**
- Copy-paste screenshots
- Drag design mockups
- "Implement this design"

### Inline Chat

Select code → Right-click → "Ask Claude" or `Ctrl+K`:

```javascript
// Select this function
function calculateTotal(items) {
  return items.reduce((sum, item) => 
    sum + item.price * item.quantity, 0);
}

// Ask inline: "Explain this"
// Get answer without leaving editor
```

### Slash Commands

| Command | What it does |
|---------|--------------|
| `/help` | Show all commands |
| `/clear` | Clear conversation, keep code |
| `/reset` | Clear conversation + undo code |
| `/context` | Show files in context |
| `/cost` | Show token usage and cost |
| `/model haiku` | Switch to fast model |
| `/model sonnet` | Switch to balanced model |
| `/thinking 10000` | Increase reasoning budget |
| `/plan on` | Enable plan preview |
| `/export` | Save conversation |

---

## Core Workflows

### Workflow 1: Feature Development

```
1. Start conversation
   You: "Add Google OAuth authentication
   Requirements: Login with Google, store user in DB, session management
   @src/routes/auth.ts @src/models/user.ts"

2. Review plan
   Claude shows: 5-step implementation plan
   You review each step

3. Edit if needed
   "In step 3, also add profile photo from Google"

4. Accept and implement
   Click "Accept All" or approve step-by-step

5. Test and iterate
   Run tests → Fix issues → Continue conversation
```

### Workflow 2: Debugging

```
1. Error occurs
   Problems panel: "Cannot read property 'id' of undefined"

2. Ask Claude
   Select problematic code
   Right-click → "Ask Claude" (Ctrl+K)

3. Claude explains
   "The issue is user might be undefined"
   Shows fix with optional chaining

4. Apply fix
   Review diff → Accept
   Error resolved
```

### Workflow 3: Code Review

```
1. Make changes
   git add .

2. Review with Claude
   You: "Review my staged changes for:
   - Security vulnerabilities
   - Missing error handling
   - Code style violations
   - Test coverage gaps"

3. Fix issues
   Claude reports problems with severity
   Fix critical issues before committing

4. Generate commit message
   You: "Generate conventional commit message"
   Copy and commit
```

---

## Session Management

**Multiple sessions:**
- One session per feature/bug
- Name sessions clearly: "Feature/user-roles" not "Session 1"
- Switch between sessions without losing context
- Close when done to keep organized

**Searching history:**
- `Ctrl+F` / `Cmd+F` in panel
- Search across all conversations
- Jump to relevant discussion

**Exporting conversations:**
- Right-click session → Export
- Formats: Markdown, JSON, HTML
- Use for documentation, sharing, troubleshooting

---

## Configuration

### Essential Settings

```json
{
  // Model
  "claudeCode.defaultModel": "claude-sonnet-4-5",
  
  // Safety
  "claudeCode.planMode": true,
  "claudeCode.autoAccept": false,
  
  // Performance
  "claudeCode.streaming": true,
  "claudeCode.promptCaching": true,
  
  // Context
  "claudeCode.context": {
    "autoIncludeCLAUDEmd": true,
    "maxFiles": 50,
    "respectGitignore": true
  },
  
  // UI
  "claudeCode.showTokenUsage": true,
  "claudeCode.showCost": true
}
```

Extension issues? [Troubleshooting – VS Code Extension](../07-reference-troubleshooting/02-troubleshooting#vs-code-extension-issues).

### Workspace-Specific

```json
// .vscode/settings.json (per project)
{
  "claudeCode.model": "claude-haiku-4-5",  // Fast for this project
  "claudeCode.context.autoIncludeFiles": [
    "CLAUDE.md",
    "package.json",
    "tsconfig.json"
  ]
}
```

---

## Troubleshooting

### Extension Not Loading
- Check installation: `code --list-extensions | grep anthropic`
- Restart VS Code: Cmd/Ctrl+Shift+P → "Reload Window"
- Check VS Code version: Help → About (need 1.98.0+)

### API Key Errors
- Verify key: `echo $ANTHROPIC_API_KEY`
- Check console.anthropic.com for valid key
- Set in VS Code: Settings → "Claude Code: API Key"

### Slow Responses
- Reduce context: Remove unnecessary files
- Lower thinking budget: `/thinking 2000`
- Switch to faster model: `/model haiku`
- Enable streaming: Settings → `streaming: true`

### Changes Not Applying
- Check file permissions (read-only?)
- Check git status (conflicts?)
- Reload window: Ctrl+Shift+P → "Reload Window"

---

## Performance Tips

**Reduce latency:**
- Enable streaming for real-time output
- Create CLAUDE.md for prompt caching (90% faster)
- Attach only relevant files (not entire src/)
- Use specific questions, not vague prompts

**Reduce costs:**
- Use Haiku for simple tasks (10x cheaper)
- Enable prompt caching
- Detach files when done (click X)
- Close unused sessions

**Monitor usage:**
```json
{
  "claudeCode.showTokenUsage": true,
  "claudeCode.showCost": true
}
```

---

## Best Practices

**Do:**
- Use Plan Mode for important changes
- Name sessions descriptively
- Review diffs before accepting
- Keep CLAUDE.md updated
- Learn keyboard shortcuts

**Don't:**
- Enable auto-accept for production code
- Overload context with 50+ files
- Ignore warnings about large changes
- Skip testing after accepting changes

---

## Next Steps

- **Compare tools**: [CLI vs VS Code](04-cli-vs-vscode.md)
- **Advanced CLI**: [Advanced Patterns](05-advanced-cli-patterns.md)
- **Extensibility**: [Commands & Plugins](06-commands-plugins.md)

[← Back: CLI Automation](02-cli-automation.md) | [Next: CLI vs VS Code →](04-cli-vs-vscode.md)


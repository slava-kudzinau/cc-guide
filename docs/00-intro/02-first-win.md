---
title: "Your First Win in 5 Minutes"
parent: "Section 00: Introduction - Getting Started"
nav_order: 2
---

# Your First Win in 5 Minutes

**Total time**: 7 minutes (2 min reading + 5 min hands-on)

Let's get Claude Code working with your actual code. No theory. Just results.

---

## Prerequisites Check

Before we start, quick check:

- □ Can you open a terminal? (Command Prompt, PowerShell, Terminal, etc.)
- □ Do you have a code project with git? (Any project with a `.git` folder)

**Both yes?** Great, let's continue.

**No project?** You can use any existing project on your machine, or clone a demo:
```bash
git clone https://github.com/your-favorite/repo
cd repo
```

---

## Step 1: Install (2 minutes)

Copy and paste the command for your platform:

### macOS / Linux / WSL

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://claude.ai/install.ps1 | iex
```

### Alternative: Package Managers

```bash
# macOS with Homebrew
brew install --cask claude-code

# Windows with WinGet
winget install Anthropic.ClaudeCode
```

### Or: VS Code Extension

Open VS Code → Extensions → Search "Claude Code" → Install

---

### Verify Installation

```bash
claude --version
```

**✅ Success check**: You should see a version number (e.g., `claude-code 0.5.0`)

**❌ Seeing "command not found"?**
- Restart your terminal
- Or run: `source ~/.bashrc` (Linux/macOS) or `source ~/.zshrc` (macOS with zsh)
- Windows: Restart PowerShell

---

## Step 2: Login (1 minute)

```bash
claude /login
```

This opens your browser for authentication.

**Don't have a Claude account?** Create a free account at [claude.ai](https://claude.ai)

**✅ Success check**: Terminal shows "Authenticated successfully"

**❌ Authentication failed?**
- Make sure you completed the browser login
- Try running `claude /login` again
- Check [Troubleshooting Guide](../07-reference-troubleshooting/02-troubleshooting.md) for API key alternatives

---

## Step 3: Three Commands (5 minutes)

Navigate to your project:

```bash
cd /path/to/your/project
```

Now run these three commands. Each demonstrates different Claude Code capabilities.

---

### Command 1: Review Your Code (30 seconds)

```bash
git diff | claude "review for bugs and best practices"
```

**What this does**: Analyzes your uncommitted changes and flags potential issues.

**Expected output**: Claude will review your code and point out:
- Potential bugs
- Code style improvements
- Security concerns
- Best practice violations

**Why this matters**: You just got a code review in 30 seconds instead of waiting 15 minutes for a human reviewer.

**No uncommitted changes?** Make a small edit to any file first, or try:
```bash
git show HEAD | claude "review this commit"
```

---

### Command 2: Understand Code (30 seconds)

```bash
claude "explain what src/index.js does in simple terms"
```

**Replace `src/index.js` with an actual file in your project.** Any file works - pick one you didn't write or don't fully understand.

**Expected output**: Plain English explanation of:
- What the file does
- Key functions and their purpose
- How it fits into the larger system

**Why this matters**: No more hunting through code trying to understand what it does. Just ask.

**Example with specific questions**:
```bash
claude "where do we handle user authentication?"
claude "what does the calculateTotal function do?"
claude "show me all API endpoints in this project"
```

---

### Command 3: Write a Test (2 minutes)

```bash
claude "write jest tests for src/utils.js - cover happy path and edge cases"
```

**Replace `src/utils.js` with an actual file.** Pick a utility file, helper function, or small module.

**Expected output**: Complete test file with:
- Multiple test cases
- Edge case coverage
- Mocks and fixtures if needed
- Following your project's test patterns

**Why this matters**: Test writing went from 20 minutes to 2 minutes. Now you'll actually write tests instead of skipping them.

**Don't use Jest?** Adjust the command:
```bash
claude "write pytest tests for utils.py"
claude "write mocha tests for utils.js"
claude "write xunit tests for Utils.cs"
```

---

## What Just Happened?

Let's pause and reflect on what you just did:

1. ✅ **Analyzed real code** with `git diff | claude`
   - Used Unix piping (Claude Code works like any command-line tool)
   - Got instant feedback on your changes

2. ✅ **Leveraged full codebase context**
   - Claude read your entire project automatically
   - Understood relationships between files
   - Gave context-aware answers

3. ✅ **Generated new code** that follows your patterns
   - Tests match your existing test style
   - Variable names match your conventions
   - Imports use your project structure

4. ✅ **Stayed in your terminal**
   - No context switching to a browser
   - No copy-pasting code back and forth
   - Integrated with your existing workflow

---

## Try These Next

Now that you've verified it works, experiment with these commands:

### Debug Test Failures

```bash
npm test 2>&1 | claude "explain these failures and suggest fixes"
```

### Generate Documentation

```bash
claude "update README with API endpoints from src/routes/"
```

### Find Code

```bash
claude "where do we connect to the database?"
claude "show me all files that import lodash"
```

### Refactor Code

```bash
claude "refactor src/legacy.js to modern ES6 - preserve behavior"
```

### Generate Commit Messages

```bash
git diff --cached | claude "write a conventional commit message"
```

---

## Troubleshooting

### "Command not found: claude"

**Solution**: Restart your terminal, or:
```bash
# Linux/macOS
source ~/.bashrc  # or ~/.zshrc

# Windows PowerShell
# Close and reopen PowerShell
```

### "Authentication failed"

**Solution**:
1. Run `claude /login` again
2. Complete the browser authentication
3. If still failing, try API key method in [Environment Setup](../01-fundamentals-core-concepts/02-environment-setup.md)

### "Claude doesn't understand my project"

**Solution**:
- Make sure you're in the project root directory: `cd /path/to/project`
- Verify `.git` folder exists: `ls -la | grep git`
- Claude needs a git repository to understand project structure

### "Response is slow or hangs"

**Solution**:
- Check your internet connection
- Very large projects may take 10-20 seconds on first run (context caching)
- Subsequent runs will be faster

### "Claude suggested incorrect code"

**Solution**:
- This is normal - AI isn't perfect
- Always review suggested code before using it
- Be more specific in your prompts: "write jest test for calculateTotal function using mocks"

**More issues?** See the comprehensive [Troubleshooting Guide](../07-reference-troubleshooting/02-troubleshooting.md)

---

## Success Check

Before moving to the next section, verify:

- ✅ Did you successfully run all 3 commands?
- ✅ Did Claude analyze your actual project code?
- ✅ Did you see useful, relevant output?

**All yes?** Congratulations! You've just used Claude Code successfully.

**Some no?** That's okay. Review the troubleshooting section above or ask for help in the [Anthropic Discord](https://anthropic.com/discord).

---

## What's Next?

You now have hands-on proof that Claude Code works. You've seen it:
- Review code
- Explain existing code
- Generate new code

**But why should you use this regularly?** Next section shows the concrete benefits and productivity gains.

---

[← Previous: What Is Claude Code?](01-what-is-claude-code.md) | [Next: Why Claude Code Matters →](03-why-it-matters.md)

---
title: "Section 21: Troubleshooting & Common Issues"
parent: "Part 7: Reference, Troubleshooting & Future"
nav_order: 2
---

# Section 21: Troubleshooting & Common Issues

**Quick Navigation:**
- [Troubleshooting Decision Tree](#troubleshooting-decision-tree) ← **Start here when stuck**
- [Authentication Issues](#authentication-issues)
- [Extended Thinking Issues](#extended-thinking-issues)
- [Context Window Problems](#context-window-overflow)
- [Performance Problems](#performance-issues)
- [Cost Problems](#cost-issues)
- [VS Code Extension Issues](#vs-code-extension-issues)

---

## Troubleshooting Decision Tree

**Start here when something isn't working.**

### Visual Decision Flow

```
┌─────────────────────────────────────────────────┐
│    PROBLEM: Is Claude responding at all?        │
└────────────────┬───────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
      NO │               │ YES
        │                 │
        ▼                 ▼
┌──────────────┐  ┌──────────────────────┐
│  Check Auth  │  │  Is response quality │
│              │  │  good enough?        │
│ See: Auth    │  └──────┬───────────────┘
│ Issues ─────►│         │
└──────────────┘  ┌──────┴────────┐
                  │               │
                YES │             │ NO
                  │               │
                  ▼               ▼
          ┌────────────┐  ┌──────────────────┐
          │  Is it     │  │ Is prompt        │
          │  slow?     │  │ specific enough? │
          └─────┬──────┘  └────────┬─────────┘
                │                  │
           YES  │  NO         YES  │  NO
                │  │               │  │
                ▼  ▼               ▼  ▼
          Performance      Add Context/Examples
          Issues           See: Prompt Quality
```

### Text-Based Decision Tree

#### Problem 1: Claude Not Responding At All

**Symptoms:**
- Command hangs
- No output
- Connection timeout
- 401/403 errors

**Step 1: Check API Key**
```bash
# Verify key is set
echo $ANTHROPIC_API_KEY

# Expected: sk-ant-...
# If empty or wrong, fix:
export ANTHROPIC_API_KEY="your-actual-key"

# Make permanent (add to ~/.bashrc or ~/.zshrc):
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.bashrc
source ~/.bashrc
```

**Test:** `claude "test" --verbose`
- ✅ Works? → API key was the issue
- ❌ Still fails? → Continue to Step 2

**Step 2: Check Network Connection**
```bash
# Test Anthropic API
curl -v https://api.anthropic.com/v1/complete \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01"

# Check status
curl https://status.anthropic.com/api/v2/status.json
```

**Results:**
- ✅ 200 response? → Connection OK, continue to Step 3
- ❌ Connection refused? → Firewall/proxy issue
- ❌ 401/403? → API key invalid
- ❌ 429? → Rate limited (wait or upgrade plan)

**Step 3: Check Service Status**
- Visit: https://status.anthropic.com/
- ✅ All systems operational? → Continue to Step 4
- ❌ Outage reported? → Wait for resolution or use backup (AWS Bedrock/GCP Vertex)

**Step 4: Check CLI/Extension Installation**
```bash
# Verify installation
claude --version

# If command not found:
npm install -g @anthropic/claude-code

# Verify again
claude --version
```

**Step 5: Enable Debug Mode**
```bash
# Run with debug
claude "test" --debug --verbose

# Check logs
cat ~/.claude/logs/latest.log
```

**Common fixes:**
- Missing API key → Export ANTHROPIC_API_KEY
- Expired key → Generate new key at console.anthropic.com
- Network issue → Check firewall/proxy
- Version conflict → Update CLI: `npm update -g @anthropic/claude-code`

---

#### Problem 2: Response Quality Poor

**Symptoms:**
- Generic answers
- Missing context
- Incorrect solutions
- Hallucinations

**Decision Path:**

**Question A: Is prompt specific enough?**

❌ **Vague prompt:**
```bash
claude "fix my code"
```

✅ **Specific prompt:**
```bash
claude "Fix authentication error on line 45 of src/auth.ts - 
users can't log in after OAuth callback. Error: 'session undefined'.

@src/auth.ts
@src/middleware/session.ts

Steps to reproduce:
1. Click 'Login with Google'
2. Authorize on Google
3. Redirect to /callback
4. Error thrown

Expected: User logged in
Actual: 500 error, session undefined"
```

**Improvement checklist:**
- [ ] Specific problem described
- [ ] Relevant files attached
- [ ] Error messages included
- [ ] Steps to reproduce provided
- [ ] Expected vs actual behavior stated

**Question B: Is context sufficient?**

❌ **Insufficient context:**
```bash
claude "why is auth failing?"
```

✅ **Sufficient context:**
```bash
claude "why is auth failing?

Context:
@src/auth/validate.ts
@src/middleware/auth.ts
@config/database.ts

Error log:
[paste full error]

System:
- Node.js 20
- PostgreSQL 15
- Redis 7
- 1000 req/min traffic

Recent changes:
- Added OAuth yesterday
- Database migrated this morning"
```

**Context checklist:**
- [ ] All relevant files attached
- [ ] Full error messages (not truncated)
- [ ] System information
- [ ] Recent changes noted
- [ ] Scale/traffic info (if performance issue)

**Question C: Need deeper reasoning?**

For complex problems:
```bash
# Enable extended thinking
claude --thinking=5000 "complex architectural question"

# Use Opus for hardest problems
claude --model claude-opus-4-1 "difficult debugging"
```

**When to use extended thinking:**
- ✅ Complex architecture decisions
- ✅ Multi-step debugging
- ✅ System design
- ❌ Simple questions
- ❌ Code formatting
- ❌ Quick reviews

---

#### Problem 3: Too Slow

**Symptoms:**
- Responses take 10+ seconds
- Extension freezes
- Timeouts

**Decision Path:**

**Question A: Using extended thinking unnecessarily?**

Check your command:
```bash
# ❌ Slow: Extended thinking for simple task
claude --thinking=10000 "add comment to function"

# ✅ Fast: No thinking needed
claude "add comment to function"
```

**Fix:** Remove `--thinking` flag for simple tasks

**Question B: Context too large?**

```bash
# ❌ Slow: Attached 100+ files
claude "explain auth" @src/**/*.ts

# ✅ Fast: Specific files only
claude "explain auth" @src/auth/validate.ts @src/middleware/auth.ts
```

**Fix:** 
1. Use codebase search first: `claude "find auth validation code"`
2. Then read specific files
3. Attach only 3-5 most relevant files

**Question C: Wrong model?**

```bash
# ❌ Slow: Opus for simple task
claude --model claude-opus-4-1 "format code"

# ✅ Fast: Haiku for simple task
claude --model claude-haiku-4-5 "format code"
```

**Model selection:**
- **Simple tasks** → Haiku (10x faster)
- **Daily coding** → Sonnet (balanced)
- **Complex problems** → Opus (thorough but slow)

**Question D: Streaming disabled?**

```bash
# ❌ Feels slow: Wait for full response
claude "explain" --no-stream

# ✅ Feels fast: Incremental output
claude "explain" --stream
```

**Fix:** Enable streaming (default in most cases)

**Performance optimization checklist:**
- [ ] Extended thinking only for complex tasks
- [ ] Context limited to 3-5 relevant files
- [ ] Using appropriate model (Haiku for simple)
- [ ] Streaming enabled
- [ ] Prompt caching enabled (create CLAUDE.md)

---

#### Problem 4: Costs Too High

**Symptoms:**
- Monthly bill higher than expected
- Token usage surprisingly high
- Budget alerts triggering

**Decision Path:**

**Step 1: Check Usage Stats**
```bash
# See current month usage
claude --usage-stats --month=current

# See by operation type
claude --cost-report --sort-by=cost --top=20

# Example output:
# Operation                    Cost    Tokens
# git-diff-review              $5.20   520K
# extended-thinking-arch       $3.40   45K
# file-generation              $2.10   210K
```

**Step 2: Identify Cost Drivers**

**Common culprits:**

**A. No Prompt Caching** (90% more expensive)
```bash
# Check if CLAUDE.md exists
ls CLAUDE.md

# If missing, create it:
cat > CLAUDE.md << 'EOF'
# Project: [Your Project Name]

## Tech Stack
[Your stack]

## Architecture
[Your architecture]

## Conventions
[Your conventions]
EOF
```

**Savings:** 90% on repeated context

**B. Using Wrong Model**
```bash
# Check default model
claude --config-get defaultModel

# If it's Opus, change to Sonnet/Haiku:
claude --config-set defaultModel claude-sonnet-4-5
```

**Savings:** 5-10x depending on model switch

**C. Extended Thinking Always On**
```bash
# Check if thinking is in default config
cat ~/.clauderc | grep thinking

# Remove if present:
claude --config-set thinking 0
```

**Use thinking only explicitly:**
```bash
claude --thinking=5000 "complex task"
```

**Savings:** 2-3x for tasks that don't need it

**D. Not Using Batch API**
```bash
# ❌ Expensive: Process 100 files synchronously
for file in *.ts; do
  claude "process $file"
done

# ✅ Cheaper: Use Batch API (50% discount)
claude --batch files.txt
```

**Savings:** 50% for async work

**Step 3: Set Budget Alerts**
```bash
# Set monthly budget
claude --set-budget 100  # $100/month

# Alert at 80%
claude --alert-at 80

# Get notifications
claude --notify-email your@email.com
```

**Cost optimization checklist:**
- [ ] CLAUDE.md exists (enables caching)
- [ ] Default model is Sonnet/Haiku (not Opus)
- [ ] Extended thinking disabled by default
- [ ] Using Batch API for async work
- [ ] Budget alerts configured

**Target costs:**
- Individual developer: $5-10/month (optimized)
- Heavy user: $20-50/month
- Team of 10: $50-200/month (optimized)

See [Section 15: Cost Optimization](../05-prompt-context-mastery/15-context-management#cost-optimization) for detailed strategies.

---

#### Problem 5: VS Code Extension Issues

**Symptom A: Extension Not Loading**

**Step 1: Check Installation**
```bash
# List installed extensions
code --list-extensions | grep anthropic

# Expected: anthropic.claude-code
# If missing:
code --install-extension anthropic.claude-code
```

**Step 2: Check VS Code Version**
```
Help → About → Version

Required: 1.98.0 or higher
```

If older: Update VS Code

**Step 3: Reload Window**
```
Cmd/Ctrl+Shift+P → "Reload Window"
```

**Step 4: Check Extension Logs**
```
View → Output → Select "Claude Code" dropdown
```

Look for errors in red.

**Symptom B: Plan Mode Not Showing**

**Cause 1: Disabled in Settings**
```json
// Settings → Claude Code → Plan Mode
{
  "claudeCode.planMode": true  // Must be true
}
```

**Cause 2: Single-File Change**
Plan Mode only activates for multi-file changes or large refactorings.

**Force Plan Mode:**
```
User: "Create a plan to refactor X - don't apply yet"
```

**Symptom C: Slow Performance**

**Fix 1: Close Old Sessions**
- Click session list
- Close completed conversations
- Keep only active ones

**Fix 2: Detach Large Files**
- Click "X" on attached files when done
- Only attach 3-5 files at a time

**Fix 3: Restart Extension**
```
Cmd/Ctrl+Shift+P → "Reload Window"
```

**Symptom D: API Key Not Working**

**Step 1: Check Key in Settings**
```
Settings → Search "Claude Code" → API Key
```

Verify key is correct (starts with `sk-ant-`)

**Step 2: Check Environment Variable**
```bash
echo $ANTHROPIC_API_KEY
```

Extension uses environment variable if setting is empty.

**Step 3: Generate New Key**
- Go to console.anthropic.com
- Create new API key
- Update in VS Code settings
- Reload window

See [Section 6: VS Code Extension Guide](../02-cli-mastery/06-cli-vs-vscode) for comprehensive extension troubleshooting.

---

#### Problem 6: Merge Conflicts

**Symptom:** Git merge conflicts with Claude-generated code

**Decision Path:**

**Step 1: List Conflicts**
```bash
git diff --name-only --diff-filter=U
```

**Step 2: Use Claude to Resolve**
```bash
# Get full conflict context
git diff > conflicts.txt

# Ask Claude
cat conflicts.txt | claude "Help resolve these merge conflicts:

For each file in conflict:
1. What changed in each branch
2. How to merge both changes
3. Potential issues after merge
4. Resolved code

Be conservative - prefer keeping both changes unless they're contradictory."
```

**Step 3: Apply Resolutions**
- Review Claude's suggested resolutions
- Apply to files manually
- Test thoroughly

**Step 4: Mark Resolved**
```bash
git add <resolved-files>
git merge --continue
```

**Prevention:**
- Pull frequently (daily)
- Coordinate with team on shared files
- Use feature branches
- Small, frequent commits

---

## Quick Fixes Reference Table

| Symptom | Most Likely Cause | Quick Fix |
|---------|------------------|-----------|
| "Command not found" | CLI not installed | `npm install -g @anthropic/claude-code` |
| "Invalid API key" | Key not set or expired | `export ANTHROPIC_API_KEY="your-key"` |
| Very slow responses | Extended thinking on | Remove `--thinking` flag |
| High costs | No prompt caching | Create `CLAUDE.md` file |
| Generic answers | Insufficient context | Attach relevant files with `@file` |
| Extension not loading | Old VS Code version | Update VS Code to 1.98.0+ |
| Context window exceeded | Too many files | Attach only 3-5 relevant files |
| Plan Mode not showing | Single file change | Request multi-file change or "create plan" |
| Rate limited (429) | Too many requests | Wait or upgrade plan |
| Connection timeout | Network/firewall issue | Check firewall, try different network |

---

## When to Ask for Help

**Try self-troubleshooting first** using this decision tree.

**Ask for help if:**
- ✅ Followed decision tree completely
- ✅ Checked all quick fixes
- ✅ Problem persists for 30+ minutes
- ✅ Impacts production system
- ✅ Potential bug in Claude Code itself

**Where to ask:**
1. **Anthropic Discord** → [anthropic.com/discord](https://anthropic.com/discord) (most active)
2. **GitHub Issues** → For confirmed bugs
3. **Email Support** → For account/billing issues

**What to include in help request:**
```
**Problem:** [One sentence description]

**What I tried:**
1. [Step from decision tree]
2. [Another step]
3. [etc.]

**Environment:**
- OS: [Windows/Mac/Linux]
- VS Code version: [if using extension]
- Claude CLI version: [run `claude --version`]
- Node version: [run `node --version`]

**Error logs:**
[Paste relevant logs]

**To reproduce:**
1. [Step 1]
2. [Step 2]
3. [See error]
```

---

## Authentication Issues

### API Key Not Recognized
```bash
# Check environment variable
echo $ANTHROPIC_API_KEY

# If empty, set it
export ANTHROPIC_API_KEY="sk-ant-your-key"

# Test
claude "test"
```

### MCP Server Authentication Fails
```bash
# Check MCP config
cat .claude/mcp_config.json

# Verify environment variables
env | grep GOOGLE
env | grep JIRA

# Test MCP server directly
npx @anthropics/mcp-server-gdrive --test
```

## Extended Thinking Issues

### Timeout on Large Budgets
**Problem:** Requests with 32K+ thinking budget timeout

**Solution:**
- Use Batch API for >32K budgets
- Start with 10K, increase if needed
- Break complex tasks into steps

### Unexpected Costs
**Problem:** Extended thinking more expensive than expected

**Solution:**
- Start with 2K budget
- Monitor token usage
- Use thinking only for complex tasks
- Consider Claude Haiku 4.5 for simple tasks

## Context Window Overflow

### Too Many Files
**Problem:** "Context window exceeded" error

**Solution:**
```bash
# Use focused context
claude "@specific-file" instead of "@entire-directory"

# Use .claudeignore
echo "node_modules/" >> .claudeignore
echo "dist/" >> .claudeignore

# Use Batch API for full codebase analysis
```

## Performance Issues

### Slow Responses
**Problem:** Claude takes too long to respond

**Solutions:**
1. Use faster model (Claude Haiku 4.5)
2. Reduce context (fewer files)
3. Disable extended thinking for simple tasks
4. Use streaming for immediate feedback

### High API Costs
**Problem:** Unexpected high bills

**Solutions:**
1. Enable prompt caching (90% savings)
2. Use Claude Haiku 4.5 for simple tasks
3. Set monthly budget limits
4. Monitor usage dashboard

## CLI Installation Issues

### Command Not Found
```bash
# Add to PATH
export PATH="$HOME/.claude/bin:$PATH"

# Or reinstall
curl -fsSL https://claude.ai/install.sh | sh
```

### Permission Denied
```bash
# Fix permissions
chmod +x ~/.claude/bin/claude

# Or use sudo (if necessary)
sudo npm install -g @anthropic-ai/claude-code
```

[← Back: Reference Guide](20-complete-reference) | [Next: Productivity Benchmarks →](22-productivity-benchmarks)




# Section 4c: Interactive Features - Plan Mode, Context Rewind & More

Claude Code includes powerful interactive features that set it apart from other AI coding tools. These features give you control, transparency, and safety while working with AI-generated code.

---

## Overview: Claude Code's Unique Features

| Feature | What It Does | Why It Matters |
|---------|--------------|----------------|
| **Context Rewind** | Undo conversation + code changes | Fearless exploration without git reset |
| **Plan Mode** | Preview changes before execution | Trust through transparency |
| **Slash Commands** | Quick actions without typing | Faster workflows |
| **Interactive Editing** | Modify plans before accepting | Fine-grained control |
| **Multi-Turn Context** | Maintains conversation history | Natural iterative development |

**No other AI coding tool has all of these.**

---

## Context Rewind (Double-ESC)

### What Is It?

Context Rewind is **time travel for both conversation and code**. Press ESC twice to undo not just your last message, but also any code changes Claude made.

```
Traditional Approach (Other Tools):
  You: "Add authentication"
  AI: [Implements OAuth]
  You: "Oops, I wanted basic auth"
  You: git reset --hard  # Manual cleanup
  You: "Actually, add basic auth"

Claude Code with Context Rewind:
  You: "Add authentication"
  Claude: [Implements OAuth]
  You: <ESC><ESC>  # Instant rewind
  You: "Add basic auth instead"
  Claude: [Implements basic auth]
```

### Why It's Revolutionary

**Problem**: AI misunderstands → You get wrong implementation → Manual cleanup required

**Solution**: Instant rewind to before changes

**Benefits**:
- 🎯 **Fearless Exploration**: Try ideas without commitment
- ⚡ **Fast Iteration**: No git gymnastics
- 🧠 **Learning**: See multiple approaches safely
- 🔄 **Natural Conversation**: Like real pair programming

---

### How to Use Context Rewind

#### Basic Usage

```bash
# CLI
claude

> Add user authentication
# Claude implements OAuth with JWT

> <ESC><ESC>  # Press ESC twice quickly

# Rewinds to before "Add user authentication"
# Code changes undone
# Conversation state reset

> Add basic authentication instead
# Claude implements basic auth

> Works perfectly!
```

#### VS Code Extension

```
In Claude Code panel:

You: "Refactor this to use classes"
Claude: [Converts to classes]

Click: [⏮️ Rewind] button
Or: Ctrl+Z (Cmd+Z on Mac)

Conversation rewinds
Code rewinds
Try different approach
```

---

### Use Cases

#### Use Case 1: Exploration Without Commitment

```bash
claude
> Implement caching with Redis
# Claude adds Redis caching

# Review... "Hmm, Redis is overkill for this project"

> <ESC><ESC>
> Implement in-memory caching instead
# Claude uses simple in-memory cache

# Much better for our scale
```

#### Use Case 2: Learning Multiple Approaches

```bash
> Design authentication system
# Claude designs JWT-based system

> <ESC><ESC>
> Design session-based authentication
# Claude designs session-based system

# Compare both approaches
# Choose best fit without cleanup
```

#### Use Case 3: Recovering from Misunderstandings

```bash
> Add pagination to the user list
# Claude implements server-side pagination

> Wait, I meant client-side pagination
> <ESC><ESC>
> Add client-side pagination to user list
# Claude implements correct version
```

#### Use Case 4: Rapid Prototyping

```bash
# Try 3 different UI layouts
> Create grid layout for products
# [Review] Not quite right

> <ESC><ESC>
> Create card layout for products
# [Review] Better but...

> <ESC><ESC>
> Create list layout with images
# [Review] Perfect!
```

---

### Advanced Context Rewind

#### Rewind Multiple Steps

```bash
> Add authentication
# Step 1: Claude adds auth

> Add authorization
# Step 2: Claude adds roles

> Add audit logging
# Step 3: Claude adds logging

# Want to go back to after Step 1?
> <ESC><ESC>  # Undoes Step 3
> <ESC><ESC>  # Undoes Step 2
# Now at: Just authentication, no authorization or logging

> Add different authorization approach
```

#### Selective Rewind

```bash
> Refactor auth module and add tests
# Claude does both

# You want to keep auth refactor but redo tests
> Keep the auth refactor, but let me rewrite the tests differently
# Claude understands context

# Or rewind and be specific:
> <ESC><ESC>
> Refactor auth module but don't add tests yet
```

---

### Context Rewind vs Git Reset

| Scenario | Context Rewind | Git Reset |
|----------|----------------|-----------|
| **Speed** | Instant (<1s) | Slower (5-10s) |
| **Conversation** | Rewinds dialogue too | Keeps dialogue |
| **Granularity** | Per-exchange | Per-commit |
| **Complexity** | ESC ESC | git reset --hard |
| **Learning Curve** | None | Requires git knowledge |
| **Safety** | Non-destructive (can redo) | Destructive |

**Use Context Rewind for**:
- Exploring ideas
- Fixing misunderstandings
- Learning different approaches
- Rapid iteration

**Use Git Reset for**:
- Committed changes you want to undo
- Reverting to specific commit
- Cleaning up branch
- Discarding multiple sessions

---

## Plan Mode

### What Is It?

Plan Mode shows you Claude's proposed changes **before** executing them. Think of it as a "preview + edit" feature.

```
Without Plan Mode (Risky):
  You: "Refactor entire auth system"
  Claude: [Makes 50 changes across 15 files]
  You: "Oh no, you changed things I didn't want!"

With Plan Mode (Safe):
  You: "Refactor entire auth system"
  Claude: [Shows plan]:
    Files to change:
      • src/auth.js (refactor)
      • src/middleware/auth.js (refactor)
      • tests/auth.test.js (update)
      • CLAUDE.md (update) ← I don't want this
    
  You: [Edit plan] Remove CLAUDE.md from list
  You: [Accept]
  Claude: [Makes only approved changes]
```

---

### Enabling Plan Mode

#### CLI

```bash
# Always use plan mode
claude --plan-mode

# Or in session
claude
> /plan on

# For specific request
> [PLAN] Refactor authentication system
# [PLAN] prefix triggers plan mode for that request
```

#### VS Code Extension

```json
// settings.json
{
  "claudeCode.ui.showPlanByDefault": true
}
```

Or toggle in UI:
```
Click: [Plan Mode: OFF] → [Plan Mode: ON]
```

---

### How Plan Mode Works

#### Step 1: Request

```bash
You: "Add user roles (admin, editor, viewer) to the system"
```

#### Step 2: Plan Preview

```
┌─────────────────────────────────────────────────┐
│ 📋 Implementation Plan                          │
├─────────────────────────────────────────────────┤
│                                                 │
│ Files to Create:                                │
│   ✨ src/models/Role.js                         │
│   ✨ src/middleware/checkRole.js                │
│   ✨ migrations/add_role_to_users.sql           │
│                                                 │
│ Files to Modify:                                │
│   ✏️ src/models/User.js (add role field)       │
│   ✏️ src/routes/admin.js (add role check)      │
│   ✏️ tests/auth.test.js (add role tests)       │
│   ✏️ CLAUDE.md (document role system)          │
│                                                 │
│ Changes Summary:                                │
│  1. Add role enum (ADMIN, EDITOR, VIEWER)       │
│  2. Add role column to users table              │
│  3. Create role check middleware                │
│  4. Apply middleware to admin routes            │
│  5. Add tests for role-based access             │
│                                                 │
│ Estimated Changes: ~200 lines across 7 files    │
│ Risk Level: Medium (modifies auth system)       │
│                                                 │
│ [Edit Plan] [Accept All] [Reject]               │
└─────────────────────────────────────────────────┘
```

#### Step 3: Review & Edit (Optional)

```
Click [Edit Plan]

✅ src/models/Role.js ← Keep
✅ src/middleware/checkRole.js ← Keep
❌ migrations/add_role_to_users.sql ← Remove (I'll write this)
✅ src/models/User.js ← Keep
✅ src/routes/admin.js ← Keep
❌ tests/auth.test.js ← Remove (tests later)
❌ CLAUDE.md ← Remove (I'll update docs)

Add constraint:
"Don't modify any existing routes, only add new middleware"

[Apply Edits]
```

#### Step 4: Execution

```
Claude implements only approved changes:
  ✅ src/models/Role.js (created)
  ✅ src/middleware/checkRole.js (created)
  ✅ src/models/User.js (modified)
  ✅ src/routes/admin.js (modified)

Skipped (as requested):
  ⏭️ migrations/add_role_to_users.sql
  ⏭️ tests/auth.test.js
  ⏭️ CLAUDE.md

Done! Review the changes.
```

---

### Plan Mode Use Cases

#### Use Case 1: Large Refactorings

```bash
> Refactor payment processing to use Stripe instead of PayPal

Plan shows:
  - 15 files to modify
  - 3 files to delete (PayPal integration)
  - 5 files to create (Stripe integration)
  - ~800 lines of changes

Review carefully:
  - Remove files you want to keep (e.g., old tests for reference)
  - Add constraints (e.g., "keep existing error handling patterns")
  - Verify no breaking changes to public API

Accept with confidence
```

#### Use Case 2: Learning

```bash
> Add caching to the user service

Plan Mode shows approach:
  1. Add Redis client
  2. Wrap database calls with cache checks
  3. Add cache invalidation on updates
  4. Add cache configuration

You learn:
  - Where caching logic should go
  - How to structure cache keys
  - Invalidation strategy

Decide:
  - Accept as-is, or
  - Modify approach, or
  - Ask questions before accepting
```

#### Use Case 3: Avoiding Unintended Changes

```bash
> Update the auth middleware to log requests

Without Plan Mode:
  Claude might also "helpfully" refactor unrelated code

With Plan Mode:
  Plan shows: "Also refactoring auth.js to use async/await"
  You: "No, only add logging"
  Edit plan → Remove refactoring
  Accept
```

---

### Advanced Plan Mode

#### Risk Assessment

```
Plan includes automatic risk levels:

┌─────────────────────────────────────────────┐
│ Risk Level: 🟢 Low                          │
│ - Small change (50 lines)                   │
│ - Only adding code (not removing)           │
│ - Has test coverage                         │
│ - No breaking changes                       │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│ Risk Level: 🟡 Medium                       │
│ - Moderate change (200 lines)               │
│ - Modifies existing logic                   │
│ - Auth/security related                     │
│ - Recommend extra review                    │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│ Risk Level: 🔴 High                         │
│ - Large change (1000+ lines)                │
│ - Deletes existing code                     │
│ - Breaking changes to API                   │
│ - Multiple systems affected                 │
│ - STRONGLY recommend careful review         │
└─────────────────────────────────────────────┘
```

#### Partial Acceptance

```bash
Plan shows 10 files

Instead of Accept All or Reject All:

File-by-file review:
  1. src/auth.js ✅ [Accept]
  2. src/routes.js ✅ [Accept]
  3. src/config.js ❌ [Reject] - I'll handle this
  4. tests/auth.test.js ⏸️ [Skip for now]
  5. ... review rest ...

Result:
  - Accepted: Files 1, 2, 5, 7, 9
  - Rejected: Files 3, 6
  - Skipped: Files 4, 8, 10

Continue with skipped files later
```

---

## Slash Commands

Quick actions without typing full sentences.

### Core Commands

#### /help

```bash
> /help

Available Commands:
  /help              Show this help
  /clear             Clear conversation (keep code)
  /reset             Reset conversation and code
  /context           Show files in context
  /files             List all project files
  /cost              Show token usage and cost
  /model <name>      Switch model
  /thinking <budget> Set thinking budget
  /plan <on|off>     Toggle plan mode
  /plugin <action>   Manage plugins
  /skill <name>      Load skill
  /export            Export conversation
  /import            Import conversation
```

---

#### /clear vs /reset

```bash
# /clear - Clears conversation, keeps code changes
> Add authentication
# Code changes applied

> Add authorization
# More changes

> /clear
# Conversation cleared
# Code changes remain on disk

> Continue working (fresh context)

# /reset - Resets EVERYTHING
> Add authentication
# Code changes applied

> /reset
# Conversation cleared
# Code changes undone (like Context Rewind)
# Clean slate
```

---

#### /context

```bash
> /context

Files in Context (5):
  📄 CLAUDE.md (always included)
  📄 src/auth.js (you mentioned)
  📄 src/routes/users.js (auto-included - related)
  📄 tests/auth.test.js (auto-included - test file)
  📄 package.json (auto-included - project config)

Total tokens: 2,450 / 200,000

[Remove file] [Add more files] [Clear all]
```

---

#### /cost

```bash
> /cost

Session Cost Breakdown:
┌──────────────────────────────────────────┐
│ Current Session                          │
├──────────────────────────────────────────┤
│ Model: claude-sonnet-4-5                 │
│ Input tokens: 15,420                     │
│ Output tokens: 8,230                     │
│ Thinking tokens: 3,100 (extended)        │
│ Cache hits: 12,000 (90% savings!)        │
│                                          │
│ Cost breakdown:                          │
│   Input: $0.046                          │
│   Output: $0.164                         │
│   Thinking: $0.124                       │
│   Cache savings: -$0.360                 │
│                                          │
│ Total: $0.334 (saved $0.360 via caching)│
│                                          │
│ This session: $0.33                      │
│ Today: $2.45                             │
│ This week: $18.20                        │
│ This month: $67.50                       │
└──────────────────────────────────────────┘
```

---

#### /model

```bash
# Switch models on the fly

> /model haiku
Switched to claude-haiku-4-5 (fast + cheap)

> Generate simple CRUD tests
# Uses Haiku (perfect for simple tasks)

> /model sonnet
Switched to claude-sonnet-4-5 (balanced)

> Design authentication architecture
# Uses Sonnet (better for complex reasoning)

> /model opus
Switched to claude-opus-4 (most capable)

> Design entire microservices architecture
# Uses Opus (best for deep reasoning)

> /model
Current model: claude-opus-4
Available models:
  - claude-haiku-4-5 (fastest, cheapest)
  - claude-sonnet-4-5 (balanced) ← default
  - claude-opus-4 (most capable)
  - claude-4 (latest)
```

---

#### /thinking

```bash
# Adjust extended thinking budget

> /thinking
Current thinking budget: 5,000 tokens

> /thinking 10000
Thinking budget: 10,000 tokens
# Use for complex reasoning

> Design entire system architecture
# Claude uses up to 10K tokens for deep thinking

> /thinking 2000
Thinking budget: 2,000 tokens
# Reduce for simple tasks (faster + cheaper)

> Write unit test for add() function
# Uses minimal thinking (fast)

> /thinking 0
Thinking disabled
# Fastest mode for trivial tasks
```

---

#### /plan

```bash
# Toggle plan mode

> /plan on
Plan mode enabled
# All changes show plans first

> Add authentication
[Shows plan before implementing]

> /plan off
Plan mode disabled
# Direct implementation (faster iteration)

> /plan
Current: Plan mode enabled
```

---

### Plugin Commands

#### /plugin

```bash
> /plugin list
Installed Plugins:
  ✅ @anthropic/code-review (v1.2.0)
  ✅ @anthropic/test-generator (v1.0.5)
  ⚠️ @community/prettier-formatter (v0.9.1) - update available

> /plugin install @anthropic/security-scanner
Installing... ✓
@anthropic/security-scanner (v2.0.0) installed

> /plugin enable security-scanner
Plugin enabled

> /plugin disable code-review
Plugin disabled (temporarily)

> /plugin update --all
Updating all plugins...
  ✓ @community/prettier-formatter (v0.9.1 → v1.0.0)
Done!
```

---

#### /skill

```bash
> /skill list
Available Skills:
  📚 rust-expert
  📚 react-patterns
  📚 aws-infrastructure
  📚 security-best-practices

> /skill load rust-expert
Loading skill: rust-expert...
✓ Loaded knowledge:
  - Rust ownership & borrowing
  - Error handling patterns
  - Async runtime patterns
  - Cargo best practices

Now I'm ready to help with Rust!

> Explain ownership in this Rust code
@src/main.rs

# Claude uses rust-expert skill for answer

> /skill unload rust-expert
Skill unloaded (freed context space)
```

---

### Utility Commands

#### /export

```bash
> /export

Export Format:
  1. Markdown (.md) - Human readable
  2. JSON (.json) - Machine readable
  3. HTML (.html) - Web viewable

Select: 1

Exporting conversation...
Saved to: conversation-2025-12-19.md

Contains:
  - Full conversation history
  - Code changes made
  - Files in context
  - Metadata (model, cost, etc.)

Use case:
  - Documentation
  - Team sharing
  - Portfolio
  - Troubleshooting
```

#### /import

```bash
> /import conversation-2025-12-15.md

Importing...
✓ Loaded conversation (45 exchanges)
✓ Restored context files (8 files)
✓ Restored model settings

Continue from where you left off!
```

---

## Interactive Editing

### What Is It?

Modify Claude's output before accepting it.

### Use Cases

#### Use Case 1: Tweaking Code

```bash
> Add error handling to fetchUser()

Claude shows:
```javascript
async function fetchUser(id) {
  try {
    const user = await db.query('SELECT * FROM users WHERE id = ?', [id]);
    return user;
  } catch (error) {
    console.error(error);
    throw error;
  }
}
```

You edit before accepting:
```javascript
async function fetchUser(id) {
  try {
    const user = await db.query('SELECT * FROM users WHERE id = ?', [id]);
    if (!user) {
      throw new AppError('User not found', 404);
    }
    return user;
  } catch (error) {
    logger.error('Failed to fetch user', { id, error });
    throw error;
  }
}
```

[Accept Edited Version]
```

#### Use Case 2: Adjusting Plans

```bash
Plan shows:
  Files to modify:
    • src/auth.js
    • src/routes.js
    • tests/auth.test.js
    • CLAUDE.md

Edit plan:
  Remove: CLAUDE.md
  Add constraint: "Use bcrypt, not argon2"
  Add file: "Also update src/config/auth.config.js"

[Apply Edited Plan]
```

---

## Multi-Turn Context

### How It Works

```bash
# Turn 1
> What does the auth middleware do?

Claude: "The auth middleware validates JWT tokens..."

# Turn 2 (Claude remembers)
> Add rate limiting to it

Claude: "I'll add rate limiting to the auth middleware we just discussed..."
# Uses context from Turn 1

# Turn 3 (Still remembers)
> Now add logging

Claude: "I'll add logging to the rate-limited auth middleware..."
# Uses context from Turns 1 & 2
```

### Context Awareness

```bash
> @src/auth.js explain this

Claude: "This auth module handles JWT validation..."

> What about the expiry?

Claude: "In src/auth.js, the expiry is set to 24 hours on line 45..."
# Knows "the" refers to previously mentioned file

> Double it

Claude: "Changing JWT expiry from 24 to 48 hours in src/auth.js..."
# Understands "it" = "expiry" = "24 hours"
```

---

## Best Practices

### Context Rewind ✅

**Do**:
- ✅ Use freely for exploration
- ✅ Rewind when Claude misunderstands
- ✅ Try multiple approaches
- ✅ Learn by seeing alternatives

**Don't**:
- ❌ Rewind committed changes (use git reset)
- ❌ Rewind if you want to keep part of changes (be specific instead)

### Plan Mode ✅

**Do**:
- ✅ Enable for large refactorings
- ✅ Review plans carefully
- ✅ Edit plans to add constraints
- ✅ Use for learning (see approach)

**Don't**:
- ❌ Skip plan review (defeats purpose)
- ❌ Accept all without reading (plan mode = safety)

### Slash Commands ✅

**Do**:
- ✅ Learn top 10 commands
- ✅ Use /model to optimize cost/speed
- ✅ Check /cost regularly
- ✅ Use /context to manage tokens

**Don't**:
- ❌ Forget /help exists
- ❌ Leave high thinking budget for simple tasks

---

## Quick Reference

### Command Cheat Sheet

| Command | Quick Description |
|---------|-------------------|
| `ESC ESC` | Undo last exchange + code |
| `/help` | Show all commands |
| `/clear` | Clear chat, keep code |
| `/reset` | Clear chat + undo code |
| `/context` | Show files in context |
| `/cost` | Show token usage |
| `/model haiku` | Switch to fast model |
| `/model sonnet` | Switch to balanced model |
| `/thinking 10000` | Increase reasoning depth |
| `/plan on` | Enable plan preview |
| `/export` | Save conversation |

### Keyboard Shortcuts (VS Code)

| Action | Shortcut |
|--------|----------|
| Rewind | `Ctrl+Z` (or `Cmd+Z`) |
| Accept plan | `Ctrl+Enter` (or `Cmd+Enter`) |
| Reject plan | `Esc` |
| Edit plan | `Ctrl+E` (or `Cmd+E`) |
| New session | `Ctrl+Shift+C` (or `Cmd+Shift+C`) |

---

## Next Steps

- **Learn Practical Prompting**: [Part 5: Prompt Engineering](../05-prompt-context-mastery/14-prompt-engineering)
- **Set Up CLAUDE.md**: [Section 2b: CLAUDE.md Guide](../01-fundamentals-core-concepts/02b-claude-md-guide)
- **Explore Workflows**: [Section 3b: Daily Workflows](../01-fundamentals-core-concepts/03b-daily-workflows)

---

[← Back: VS Code Extension](04b-vscode-extension-guide) | [Next: CLI Automation →](05-cli-automation)


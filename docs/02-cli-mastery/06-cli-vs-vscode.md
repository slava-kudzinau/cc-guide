---
title: "Section 6: Claude Code VS Code Extension - Complete Guide"
parent: "Part 2: Claude Code CLI Mastery"
nav_order: 5
---

# Section 6: Claude Code VS Code Extension - Complete Guide

**What You'll Learn:**
- Installing and configuring the official Claude Code VS Code Extension
- Understanding Plan Mode for multi-file refactoring
- Mastering core workflows (feature development, debugging, code review)
- When to use CLI vs Extension vs both (hybrid workflows)
- Advanced extension features and optimization

**Time to read:** 20-30 minutes  
**Time to master:** 2-4 hours with hands-on practice

---

## 6.1 Installation & Setup

### Requirements

- **VS Code Version**: 1.98.0 or higher
- **Anthropic API Key**: Get from [console.anthropic.com](https://console.anthropic.com/)
- **Operating System**: Windows, macOS, or Linux

### Installation Methods

#### Method 1: Via VS Code Marketplace (Recommended)

1. **Open VS Code**
2. **Open Extensions** view:
   - Click Extensions icon in sidebar
   - Or press `Ctrl+Shift+X` (Windows/Linux)
   - Or press `Cmd+Shift+X` (macOS)

3. **Search for "Claude Code"**
   - Look for the official extension by Anthropic
   - Verify publisher: "Anthropic"

4. **Click "Install"**
   - Extension will download and install
   - Spark icon will appear in sidebar

#### Method 2: Via Command Line

```bash
code --install-extension anthropic.claude-code
```

**Verify installation:**
```bash
code --list-extensions | grep anthropic
```

### First-Time Configuration

#### Step 1: Set API Key

**Option A: Through Extension UI (Easiest)**
1. Click Spark icon in sidebar
2. Click "Set API Key" button
3. Paste your API key
4. Click "Save"

**Option B: Through VS Code Settings**
1. `Ctrl/Cmd+,` to open Settings
2. Search "Claude Code"
3. Find "API Key" setting
4. Paste your key

**Option C: Through Environment Variable (Recommended for Teams)**
```bash
# Add to ~/.bashrc or ~/.zshrc
export ANTHROPIC_API_KEY="your-key-here"
```

Then restart VS Code.

#### Step 2: Configure Preferences

Access settings: `Ctrl/Cmd+,` → Search "Claude Code"

**Key settings to configure:**

| Setting | Recommendation | Why |
|---------|---------------|-----|
| **Default Model** | Claude Sonnet 4.5 | Best balance of speed/quality |
| **Auto-Save** | On | Prevents losing context |
| **Plan Mode** | Enabled | Review changes before applying |
| **Streaming** | Enabled | Faster perceived response |
| **Context Window** | 200K (default) | Sufficient for most projects |

#### Step 3: Verify Setup

Create a test file:

```javascript
// test.js
function add(a, b) {
  return a + b;
}
```

1. Open Claude Code sidebar (Spark icon)
2. Ask: "Add JSDoc comment to this function"
3. ✅ If it works, setup complete!

---

## 6.2 Interface Overview

### Sidebar Anatomy

```
┌─────────────────────────────┐
│ ⚡ Claude Code              │ ← Spark icon
├─────────────────────────────┤
│  New Conversation [+]       │ ← Start fresh chat
│  Search History [🔍]        │ ← Find past conversations
├─────────────────────────────┤
│  📁 Current Conversations   │
│  ├─ Feature: Auth refactor  │
│  ├─ Bug: Memory leak        │
│  └─ Docs: API guide         │
├─────────────────────────────┤
│  💬 Chat Input              │
│  ┌─────────────────────────┐│
│  │ Ask Claude...           ││
│  │                         ││
│  │ @file src/auth.ts       ││ ← File attachments
│  │ [📎] [🖼️] [⚙️]         ││ ← Attach/Image/Settings
│  └─────────────────────────┘│
└─────────────────────────────┘
```

### Core UI Elements

**1. Conversation List**
- See all active sessions
- Organized by project
- Search and filter
- Resume any conversation

**2. Chat Input**
- Type natural language queries
- Attach files with `@file` or drag-drop
- Add images (screenshots, diagrams)
- Multi-line input (Shift+Enter)

**3. Response Area**
- Streaming responses (real-time output)
- Code blocks with syntax highlighting
- Plan Mode (shows changes before applying)
- Copy/Apply buttons

**4. File Attachments**
- Drag-drop files from Explorer
- Use `@file` mention syntax
- Attach images for visual context
- Shows attached file count

---

## 6.3 Plan Mode - Deep Dive

**Plan Mode** is the killer feature of the VS Code Extension. It lets you review Claude's planned changes **before** they're applied.

### What is Plan Mode?

When Claude needs to make changes across multiple files, Plan Mode:
1. Shows you **what** will change
2. **Where** it will change (file + line numbers)
3. **Why** it's changing (Claude's reasoning)
4. Lets you **approve/reject** each step

### When Plan Mode Activates

**Automatically activates when:**
- ✅ Multi-file changes (2+ files)
- ✅ Large refactorings (50+ lines)
- ✅ Structural changes (new files/folders)
- ✅ Complex operations (database migrations, API changes)

**Manual activation:**
```
Ask Claude: "Plan the changes to refactor auth, but don't apply yet"
```

### Plan Mode Interface

```
┌──────────────────────────────────────┐
│ 📋 Plan: Refactor auth to use OAuth  │
├──────────────────────────────────────┤
│ Step 1/5: Update auth middleware     │
│ File: src/middleware/auth.ts         │
│ Lines: 12-34                         │
│                                      │
│ [View Diff] [Approve] [Reject]      │
├──────────────────────────────────────┤
│ Step 2/5: Add OAuth provider         │
│ File: src/auth/providers/google.ts   │
│ (NEW FILE)                           │
│                                      │
│ [View Diff] [Approve] [Reject]      │
├──────────────────────────────────────┤
│ [Approve All] [Reject All] [Modify]  │
└──────────────────────────────────────┘
```

### Working with Plans

#### Approving Changes

**Approve individual steps:**
1. Review diff (click "View Diff")
2. Check file changes
3. Click "Approve" if good

**Approve all:**
- Click "Approve All" to apply entire plan
- Use when you trust the changes
- Still shows final diff before commit

#### Rejecting Changes

**Reject specific steps:**
- Click "Reject" on problematic steps
- Other steps still apply
- Explain why: "Don't change the tests"

**Reject entire plan:**
- Click "Reject All"
- Start over with refined prompt
- No files modified

#### Modifying Plans

**Request adjustments:**
```
User: "In step 3, also add error handling for network failures"
```

Claude updates the plan in real-time.

### Plan Mode Example: Full Workflow

**Scenario:** Refactor authentication across 5 files

**1. Initial Request**
```
User: "Refactor authentication to use JWT instead of sessions - 
update middleware, routes, and tests"
```

**2. Claude Creates Plan**
```
Plan: JWT Authentication Refactor

Step 1/5: Update auth middleware
- File: src/middleware/auth.ts
- Replace session validation with JWT validation
- Add JWT verification function

Step 2/5: Update login route
- File: src/routes/auth.ts  
- Generate JWT on successful login
- Remove session creation

Step 3/5: Update logout route
- File: src/routes/auth.ts
- Remove session destruction
- Blacklist JWT (optional)

Step 4/5: Update tests
- File: tests/auth.test.ts
- Replace session mocks with JWT mocks
- Add JWT expiration tests

Step 5/5: Add JWT utilities
- File: src/utils/jwt.ts (NEW)
- Sign function
- Verify function
- Refresh function
```

**3. Review Each Step**

Click "View Diff" for Step 1:
```diff
// src/middleware/auth.ts
-import { getSession } from '../session';
+import { verifyJWT } from '../utils/jwt';

 export async function authMiddleware(req, res, next) {
-  const session = await getSession(req.sessionId);
-  if (!session || !session.userId) {
+  const token = req.headers.authorization?.split(' ')[1];
+  if (!token) {
     return res.status(401).json({ error: 'Unauthorized' });
   }
+  
+  try {
+    const payload = await verifyJWT(token);
+    req.userId = payload.userId;
+  } catch (err) {
+    return res.status(401).json({ error: 'Invalid token' });
+  }
   
   next();
 }
```

**4. Approve or Adjust**
```
User: "Looks good, but in Step 5, also add a refresh token function"
```

Claude updates plan, adds refresh token.

**5. Apply Changes**

Click "Approve All" → Changes applied to all 5 files.

**6. Test Immediately**
```bash
npm test
```

If tests fail, continue conversation:
```
User: "Tests failing - check test/auth.test.ts"
```

### Plan Mode Best Practices

#### ✅ Do's

- **Review diffs carefully** - Plan Mode exists for a reason
- **Test after applying** - Run tests immediately
- **Ask for explanations** - "Why did you change line 45?"
- **Approve incrementally** - Apply Step 1, test, then Step 2
- **Use for learning** - See how Claude approaches refactoring

#### ❌ Don'ts

- **Don't blindly approve** - You're responsible for the code
- **Don't skip testing** - Plan Mode doesn't guarantee correctness
- **Don't approve huge plans** - Break into smaller chunks
- **Don't ignore warnings** - Claude might flag risks

---

## 6.4 Auto-Accept Mode

**Auto-Accept Mode** skips Plan Mode and applies changes immediately.

### When to Use Auto-Accept

**Safe operations:**
- ✅ Code formatting
- ✅ Adding comments/docs
- ✅ Simple refactors (rename variable)
- ✅ Fixing linting errors
- ✅ Adding tests (not changing logic)

**Example:**
```
User: "Format this file with Prettier" 
[Auto-Accept enabled] → Applied immediately
```

### When NOT to Use Auto-Accept

**Risky operations:**
- ❌ Logic changes
- ❌ API modifications
- ❌ Database schema changes
- ❌ Security-critical code
- ❌ Multi-file refactoring

### Enabling Auto-Accept

**Temporary (per request):**
```
User: "Add JSDoc comments - auto-accept"
```

**Session-wide:**
Settings → "Claude Code: Auto Accept" → Enable

**Per-file-type:**
```json
// .vscode/settings.json
{
  "claudeCode.autoAccept": {
    "*.md": true,  // Auto-accept for markdown
    "*.ts": false  // Review for TypeScript
  }
}
```

### Safety Tips

Even with Auto-Accept:
- **Review before committing** - Use `git diff` to see what changed
- **Run tests** - Automated changes might break things
- **Use git branches** - Easy to revert if needed
- **Disable for production** - Never auto-accept on main branch

---

## 6.5 Core Workflows in Extension

### Workflow 1: Feature Development

**Scenario:** Add user authentication with Google OAuth

**Step-by-step:**

**1. Start Conversation**
```
Click Spark icon → New Conversation

User: "Add Google OAuth authentication - I have:
- src/routes/auth.ts (existing routes)
- src/models/user.ts (user model)
- Environment: Node.js + Express + PostgreSQL

Requirements:
- Login with Google
- Store user in database
- Session management
- Redirect to dashboard after auth"
```

**2. Attach Relevant Files**
```
@src/routes/auth.ts
@src/models/user.ts
@src/config/database.ts
```

Or drag-drop files from Explorer.

**3. Claude Creates Plan**
```
Plan: Google OAuth Implementation

Step 1: Install dependencies (passport, passport-google-oauth20)
Step 2: Configure Google OAuth (add strategy)
Step 3: Update user model (add googleId field)
Step 4: Add OAuth routes (/auth/google, /auth/google/callback)
Step 5: Update middleware (handle OAuth session)
Step 6: Add environment variables
```

**4. Review & Customize**
```
User: "In Step 3, also add user profile photo from Google"
```

**5. Apply Changes**
- Review each step's diff
- Approve steps sequentially
- Test after each major step

**6. Iterative Refinement**
```
User: "Add error handling for when Google API is down"
User: "Add tests for OAuth flow"
User: "Update README with setup instructions"
```

**Result:** Complete feature implemented with tests and docs.

---

### Workflow 2: Debugging

**Scenario:** React component causing infinite re-renders

**Step-by-step:**

**1. Identify Problem**
```bash
# In terminal
npm start

# Browser console shows:
# "Warning: Maximum update depth exceeded"
```

**2. Open Claude Extension**
```
User: "I'm getting infinite re-renders in UserProfile component.
Error: Maximum update depth exceeded

Here's the component:"

@src/components/UserProfile.tsx
```

**3. Claude Analyzes**
```
Claude: "I see the issue. Line 12 has a state update inside the 
render function:

{user.posts.map(post => {
  setPostCount(user.posts.length); // ❌ This causes re-render
  return <Post key={post.id} {...post} />
})}

This triggers infinite re-renders. Fix: Use useEffect..."
```

**4. Apply Fix**
```
Claude shows diff:

-{user.posts.map(post => {
-  setPostCount(user.posts.length);
+useEffect(() => {
+  setPostCount(user.posts.length);
+}, [user.posts]);
+
+{user.posts.map(post => {
```

**5. Test Immediately**
- Switch to browser
- Refresh page
- ✅ Infinite render fixed!

**6. Understand Why**
```
User: "Explain why useEffect fixes this"

Claude: "useEffect runs after render, not during...
[detailed explanation]"
```

**Result:** Bug fixed + learned React fundamentals.

---

### Workflow 3: Code Review

**Scenario:** Review your changes before creating PR

**Step-by-step:**

**1. Stage Changes**
```bash
git add .
```

**2. Open Claude Extension**
```
User: "Review my staged changes for:
- Security vulnerabilities
- Performance issues
- Edge cases not handled
- Code style violations
- Missing tests

Be critical - pretend you're a senior engineer reviewing this PR."
```

**3. Claude Analyzes Diff**
```
Claude: "I reviewed your changes. Here's what I found:

🔴 Critical Issues:
1. Line 45 in auth.ts: SQL injection vulnerability
   Current: `query = "SELECT * FROM users WHERE id = " + userId`
   Fix: Use parameterized queries

2. Line 67: Password stored in plain text
   Must hash with bcrypt before storing

🟡 Warnings:
3. Line 23: N+1 query in loop
   Consider eager loading: User.findAll({ include: ['posts'] })

4. Missing error handling on line 89
   Add try-catch for database errors

🟢 Good Practices:
5. Excellent test coverage on new functions
6. Clear variable names and comments
```

**4. Fix Issues**
```
User: "Fix issues 1 and 2"

Claude applies fixes with explanations
```

**5. Re-review**
```
User: "Review again"

Claude: "✅ All critical issues resolved. 
Ready for PR with minor caveat: Consider adding integration tests."
```

**6. Create PR**
```bash
git commit -m "feat: add user authentication with security fixes"
git push origin feature/auth
gh pr create
```

**Result:** High-quality PR, fewer review cycles.

---

### Workflow 4: Learning Unfamiliar Code

**Scenario:** Just joined project, need to understand auth system

**Step-by-step:**

**1. Start Broad**
```
User: "I'm new to this project. Explain the authentication 
architecture - how does it work end-to-end?"

@src/auth/
```

**2. Claude Provides Overview**
```
Claude: "This project uses JWT authentication with refresh tokens.

Flow:
1. User logs in → POST /auth/login
2. Server validates credentials (auth/validate.ts)
3. Generate JWT + refresh token (auth/jwt.ts)
4. Return tokens to client
5. Client includes JWT in Authorization header
6. Middleware validates JWT (middleware/auth.ts)
7. If expired, use refresh token (auth/refresh.ts)

Key files:
- auth/strategies/ - OAuth providers
- auth/middleware.ts - Request authentication
- auth/jwt.ts - Token generation/validation
```

**3. Drill Down**
```
User: "How exactly does JWT validation work?"

@src/middleware/auth.ts
```

**4. Specific Questions**
```
User: "Where is the session stored?"

Claude: "Sessions are stored in Redis, configured in 
config/redis.ts. Key format: 'session:{userId}'..."

User: "What happens if Redis is down?"

Claude: "Check line 45 in middleware/auth.ts - there's a fallback 
to in-memory cache..."
```

**5. Understand Patterns**
```
User: "What's the error handling pattern used here?"

Claude: "This project uses a centralized error middleware pattern...
[explains custom error classes]"
```

**6. Make First Change Confidently**
```
User: "I need to add GitHub OAuth. Based on existing patterns,
how should I implement it?"

Claude: "Based on the Google OAuth implementation in 
auth/strategies/google.ts, here's how to add GitHub..."
```

**Result:** Ramp-up time reduced from days to hours.

---

## 6.6 CLI vs Extension: Decision Matrix

### Quick Reference Table

| Task | Use CLI | Use Extension | Reasoning |
|------|---------|---------------|-----------|
| **Quick file edit** | ❌ | ✅ | Visual diff + inline review |
| **Pre-commit hook** | ✅ | ❌ | Automated, no GUI needed |
| **Learning code** | ❌ | ✅ | Side-by-side code + explanation |
| **CI/CD pipeline** | ✅ | ❌ | Runs in non-interactive environment |
| **Multi-file refactor** | ❌ | ✅ | Plan Mode for safe changes |
| **Batch processing** | ✅ | ❌ | Loop through files |
| **Debugging** | ❌ | ✅ | Visual context + iterative |
| **Code review** | ⚠️ Both | ⚠️ Both | CLI for automation, Extension for manual |
| **Documentation** | ⚠️ Both | ⚠️ Both | CLI to generate, Extension to refine |
| **Git workflow** | ✅ | ❌ | Pipe git commands |
| **Testing** | ✅ | ❌ | Analyze test output |
| **Exploring APIs** | ❌ | ✅ | Interactive questions |

### Detailed Scenarios

#### Scenario 1: Daily Feature Development
**Best tool:** Extension (80%) + CLI (20%)

**Why:**
- Extension for interactive coding
- Plan Mode for safe refactoring
- Visual feedback while working
- CLI for quick reviews before commit

**Example workflow:**
```
Morning: Extension - "What should I work on today?"
Development: Extension - iterative feature building
Before commit: CLI - "git diff | claude 'review'"
```

#### Scenario 2: DevOps/Platform Engineering
**Best tool:** CLI (90%) + Extension (10%)

**Why:**
- Automate everything
- CI/CD integration
- Scriptable workflows
- Extension only for complex debugging

**Example workflow:**
```bash
# Everything in CLI
claude "generate terraform for RDS"
kubectl logs pod-123 | claude "analyze errors"
.git/hooks/pre-push # Automated checks
```

#### Scenario 3: Code Review (Manual)
**Best tool:** Extension (70%) + CLI (30%)

**Why:**
- Extension for detailed file-by-file review
- Visual context of changes
- CLI for automated first-pass

**Example workflow:**
```bash
# Step 1: CLI pre-screen
git diff main | claude "quick security scan"

# Step 2: Extension for deep review
Open extension → Review each file interactively

# Step 3: CLI for summary
git diff main | claude "summarize changes for PR description"
```

#### Scenario 4: Learning New Codebase
**Best tool:** Extension (95%) + CLI (5%)

**Why:**
- Interactive exploration
- Ask follow-up questions
- Visual code navigation
- See files while getting explanations

**Example workflow:**
```
Extension:
- "Explain the project structure"
- "How does auth work?" + attach files
- "Where is caching configured?"
- Navigate code based on answers

CLI:
- Quick questions: claude "what does this error mean?"
```

---

## 6.7 Hybrid Workflows (Best of Both)

### Pattern 1: PR Preparation

**Combine CLI automation + Extension manual review**

```bash
# Phase 1: Automated Checks (CLI)
echo "=== Running automated checks ==="

# Security scan
git diff main | claude "security audit - check for vulnerabilities"

# Performance analysis
git diff main | claude "identify performance issues"

# Test coverage
npm test -- --coverage | claude "suggest missing test cases"
```

**Then switch to Extension:**
```
User in Extension: "Based on the CLI analysis, help me fix the 
security issues found"

[Iterative fixes with Plan Mode]
```

**Finally, CLI for commit:**
```bash
git diff --cached | claude "generate commit message"
git commit -m "$(git diff --cached | claude 'commit message')"
```

### Pattern 2: Feature Development

**Start with Extension, use CLI for automation**

**Morning (Extension):**
```
User: "Plan today's work - I need to add rate limiting to API"

[Get implementation plan]
[Implement interactively with Plan Mode]
```

**During development (Extension):**
- Write code
- Ask questions
- Debug issues
- Refactor

**Before each commit (CLI):**
```bash
# Automated pre-commit hook
git diff --cached | claude "review and suggest improvements"
```

### Pattern 3: Documentation

**Generate with CLI, refine with Extension**

**Step 1: CLI bulk generation**
```bash
# Generate docs for all routes
for file in src/routes/*.ts; do
  claude "generate API doc for $file" >> docs/api.md
done
```

**Step 2: Extension refinement**
```
User in Extension: "Review docs/api.md - improve formatting,
add examples, fix inconsistencies"

[Review with visual preview]
[Apply structured improvements]
```

### Pattern 4: Testing Workflow

**CLI for execution, Extension for understanding**

**Terminal (CLI):**
```bash
# Run tests
npm test 2>&1 | tee test-output.txt

# Quick analysis
cat test-output.txt | claude "explain failures"
```

**If complex, switch to Extension:**
```
User: "Tests failing in auth.test.ts - help debug"

@tests/auth.test.ts
@src/auth/validate.ts

[Visual debugging with file context]
```

---

## 6.8 Advanced Extension Features

### Multi-Session Management

**Why use multiple sessions:**
- Separate concerns (feature vs bugfix)
- Different contexts (frontend vs backend)
- Parallel work streams
- Historical reference

**Creating sessions:**
```
Click "+" icon → "New Conversation"
Name: "Feature: Rate Limiting"
```

**Best practices:**
- One session per feature
- Clear naming convention
- Close when done (keeps list clean)
- Export important conversations

### File Attachment Strategies

**Method 1: @file mentions**
```
User: "Refactor @src/auth.ts to use @src/utils/jwt.ts"
```

**Method 2: Drag and drop**
- Drag files from Explorer
- Drop into chat input
- Claude receives full file content

**Method 3: Folder attachment**
```
User: "Analyze all files in @src/routes/"
```

**Method 4: Workspace context**
```
User: "Based on the codebase, suggest improvements"
[Claude automatically has workspace awareness]
```

**Optimization tips:**
- Attach only relevant files (don't overwhelm)
- Use folder attachment for related files
- Remove attachments when context changes
- Claude caches attached files (cost efficient)

### Image Support

**Use cases:**
- Screenshot of UI → "Implement this design"
- Error screenshot → "Debug this error"
- Diagram → "Implement this architecture"
- Wireframe → "Build this feature"

**How to use:**
1. Copy image to clipboard
2. Click image icon in chat input
3. Or paste directly (Ctrl/Cmd+V)

**Example:**
```
[Paste screenshot of login page]

User: "Implement this login page in React with validation"

Claude: Generates component matching the screenshot
```

### Third-Party Provider Support

**Supported providers:**
- AWS Bedrock
- Google Cloud Vertex AI
- Azure OpenAI (coming soon)

**Why use third-party:**
- ✅ Data stays in your cloud
- ✅ Compliance requirements
- ✅ Centralized billing
- ✅ Custom SLAs

**Configuration:**
```json
// .vscode/settings.json
{
  "claudeCode.provider": "aws-bedrock",
  "claudeCode.awsRegion": "us-east-1",
  "claudeCode.awsProfile": "development"
}
```

### Extension Configuration

**Essential settings:**

```json
{
  // Model selection
  "claudeCode.defaultModel": "claude-sonnet-4.5",
  
  // Performance
  "claudeCode.streaming": true,
  "claudeCode.contextWindow": 200000,
  
  // Safety
  "claudeCode.planMode": true,
  "claudeCode.autoAccept": false,
  
  // Caching
  "claudeCode.promptCaching": true,
  
  // UI
  "claudeCode.showTokenUsage": true,
  "claudeCode.showCost": true,
  
  // Workspace
  "claudeCode.claudeMdPath": "./CLAUDE.md",
  "claudeCode.respectGitignore": true
}
```

### Keyboard Shortcuts

**Default shortcuts:**

| Action | Shortcut (Mac) | Shortcut (Win/Linux) |
|--------|---------------|---------------------|
| Open sidebar | `Cmd+Shift+C` | `Ctrl+Shift+C` |
| New conversation | `Cmd+Shift+N` | `Ctrl+Shift+N` |
| Focus input | `Cmd+L` | `Ctrl+L` |
| Submit | `Enter` | `Enter` |
| Submit + New line | `Shift+Enter` | `Shift+Enter` |
| Attach file | `Cmd+U` | `Ctrl+U` |
| Clear input | `Cmd+K` | `Ctrl+K` |

**Custom shortcuts:**
```json
// keybindings.json
[
  {
    "key": "cmd+shift+a",
    "command": "claudeCode.attachCurrentFile"
  },
  {
    "key": "cmd+shift+r",
    "command": "claudeCode.reviewChanges"
  }
]
```

---

## 6.9 Troubleshooting Extension Issues

### Extension Not Loading

**Symptoms:**
- Spark icon missing
- Extension doesn't respond
- Sidebar empty

**Solutions:**

**1. Check installation:**
```bash
code --list-extensions | grep anthropic
```

If not installed:
```bash
code --install-extension anthropic.claude-code
```

**2. Restart VS Code:**
- `Cmd/Ctrl+Shift+P` → "Reload Window"

**3. Check VS Code version:**
```
Help → About
Requires: 1.98.0 or higher
```

Upgrade if needed.

**4. Check extension logs:**
- `View` → `Output` → Select "Claude Code"
- Look for errors

### API Key Errors

**Symptoms:**
- "Authentication failed"
- "Invalid API key"
- 401 errors

**Solutions:**

**1. Verify key is set:**
```bash
echo $ANTHROPIC_API_KEY
```

**2. Check key validity:**
- Go to console.anthropic.com
- Verify key exists and is active

**3. Set in VS Code:**
- Settings → "Claude Code: API Key"
- Paste key
- Restart VS Code

**4. Check environment:**
```bash
# Add to shell config
export ANTHROPIC_API_KEY="your-key"
source ~/.bashrc  # or ~/.zshrc
```

### Plan Mode Not Showing

**Symptoms:**
- Changes apply immediately
- No review step

**Solutions:**

**1. Enable Plan Mode:**
```json
{
  "claudeCode.planMode": true
}
```

**2. Request explicitly:**
```
User: "Create a plan to refactor auth - don't apply yet"
```

**3. Check operation size:**
- Plan Mode only activates for multi-file changes
- Single small changes might auto-apply

### Performance/Latency Issues

**Symptoms:**
- Slow responses
- Extension freezing
- High memory usage

**Solutions:**

**1. Close old sessions:**
- Clean up conversation list
- Export important ones first

**2. Reduce context:**
- Detach large files
- Use targeted file attachment
- Don't attach entire codebase

**3. Enable streaming:**
```json
{
  "claudeCode.streaming": true
}
```

**4. Check network:**
```bash
# Test connection
curl https://api.anthropic.com/v1/status
```

**5. Restart VS Code:**
- Memory leaks might accumulate
- Fresh start resolves most issues

### Conflicts with Other Extensions

**Symptoms:**
- Extension not working with other AI tools
- Keyboard shortcuts conflict
- UI elements overlapping

**Solutions:**

**1. Check for conflicts:**
- Disable other AI extensions temporarily
- Test Claude Code alone

**2. Resolve shortcut conflicts:**
```json
// keybindings.json
[
  {
    "key": "cmd+l",
    "command": "-copilot.chat.open",  // Disable Copilot's Cmd+L
    "when": "editorTextFocus"
  }
]
```

**3. Compatible extensions:**
- ✅ ESLint, Prettier (no conflicts)
- ✅ GitLens (no conflicts)
- ⚠️ GitHub Copilot (different shortcuts)
- ⚠️ Tabnine (may conflict)

---

## 6.10 Performance Optimization

### Reducing Latency

**1. Use streaming:**
```json
{
  "claudeCode.streaming": true
}
```
→ See output as it's generated (feels 3x faster)

**2. Enable prompt caching:**
- Create `CLAUDE.md` in project root
- Extension auto-caches it
- 90% faster repeat queries

**3. Attach only relevant files:**
```
❌ Bad: @src/ (100+ files)
✅ Good: @src/auth/validate.ts @src/models/user.ts
```

**4. Use specific questions:**
```
❌ Bad: "Improve this"
✅ Good: "Add error handling to the validateUser function on line 45"
```

### Reducing Costs

**1. Use appropriate models:**
```json
{
  "claudeCode.defaultModel": "claude-haiku-4.5"  // For simple tasks
}
```

Switch to Sonnet/Opus only when needed.

**2. Enable prompt caching:**
```json
{
  "claudeCode.promptCaching": true,
  "claudeCode.claudeMdPath": "./CLAUDE.md"
}
```

**3. Detach files when done:**
- Click "X" on attached files
- Reduces context size
- Lower token costs

**4. Close unused sessions:**
- Old sessions consume memory
- Cache takes up space

### Monitoring Usage

**Enable usage tracking:**
```json
{
  "claudeCode.showTokenUsage": true,
  "claudeCode.showCost": true
}
```

**View in UI:**
- Bottom of each response shows:
  - Input tokens
  - Output tokens
  - Estimated cost

**Monthly review:**
- Check Anthropic console
- Analyze usage patterns
- Optimize expensive operations

---

## 6.11 Extension vs CLI: Real-World Comparison

### Case Study 1: Authentication Refactoring

**Task:** Migrate from sessions to JWT across 8 files

**CLI Approach:**
```bash
# Generate plan
claude "create migration plan: sessions → JWT" > plan.md

# Manual file edits or scripted changes
for file in src/auth/*.ts; do
  claude "convert $file to use JWT" --output=$file
done

# Review
git diff

# Test
npm test
```

**Time:** 30-45 minutes  
**Pain points:** No visual feedback, manual coordination, harder to review

**Extension Approach:**
```
User: "Refactor authentication from sessions to JWT
Requirements:
- Update all 8 auth files
- Preserve existing tests structure
- Add JWT utilities
- Update middleware"

Attach: @src/auth/ @tests/auth/

[Plan Mode shows 8-step plan]
[Review each step's diff]
[Approve incrementally]
[Test after each major step]
```

**Time:** 20-30 minutes  
**Benefits:** Visual diffs, Plan Mode safety, incremental testing

**Winner:** Extension (for this complex, multi-file task)

---

### Case Study 2: Pre-Commit Hook

**Task:** Automated code review before every commit

**CLI Approach:**
```bash
# .git/hooks/pre-commit
#!/bin/bash
git diff --cached | claude "review for:
- Security issues
- Performance problems
- Missing tests
Exit non-zero if critical issues found"
```

**Time:** 5 seconds per commit  
**Automation:** Perfect

**Extension Approach:**
- Not applicable (no automation)
- Would require manual click before each commit

**Winner:** CLI (automation requirement)

---

### Case Study 3: Debugging Production Issue

**Task:** Diagnose why API endpoint returns 500

**CLI Approach:**
```bash
# Analyze logs
tail -n 100 /var/log/api.log | claude "find root cause"

# Check code
claude "explain potential issues" --files="src/routes/users.ts"

# Suggest fix
claude "fix the issue" --files="src/routes/users.ts" > fix.patch
```

**Time:** 10-15 minutes  
**Pain point:** Context switching, no visual code view

**Extension Approach:**
```
User: "API endpoint /users/:id returns 500 - help debug

Error log:
[paste error]

@src/routes/users.ts
@src/middleware/error-handler.ts

Claude:
- Analyzes error
- Points to specific line
- Shows visual fix
- Explains why it happened
```

**Time:** 5-8 minutes  
**Benefits:** Faster diagnosis, visual context, learning

**Winner:** Extension (interactive debugging)

---

## Summary: CLI vs Extension

### Use CLI When You Need:
- ✅ **Automation** (scripts, hooks, CI/CD)
- ✅ **Batch processing** (loop through files)
- ✅ **Piping** (command composition)
- ✅ **Speed** (one-line commands)
- ✅ **Non-interactive** (cron jobs, automation)

### Use Extension When You Need:
- ✅ **Visual feedback** (see diffs, syntax highlighting)
- ✅ **Plan Mode** (safe multi-file changes)
- ✅ **Learning** (interactive exploration)
- ✅ **Debugging** (iterative problem solving)
- ✅ **Complex refactoring** (coordinated changes)

### Use Both (Hybrid) For:
- ✅ **Feature development** (Extension for coding, CLI for automation)
- ✅ **Code review** (CLI for first pass, Extension for deep review)
- ✅ **Documentation** (CLI to generate, Extension to refine)
- ✅ **Team workflow** (CLI for shared scripts, Extension for individual work)

---

## Next Steps

**Now that you understand the Extension:**

1. **Install and configure** (15 min)
   - Follow Section 6.1
   - Set up API key
   - Verify with test query

2. **Try core workflows** (1 hour)
   - Feature development (Section 6.5.1)
   - Debugging (Section 6.5.2)
   - Code review (Section 6.5.3)

3. **Master Plan Mode** (30 min)
   - Practice with safe refactoring
   - Learn to review diffs
   - Build confidence

4. **Optimize setup** (15 min)
   - Configure keyboard shortcuts
   - Enable prompt caching
   - Set default model

5. **Integrate into daily workflow**
   - Start with simple queries
   - Gradually increase complexity
   - Track productivity gains

**Resources:**
- [Part 7: Reference Guide](../07-reference-troubleshooting/20-complete-reference) - Keyboard shortcuts, settings
- [Part 7: Troubleshooting](../07-reference-troubleshooting/21-troubleshooting) - Common issues
- [Official Claude Code Docs](https://docs.claude.com/claude-code)

---

[← Back: CLI Automation](05-cli-automation) | [Next: Advanced CLI Patterns →](07-advanced-cli-patterns)

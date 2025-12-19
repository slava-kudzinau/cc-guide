# Section 4b: VS Code Extension Complete Guide

The Claude Code VS Code extension brings the full power of Claude Code directly into your IDE with a native graphical interface. This guide covers everything from installation to advanced workflows.

---

## Why Use the VS Code Extension?

### Key Advantages

| Feature | CLI | VS Code Extension |
|---------|-----|-------------------|
| **Visual Diff** | Text-based | Side-by-side with syntax highlighting |
| **File Navigation** | @-mentions or paths | GUI file picker + @-mentions |
| **Conversation History** | Session-based | Persistent, searchable UI |
| **Multi-Session** | One at a time | Multiple simultaneous sessions |
| **Plan Editing** | Accept/reject only | Edit plans before accepting |
| **Learning Curve** | Terminal familiarity needed | Intuitive GUI |
| **Automation** | Full (scriptable) | Limited (GUI-focused) |
| **CI/CD Integration** | Yes | No |

**Use VS Code Extension When**:
- You prefer visual interfaces
- Working with UI/frontend code
- Need to see diffs before accepting
- Want to browse conversation history
- Learning Claude Code
- Pair programming (screen sharing)

**Use CLI When**:
- Automating workflows
- Writing scripts/hooks
- CI/CD pipelines
- SSH/remote sessions
- Complex piping workflows

---

## Installation & Setup

### Prerequisites

```bash
# Check VS Code version (need 1.98.0+)
code --version
# Should show: 1.98.0 or higher
```

### Installation Steps

1. **Open VS Code Extensions**
   - Press `Ctrl+Shift+X` (Windows/Linux) or `Cmd+Shift+X` (Mac)
   - Search: "Claude Code"
   - Click "Install" on the official Anthropic extension

2. **Verify Installation**
   - Look for the Spark ⚡ icon in the Activity Bar (left sidebar)
   - Click it to open Claude Code panel

3. **Authentication**

```json
// Method 1: API Key in settings.json
{
  "claudeCode.apiKey": "your-api-key-here",  // ⚠️ Not recommended
  "claudeCode.provider": "anthropic"
}
```

```bash
# Method 2: Environment variable (Recommended)
# Add to ~/.bashrc or ~/.zshrc
export ANTHROPIC_API_KEY="your-api-key-here"

# Restart VS Code to pick up environment
```

```json
// Method 3: AWS Bedrock
{
  "claudeCode.provider": "bedrock",
  "claudeCode.awsRegion": "us-east-1"
}
```

```json
// Method 4: Google Vertex AI
{
  "claudeCode.provider": "vertex",
  "claudeCode.vertexProjectId": "your-project-id",
  "claudeCode.vertexRegion": "us-central1"
}
```

4. **Verify Connection**
   - Click Spark icon
   - Start new session
   - Type: "Hello, are you working?"
   - Should get response from Claude

---

## Interface Overview

### Main Components

```
┌─────────────────────────────────────────────┐
│  Claude Code ⚡                    [+ New]  │ ← Header
├─────────────────────────────────────────────┤
│  📂 Sessions                                │
│    → Current Session (active)               │ ← Session List
│    → Feature/auth-refactor                  │
│    → Bug/payment-issue                      │
├─────────────────────────────────────────────┤
│  💬 Conversation                            │
│                                             │
│  User: Add user authentication              │
│                                             │
│  Claude: I'll help you add authentication.  │ ← Chat Area
│  Here's my plan:                            │
│  1. Create auth middleware                  │
│  2. Add JWT generation                      │
│  3. Update routes                           │
│                                             │
│  [Edit Plan] [Accept] [Reject]              │ ← Plan Actions
│                                             │
├─────────────────────────────────────────────┤
│  📝 Files in Context                        │
│    • src/middleware/auth.js                 │ ← Context Panel
│    • src/routes/users.js                    │
│    • CLAUDE.md                              │
├─────────────────────────────────────────────┤
│  > Type message... [@file] [📎]             │ ← Input Area
└─────────────────────────────────────────────┘
```

### Keyboard Shortcuts

| Action | Windows/Linux | Mac | Description |
|--------|---------------|-----|-------------|
| **Open Claude Code** | `Ctrl+Shift+P` → "Claude Code" | `Cmd+Shift+P` → "Claude Code" | Open panel |
| **New Session** | `Ctrl+Shift+C` | `Cmd+Shift+C` | Start fresh conversation |
| **Accept Plan** | `Ctrl+Enter` | `Cmd+Enter` | Accept Claude's changes |
| **Reject Plan** | `Esc` | `Esc` | Discard proposed changes |
| **Edit Plan** | `Ctrl+E` | `Cmd+E` | Modify before accepting |
| **Toggle Auto-Accept** | `Ctrl+Shift+A` | `Cmd+Shift+A` | Enable/disable auto-apply |
| **Add File to Context** | `@filename` | `@filename` | Mention file |
| **File Picker** | `Ctrl+O` | `Cmd+O` | GUI file picker |
| **Previous Message** | `Up Arrow` | `Up Arrow` | Edit last message |
| **Search Conversations** | `Ctrl+F` | `Cmd+F` | Search history |

---

## Key Features

### 1. Plan Mode with Editing

**What It Is**: Claude shows you a plan of changes before making them. You can review, edit, and approve.

**How It Works**:

```
You: "Add user authentication"

Claude generates plan:
┌─────────────────────────────────────────┐
│ Plan Preview                            │
├─────────────────────────────────────────┤
│ Files to modify:                        │
│   ✏️ src/middleware/auth.js (new file)  │
│   ✏️ src/routes/users.js               │
│   ✏️ CLAUDE.md                          │
│                                         │
│ Changes summary:                        │
│ 1. Create JWT auth middleware           │
│ 2. Add authentication to user routes    │
│ 3. Update project documentation         │
│                                         │
│ [Edit Plan] [Accept All] [Reject]       │
└─────────────────────────────────────────┘
```

**Editing Plans**:

```
Click [Edit Plan]

You can modify:
1. ✅ src/middleware/auth.js  ← Keep this
2. ✅ src/routes/users.js     ← Keep this
3. ❌ CLAUDE.md               ← Remove (I'll update manually)

Add instruction:
"Use bcrypt for password hashing, not plain text"

[Apply Edits]

Claude implements with your modifications
```

**Pro Tips**:
- Use Plan Mode for large refactorings
- Edit plans to remove changes you want to do manually
- Add constraints in edit (e.g., "don't touch tests")
- Great for learning (see approach before execution)

---

### 2. Auto-Accept Mode

**What It Is**: Automatically apply Claude's changes without manual approval.

**When to Use**:
- ✅ Small, safe changes (formatting, docs)
- ✅ Trusted patterns (you've reviewed similar changes)
- ✅ Rapid prototyping (exploring ideas)

**When NOT to Use**:
- ❌ Production code
- ❌ Security-sensitive changes
- ❌ Large refactorings
- ❌ Unfamiliar patterns

**Toggle**:

```
Click toggle in header: [Auto-Accept: OFF]
                         [Auto-Accept: ON]  ← Changes apply immediately

Or keyboard: Ctrl+Shift+A (Cmd+Shift+A on Mac)
```

**Example Workflow**:

```bash
# Enable auto-accept for rapid prototyping
You: "Create 5 React component examples"
# Components created instantly

You: "Add PropTypes to all"
# PropTypes added instantly

You: "Now add CSS modules"
# Styles added instantly

# Disable before production work
[Auto-Accept: OFF]

You: "Add authentication to the app"
# Shows plan first, requires approval
```

---

### 3. Visual File Picker & @-Mentions

**Two Ways to Add Files to Context**:

**Method 1: @-Mentions (Like CLI)**

```
You: "Review @src/auth.js for security issues"

Auto-completion shows:
  @src/auth.js
  @src/auth.test.js
  @src/auth-middleware.js

Select with arrow keys or click
```

**Method 2: GUI File Picker**

```
Click 📎 icon in input area

File picker opens:
┌─────────────────────────────────────┐
│ Select Files                        │
├─────────────────────────────────────┤
│ 📁 src/                             │
│   📁 components/                    │
│   📁 services/                      │
│     ☑️ auth.js          ← Selected  │
│     ☐ user.js                       │
│     ☐ payment.js                    │
│   📄 app.js                         │
│ 📄 CLAUDE.md                        │
│ 📄 package.json                     │
├─────────────────────────────────────┤
│ [Select All] [Clear] [Done]         │
└─────────────────────────────────────┘
```

**Adding Images** (for UI work):

```
Method 1: Copy-paste image directly into chat
Method 2: Drag & drop image file into chat
Method 3: @-mention image file: "@design/mockup.png"
```

**Context Panel**:

```
Shows all files in current context:

📝 Files in Context (4)
  • src/services/auth.js         [Remove]
  • src/routes/users.js          [Remove]
  • tests/auth.test.js           [Remove]
  • CLAUDE.md                    [Remove]

Click [Remove] to remove from context
Click [Clear All] to start fresh
```

---

### 4. Conversation History & Sessions

**Multiple Sessions**:

```
📂 Sessions
  → Current Session          ← Active
  → Feature/auth-refactor
  → Bug/payment-issue
  → Refactor/user-service
  → [+ New Session]
```

**Session Management**:

```bash
# Create named session
Right-click → "Rename Session"
Name: "Feature/add-roles"

# Benefits:
- Organize by feature/bug/refactor
- Switch contexts without losing work
- Resume old conversations
- Team collaboration (shared session names)
```

**Searching History**:

```
Ctrl+F (Cmd+F) in Claude Code panel

Search: "authentication"

Results:
  📅 Dec 19 - Feature/auth-refactor
     "Add JWT authentication middleware"
  
  📅 Dec 18 - Bug/auth-token
     "Fix authentication token expiration"
  
  📅 Dec 17 - Current Session
     "How does authentication work?"

Click to jump to conversation
```

**Exporting Conversations**:

```
Right-click session → "Export"

Options:
- Markdown (text + code)
- JSON (full data)
- HTML (readable format)

Use cases:
- Documentation
- Team sharing
- Troubleshooting
- Training
```

---

### 5. Visual Diff & Code Review

**Side-by-Side Diffs**:

```
When Claude proposes changes:

┌─────────────────────────┬─────────────────────────┐
│ Before                  │ After                   │
├─────────────────────────┼─────────────────────────┤
│ function login(user) {  │ async function login(   │
│   // Old callback style │   user) {               │
│   db.query(            │   // Modern async/await │
│     'SELECT...',       │   const result = await  │
│     (err, result) => { │     db.query(           │
│       if (err) {       │       'SELECT...'       │
│         throw err;     │     );                  │
│       }                │   if (!result) {        │
│       return result;   │     throw new Error(... │
│     }                  │   }                     │
│   );                   │   return result;        │
│ }                      │ }                       │
└─────────────────────────┴─────────────────────────┘

Color coding:
  🔴 Red: Removed lines
  🟢 Green: Added lines
  🟡 Yellow: Modified lines

[Accept Change] [Reject Change] [Edit]
```

**File-by-File Review**:

```
Claude proposes changes to 5 files

Review queue:
  1. ✅ src/auth.js (accepted)
  2. ✅ src/routes.js (accepted)
  3. → src/middleware.js (reviewing)
  4. ⏸️ src/utils.js (pending)
  5. ⏸️ tests/auth.test.js (pending)

Actions per file:
- [Accept] - Apply this file's changes
- [Reject] - Skip this file
- [Edit] - Modify before applying
- [Skip All Remaining]
```

---

### 6. Inline Chat (Quick Questions)

**What It Is**: Ask questions without opening full panel.

**How to Use**:

```
In any file, select code:

function calculateTotal(items) {
  return items.reduce((sum, item) => {
    return sum + item.price * item.quantity;
  }, 0);
}

Right-click → "Ask Claude" or Ctrl+K

Inline popup appears:
┌─────────────────────────────────────┐
│ Ask about selected code:            │
│                                     │
│ > What does this function do?       │
│                                     │
│ Claude: This calculates total price │
│ by summing price × quantity for all │
│ items in the array.                 │
│                                     │
│ [More Context] [Open Full Panel]    │
└─────────────────────────────────────┘
```

**Common Inline Queries**:

```javascript
// Select code, then:

"Explain this"
// Quick explanation without context switching

"Find bugs"
// Spot issues in selection

"Optimize this"
// Suggests improvements

"Add tests"
// Generates tests for selected code

"Convert to TypeScript"
// Type annotations

"Document this"
// JSDoc/docstring
```

---

## Workflows: VS Code-Specific

### Workflow 1: Screenshot to Code

**Scenario**: Convert design mockup to React component

```
1. Take screenshot of design (or have Figma export)

2. In Claude Code:
   Drag & drop screenshot

3. Prompt:
   "Convert this design to React component:
   - Use Tailwind CSS
   - Make it responsive
   - Match design exactly
   - Export as functional component"

4. Claude generates:
   ```jsx
   export const Header = () => {
     return (
       <header className="bg-blue-600 text-white">
         {/* ... matches your design ... */}
       </header>
     );
   };
   ```

5. Review in diff view
   [Accept] → File created

6. Preview in browser
   Looks good? Done!
   Need tweaks? "Make the header sticky and add shadow"
```

**Pro Tips**:
- Include multiple screenshots for responsive breakpoints
- Specify component library (Tailwind, Material-UI, etc.)
- Ask for accessibility features
- Request specific naming conventions

---

### Workflow 2: Error Click-to-Fix

**Scenario**: VS Code shows error in Problems panel

```
Problems panel shows:
  ❌ src/auth.js:45
     Cannot read property 'id' of undefined

1. Click error in Problems panel
   (Opens file, cursor at line 45)

2. Select problematic code or function

3. Right-click → "Ask Claude" or Ctrl+K

4. Prompt auto-filled with error:
   "Fix error: Cannot read property 'id' of undefined
   
   @src/auth.js:45"

5. Claude:
   "The issue is that `user` might be undefined.
   
   Here's the fix:"
   
   ```javascript
   // Before
   const userId = user.id;
   
   // After
   const userId = user?.id ?? null;
   ```

6. [Accept] → Error fixed
   Problems panel updates: ✅ (0 errors)
```

---

### Workflow 3: Multi-File Refactoring with Visual Review

**Scenario**: Rename UserService to UserRepository across codebase

```
1. Start session:
   "I need to rename UserService to UserRepository
   across the entire codebase.
   
   Requirements:
   - Update class name
   - Update imports
   - Update variable names
   - Update tests
   - Update docs
   
   @src/ @tests/"

2. Claude shows plan:
   Files to modify: (12 files)
     • src/services/UserService.js → UserRepository.js
     • src/routes/users.js (imports)
     • src/controllers/UserController.js (imports)
     • tests/UserService.test.js → UserRepository.test.js
     ... (8 more)

3. Review each file in diff view:
   
   File 1/12: src/services/UserService.js
   ┌─────────────────────┬─────────────────────┐
   │ Before              │ After               │
   ├─────────────────────┼─────────────────────┤
   │ export class User   │ export class User   │
   │   Service {         │   Repository {      │
   │   constructor() {   │   constructor() {   │
   │     ...             │     ...             │
   │   }                 │   }                 │
   └─────────────────────┴─────────────────────┘
   
   [Accept] [Reject] [Edit]

4. Accept all after review

5. Verify:
   - Run tests: npm test
   - Check build: npm run build
   - Search for missed occurrences: Ctrl+Shift+F "UserService"

6. Commit:
   git add .
   git commit -m "refactor: rename UserService to UserRepository"
```

---

### Workflow 4: Git Integration

**Scenario**: Review changes before committing

```
1. Make changes (with or without Claude)

2. Open Source Control panel (Ctrl+Shift+G)
   Shows: 5 files changed

3. In Claude Code:
   "Review my staged changes for:
   - Code quality issues
   - Missing error handling
   - Test coverage gaps
   - Security vulnerabilities
   
   @git:staged"

4. Claude reviews and reports:
   
   ✅ src/auth.js: Good error handling
   ⚠️ src/routes.js: Missing input validation on line 23
   ❌ src/payment.js: API key hardcoded on line 45
   ⚠️ Tests: No tests for new payment method

5. Fix issues before committing

6. Generate commit message:
   "Generate conventional commit message for these changes"
   
   Claude:
   ```
   feat(payment): add Stripe integration
   
   - Add Stripe payment processor
   - Create payment routes
   - Add payment validation
   - Update environment config
   
   BREAKING CHANGE: Old payment method deprecated
   ```

7. Copy and commit:
   git commit -F commit_message.txt
```

---

## Configuration & Settings

### VS Code settings.json

```json
{
  // === Authentication ===
  "claudeCode.provider": "anthropic",  // or "bedrock", "vertex"
  "claudeCode.apiKey": "${env:ANTHROPIC_API_KEY}",  // Use env var
  
  // === Model Selection ===
  "claudeCode.model": "claude-sonnet-4-5",  // Default model
  "claudeCode.allowModelSwitch": true,  // Allow changing models
  
  // === Thinking Budget ===
  "claudeCode.extendedThinking": {
    "enabled": true,
    "defaultBudget": 5000,  // Tokens
    "maxBudget": 32000
  },
  
  // === Auto-Accept ===
  "claudeCode.autoAccept": {
    "enabled": false,  // OFF by default for safety
    "confirmLargeChanges": true,  // Confirm if >100 lines
    "excludePatterns": [
      "*.env",  // Never auto-accept env files
      "*.config.js",  // Require review for configs
      "**/prod/**"  // Never auto-accept production code
    ]
  },
  
  // === Context ===
  "claudeCode.context": {
    "autoIncludeCLAUDEmd": true,  // Always include CLAUDE.md
    "maxFiles": 50,  // Max files in context
    "respectGitignore": true
  },
  
  // === UI Preferences ===
  "claudeCode.ui": {
    "showPlanByDefault": true,  // Always show plans
    "diffViewMode": "sideBySide",  // or "inline"
    "syntaxHighlighting": true,
    "lineNumbers": true
  },
  
  // === Conversation History ===
  "claudeCode.history": {
    "enabled": true,
    "maxConversations": 100,
    "searchEnabled": true,
    "exportFormat": "markdown"
  },
  
  // === Performance ===
  "claudeCode.performance": {
    "streamResponses": true,  // Show responses as they generate
    "debounceMs": 300,  // Delay before sending request
    "maxConcurrentSessions": 5
  },
  
  // === Workspace ===
  "claudeCode.workspace": {
    "perWorkspaceSettings": true,  // Workspace-specific configs
    "sharedSessions": false  // Don't share sessions between workspaces
  }
}
```

### Workspace-Specific Config

```json
// .vscode/settings.json (in your project)
{
  "claudeCode.model": "claude-haiku-4-5",  // Fast model for this project
  "claudeCode.context": {
    "autoIncludeFiles": [
      "CLAUDE.md",
      "package.json",
      "tsconfig.json"
    ]
  },
  "claudeCode.autoAccept": {
    "enabled": false  // Safety for this critical project
  }
}
```

---

## Advanced Features

### Multi-Workspace Projects

**Scenario**: Working on microservices monorepo

```
Workspace folders:
- /frontend (React app)
- /backend (Node.js API)
- /shared (Common types)

VS Code shows all three

Claude Code:
1. Create session per workspace:
   - "Frontend: Add user profile UI"
   - "Backend: Add profile API"
   - "Shared: Add profile types"

2. Switch between sessions:
   Click session dropdown → Select workspace session

3. Cross-workspace queries:
   "How does frontend call backend profile API?
   
   @frontend/src/api/user.ts
   @backend/src/routes/profile.js"
```

---

### Custom Slash Commands

**Built-in Commands**:

```
/help              # Show all commands
/clear             # Clear conversation (keep code)
/reset             # Reset conversation + code
/context           # Show files in context
/cost              # Show token usage and cost
/model sonnet      # Switch to Sonnet
/model haiku       # Switch to Haiku
/thinking 10000    # Set thinking budget
/export            # Export conversation
```

**Creating Custom Commands**:

```bash
# .vscode/claude-commands.json
{
  "commands": [
    {
      "name": "review-pr",
      "description": "Review current branch vs main",
      "prompt": "Review changes in current branch compared to main. Focus on: code quality, bugs, security, performance. @git:diff-main"
    },
    {
      "name": "test-all",
      "description": "Generate comprehensive tests",
      "prompt": "Generate tests for @${file}. Include: unit tests, edge cases, error cases. Use existing test patterns from @tests/"
    },
    {
      "name": "doc-api",
      "description": "Generate API documentation",
      "prompt": "Generate OpenAPI/Swagger documentation for @${file}. Include: endpoints, parameters, responses, examples."
    }
  ]
}
```

**Usage**:

```
In Claude Code panel:

/review-pr
# Executes custom command

/test-all
# Prompts: "Which file?" → Select → Generates tests

/doc-api
# Generates API docs for current file
```

---

### Team Collaboration

**Shared Configuration**:

```bash
# .vscode/claude-team.json (commit to repo)
{
  "model": "claude-sonnet-4-5",
  "extendedThinking": {
    "enabled": true,
    "defaultBudget": 5000
  },
  "autoIncludeFiles": [
    "CLAUDE.md",
    "ARCHITECTURE.md",
    "CONVENTIONS.md"
  ],
  "commands": [
    // Team custom commands
  ]
}
```

**Sharing Sessions** (for pair programming):

```
1. Export session:
   Right-click session → "Export as Shareable Link"

2. Share link with teammate

3. Teammate:
   Claude Code → "Import Session" → Paste link

4. Both see same conversation
   Changes sync in real-time
```

---

## Troubleshooting

### Common Issues

#### Issue: Extension Not Connecting

```
Symptom: "Could not connect to Claude API"

Fixes:
1. Check API key:
   Settings → Search "claudeCode.apiKey"
   
2. Verify environment:
   Terminal: echo $ANTHROPIC_API_KEY
   
3. Check network:
   Can you access api.anthropic.com?
   Corporate firewall blocking?
   
4. Try different provider:
   Settings → claudeCode.provider → "bedrock" or "vertex"
```

#### Issue: Slow Responses

```
Symptom: Taking 30+ seconds for responses

Fixes:
1. Reduce context:
   Remove unnecessary files from context
   
2. Lower thinking budget:
   /thinking 2000  (instead of 10000)
   
3. Switch to faster model:
   /model haiku
   
4. Check streaming:
   Settings → claudeCode.performance.streamResponses: true
```

#### Issue: Changes Not Applying

```
Symptom: Accept button doesn't work

Fixes:
1. Check file permissions:
   Is file read-only?
   
2. Check git status:
   Is file in gitignore?
   Uncommitted changes conflict?
   
3. Reload window:
   Ctrl+Shift+P → "Reload Window"
   
4. Check extension version:
   Extensions → Claude Code → Update if available
```

#### Issue: Context Limit Exceeded

```
Symptom: "Context window exceeded"

Fixes:
1. Remove files from context:
   Click [Remove] on files you don't need
   
2. Use more targeted @-mentions:
   Instead of @src/
   Use @src/specific-file.js
   
3. Split into multiple sessions:
   One session per feature/component
   
4. Use /clear to reset:
   Keeps files but clears conversation history
```

---

## Tips & Best Practices

### Do's ✅

1. **Use Plan Mode for Important Changes**
   ```
   Settings → claudeCode.ui.showPlanByDefault: true
   ```

2. **Name Your Sessions**
   ```
   "Feature/user-roles" (not "Session 1")
   "Bug/payment-timeout" (not "Session 2")
   ```

3. **Review Diffs Before Accepting**
   ```
   Even small changes deserve a quick review
   Claude is smart but not perfect
   ```

4. **Keep CLAUDE.md Updated**
   ```
   When you accept new patterns
   Update CLAUDE.md for future sessions
   ```

5. **Use Keyboard Shortcuts**
   ```
   Faster than clicking
   Learn the top 5: Ctrl+Shift+C, Ctrl+Enter, Esc, Ctrl+K, @
   ```

### Don'ts ❌

1. **Don't Enable Auto-Accept for Production Code**
   ```
   Always review production changes
   One mistake could break prod
   ```

2. **Don't Overload Context**
   ```
   50+ files = slow responses
   Target specific files instead
   ```

3. **Don't Ignore Warnings**
   ```
   "Large change (500+ lines)" → Review extra carefully
   "Modifying critical file" → Double-check
   ```

4. **Don't Skip Tests**
   ```
   Just because Claude generated doesn't mean it works
   Run tests after accepting
   ```

---

## Comparison: CLI vs Extension

### When to Use Each

| Scenario | Best Tool | Why |
|----------|-----------|-----|
| **Feature development** | Extension | Visual diffs, plan editing |
| **Quick fixes** | Extension | Inline chat, fast |
| **Code review** | Extension | Side-by-side diffs |
| **Learning codebase** | Extension | GUI navigation |
| **UI development** | Extension | Screenshot-to-code |
| **Pair programming** | Extension | Screen sharing friendly |
| | | |
| **Automation** | CLI | Scriptable |
| **Git hooks** | CLI | Pre-commit, pre-push |
| **CI/CD** | CLI | Pipeline integration |
| **Piping workflows** | CLI | Unix composition |
| **SSH/Remote** | CLI | No GUI needed |
| **Batch operations** | CLI | Script multiple commands |

### Hybrid Workflow

```bash
# Morning: Use Extension for feature work
VS Code → Claude Code panel
"Add user profile page"
Review diffs visually → Accept

# Afternoon: Use CLI for automation
Terminal:
git diff | claude "Review for bugs"
npm test | claude "Analyze failures"

# Pre-commit: CLI hook
.git/hooks/pre-commit:
claude "Review staged changes" --quick

# CI/CD: CLI in pipeline
.github/workflows/pr-review.yml:
- run: claude code-review --comment
```

---

## Next Steps

- **Try Interactive Features**: [Section 4c: Interactive Features](04c-interactive-features)
- **Learn Prompting Patterns**: [Part 5: Prompt Engineering](../05-prompt-context-mastery)
- **Set Up CLAUDE.md**: [Section 2b: CLAUDE.md Guide](../01-fundamentals-core-concepts/02b-claude-md-guide)

---

[← Back: Terminal Workflows](04-terminal-workflows) | [Next: Interactive Features →](04c-interactive-features)


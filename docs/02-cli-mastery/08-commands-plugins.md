# Section 8: Commands & Plugins System

Claude Code includes a powerful extensibility system through custom commands and plugins. This allows you to create reusable workflows, add project-specific commands, and extend Claude's capabilities.

---

## Overview

| Feature | What It Is | Use Case |
|---------|------------|----------|
| **Custom Commands** | Reusable prompts with `/command-name` | Project-specific workflows |
| **Plugins** | Packaged functionality | Complex features, shareable tools |
| **Skills** | Dynamic knowledge loading | Domain expertise on-demand |

---

## Custom Commands

### What Are Custom Commands?

Commands are **saved prompts** you can invoke with `/command-name`. They're perfect for repetitive tasks specific to your project.

**Without Custom Commands**:
```bash
# Every time you want a security review:
claude "Review @src/auth.js for security issues:
- SQL injection
- XSS
- Authentication bypass
- Secrets in code
Report severity + location + fix"

# Type this every single time... tedious!
```

**With Custom Commands**:
```bash
claude
> /security-review src/auth.js
# Runs your predefined security review prompt
```

---

### Creating Custom Commands

Commands are markdown files in `.claude/commands/` directory.

**Basic Command Structure**:
```markdown
---
description: Brief description of what this command does
argument-hint: [arg1] [arg2]
---

Your prompt template goes here.
Use $1, $2, etc. for arguments.
Use $ARGUMENTS for all arguments.
```

---

### Example 1: Security Review Command

**Create**: `.claude/commands/security-review.md`

```markdown
---
description: Comprehensive security review of file or directory
argument-hint: [file-or-directory]
---

# Security Review

Review $1 for security vulnerabilities:

🔴 **Critical**:
- SQL injection
- XSS vulnerabilities
- Authentication bypass
- Authorization issues
- Secrets in code (API keys, passwords)

🟡 **Important**:
- Input validation
- Output encoding
- Error message information leakage
- Logging sensitive data
- Rate limiting missing

For each issue found:
- **Severity**: Critical/High/Medium/Low
- **Location**: file:line
- **Problem**: What's wrong
- **Fix**: Specific code fix
- **Prevention**: How to avoid in future

@CLAUDE.md security standards
```

**Usage**:
```bash
claude
> /security-review src/auth/
# Runs comprehensive security review

> /security-review src/payment.js
# Reviews single file
```

---

### Example 2: Test Generation Command

**Create**: `.claude/commands/generate-tests.md`

```markdown
---
description: Generate comprehensive tests for a file
argument-hint: [source-file]
---

# Test Generation

Generate comprehensive tests for @$1

Test types:
✅ **Unit tests**: All public methods
✅ **Edge cases**: null, undefined, empty, boundary values
✅ **Error cases**: Network failures, DB errors, validation failures
✅ **Integration tests**: Real dependencies (minimal mocks)

Test structure (follow @tests/example.test.js):
```javascript
describe('ClassName', () => {
  describe('methodName', () => {
    it('should ... when ...', () => {
      // Arrange
      // Act
      // Assert
    });
  });
});
```

Coverage target: 90%+

Test framework: Jest
Assertion style: expect()

@CLAUDE.md testing standards
```

**Usage**:
```bash
> /generate-tests src/services/payment.js
# Generates comprehensive tests
```

---

### Example 3: PR Review Command

**Create**: `.claude/commands/review-pr.md`

```markdown
---
description: Review current branch vs main
argument-hint: 
---

# Pull Request Review

Review changes in current branch compared to main:

```bash
git diff main..HEAD
```

Check for:
📋 **Code Quality**:
- Follows patterns in @CLAUDE.md
- Descriptive naming
- Proper error handling
- No commented code
- No debug statements

🔒 **Security**:
- No secrets in code
- Input validation
- No SQL injection risks
- No XSS vulnerabilities

⚡ **Performance**:
- No N+1 queries
- Reasonable complexity
- No obvious bottlenecks

✅ **Testing**:
- Tests included
- Edge cases covered
- Error cases tested

For each issue:
- Category
- Severity
- Location
- Problem
- Suggested fix

@CLAUDE.md code standards
```

**Usage**:
```bash
> /review-pr
# Reviews your current branch
```

---

### Example 4: API Documentation Command

**Create**: `.claude/commands/document-api.md`

```markdown
---
description: Generate OpenAPI documentation for API routes
argument-hint: [routes-file]
---

# API Documentation Generation

Generate OpenAPI 3.0 documentation for @$1

For each endpoint include:
- **Path** and **Method** (GET, POST, etc.)
- **Summary**: One-line description
- **Description**: Detailed explanation
- **Parameters**:
  - Path parameters
  - Query parameters
  - Request body schema
- **Responses**:
  - Success (200, 201, etc.)
  - Error responses (400, 401, 404, 500)
  - Response schemas
- **Security**: Authentication requirements
- **Examples**: Request/response examples

Output format: OpenAPI YAML

Follow pattern: @docs/api/example-api.yaml

@CLAUDE.md API documentation standards
```

**Usage**:
```bash
> /document-api src/routes/users.js
# Generates OpenAPI docs
```

---

### Example 5: Feature Development Command

**Create**: `.claude/commands/start-feature.md`

```markdown
---
description: Start a new feature with proper planning
argument-hint: [feature-name]
---

# Feature Development: $1

I'm starting a new feature: **$1**

## Phase 1: Understanding

First, help me understand the current system:
1. Are there similar features in the codebase?
2. What patterns should I follow?
3. What files will likely need changes?

@CLAUDE.md

## Phase 2: Clarifying Questions

Before we start implementation, I need you to ask:
- Requirements clarification
- Edge cases to consider
- Performance implications
- Security considerations
- Testing strategy

## Phase 3: Implementation Plan

Create a detailed, step-by-step plan:
- [ ] Database changes (if needed)
- [ ] Model/data layer
- [ ] Business logic
- [ ] API/interface
- [ ] Tests
- [ ] Documentation

Don't implement yet - just the plan.

@CLAUDE.md
```

**Usage**:
```bash
> /start-feature user-notifications
# Starts feature with proper planning
```

---

### Command Best Practices

#### ✅ Do's

1. **Be Specific**
   ```markdown
   # Good
   Review $1 for SQL injection using parameterized query patterns from @CLAUDE.md
   
   # Bad
   Check $1
   ```

2. **Include Context**
   ```markdown
   Always reference:
   @CLAUDE.md
   @relevant-pattern-files
   ```

3. **Structured Output**
   ```markdown
   For each issue:
   - Severity
   - Location
   - Problem
   - Fix
   ```

4. **Use Arguments**
   ```markdown
   $1 = first argument
   $2 = second argument
   $ARGUMENTS = all arguments
   ```

#### ❌ Don'ts

1. **Don't Make Commands Too Generic**
   ```markdown
   # Bad - too generic
   Do something with $1
   
   # Good - specific to your project
   Generate REST API endpoint for $1 following @CLAUDE.md patterns
   ```

2. **Don't Forget @CLAUDE.md**
   ```markdown
   # Always include project context
   @CLAUDE.md
   ```

---

## Plugins

### What Are Plugins?

Plugins are **packaged collections** of commands, skills, and functionality. Think of them as "apps" for Claude Code.

**Official Plugins**:
- `@anthropic/code-review` - Multi-agent code review
- `@anthropic/test-generator` - Smart test generation
- `@anthropic/security-scanner` - Security analysis

**Community Plugins**:
- `@community/prettier-formatter` - Code formatting
- `@community/git-helper` - Git workflows
- `@community/db-schema-gen` - Database schema generation

---

### Installing Plugins

```bash
# CLI
claude plugin install @anthropic/code-review
claude plugin list
claude plugin enable code-review
claude plugin disable code-review
claude plugin uninstall code-review

# VS Code Extension
Settings → Extensions → Claude Code → Plugins
```

---

### Using Official Plugins

#### Plugin 1: Code Review

**Install**:
```bash
claude plugin install @anthropic/code-review
```

**Usage**:
```bash
# In CLI
claude
> /code-review

# Or with comment flag for PR
> /code-review --comment

# What it does:
# - Launches 4 review agents in parallel
# - Each reviews from different perspective:
#   - Security agent
#   - Performance agent
#   - Code quality agent
#   - Test coverage agent
# - Scores issues for confidence
# - Reports high-confidence issues (>80%)
# - Posts as PR comment (if --comment flag)
```

**Example Output**:
```markdown
## Code Review Results

### 🔴 Security Issues (2)

**High Confidence (95%)**: SQL Injection Risk
- **File**: src/routes/users.js:45
- **Problem**: Raw SQL query with user input
- **Fix**: Use parameterized query
```javascript
// Before
const query = `SELECT * FROM users WHERE id = ${req.params.id}`;

// After
const query = 'SELECT * FROM users WHERE id = ?';
const result = await db.query(query, [req.params.id]);
```

### ⚡ Performance Issues (1)

**High Confidence (88%)**: N+1 Query
- **File**: src/services/order-service.js:67
- **Problem**: Loading user for each order in loop
- **Fix**: Use JOIN or batch loading
...
```

---

#### Plugin 2: Test Generator

**Install**:
```bash
claude plugin install @anthropic/test-generator
```

**Usage**:
```bash
> /generate-tests src/services/payment.js --coverage=100

# Generates:
# - Unit tests for all methods
# - Edge case tests
# - Error case tests
# - Integration tests
# - Mocks for external dependencies
# - Achieves target coverage
```

---

#### Plugin 3: Security Scanner

**Install**:
```bash
claude plugin install @anthropic/security-scanner
```

**Usage**:
```bash
> /security-scan src/

# Scans for:
# - OWASP Top 10
# - Dependency vulnerabilities
# - Secrets in code
# - Insecure configurations
# - Missing security headers
```

---

### Creating Custom Plugins

Plugins are structured Node.js packages.

**Plugin Structure**:
```
my-plugin/
├── package.json
├── index.js               # Plugin entry point
├── commands/
│   ├── command1.md
│   └── command2.md
├── skills/                # Optional
│   └── domain-knowledge.md
└── README.md
```

**Example: Simple Plugin**

**package.json**:
```json
{
  "name": "@myteam/api-generator",
  "version": "1.0.0",
  "description": "Generate REST APIs following our patterns",
  "main": "index.js",
  "claudeCode": {
    "commands": ["commands/*.md"],
    "skills": ["skills/*.md"]
  },
  "keywords": ["claude-code", "api", "generator"]
}
```

**index.js**:
```javascript
module.exports = {
  name: 'API Generator',
  description: 'Generate REST APIs following company patterns',
  
  // Optional: Plugin initialization
  async init(claudeCode) {
    console.log('API Generator plugin loaded');
  },
  
  // Optional: Custom logic
  async beforeCommand(command, args) {
    // Run before any command
  },
  
  async afterCommand(command, result) {
    // Run after any command
  }
};
```

**commands/generate-endpoint.md**:
```markdown
---
description: Generate REST API endpoint
argument-hint: [resource-name]
---

Generate CRUD API endpoints for: $1

Follow our company patterns:
@company-patterns/rest-api-template.js

Include:
- Routes (GET, POST, PUT, DELETE)
- Controller
- Service
- Repository
- Validation schemas
- Tests
- API documentation

@CLAUDE.md
```

**Using Custom Plugin**:
```bash
# Install locally
cd my-plugin
npm link

# Install in project
cd ~/my-project
npm link @myteam/api-generator

# Use
claude
> /generate-endpoint products
```

---

### Publishing Plugins

**To npm** (for community):
```bash
npm publish
```

**To Private Registry** (for company):
```bash
npm publish --registry=https://npm.company.com
```

**To GitHub** (for sharing):
```bash
# package.json
{
  "name": "@myteam/plugin",
  "repository": "github:myteam/claude-code-plugin"
}

# Install from GitHub
claude plugin install github:myteam/claude-code-plugin
```

---

## Skills

### What Are Skills?

Skills are **just-in-time knowledge** Claude loads when needed. They provide domain expertise without bloating context.

**Official Skills**:
- `rust-expert` - Rust programming expertise
- `react-patterns` - React best practices
- `aws-infrastructure` - AWS services knowledge
- `security-best-practices` - Security expertise

---

### Using Skills

```bash
# Load skill
claude
> /skill load rust-expert

# Now Claude has Rust expertise

> Explain ownership in Rust
# Claude uses rust-expert skill for detailed answer

> Show me async/await patterns in Rust
# Still using rust-expert knowledge

# Unload skill (free context)
> /skill unload rust-expert
```

---

### Creating Custom Skills

Skills are markdown files with structured knowledge.

**Example**: `.claude/skills/company-api-patterns.md`

```markdown
---
name: Company API Patterns
description: Our internal REST API conventions
tags: [api, rest, company-patterns]
---

# Company API Patterns

## URL Structure
- Always plural: `/api/users` not `/api/user`
- Nested resources: `/api/users/:id/orders`
- No verbs in URLs: `/api/users` not `/api/getUsers`

## Response Format
All responses follow this structure:

```javascript
{
  "success": boolean,
  "data": any,
  "error": {
    "code": string,
    "message": string,
    "details": object
  },
  "meta": {
    "timestamp": string,
    "requestId": string
  }
}
```

## Error Codes
- `VALIDATION_ERROR` - Invalid input
- `NOT_FOUND` - Resource doesn't exist
- `UNAUTHORIZED` - Not logged in
- `FORBIDDEN` - Logged in but no permission
- `INTERNAL_ERROR` - Server error

## Authentication
Use JWT tokens in Authorization header:
```
Authorization: Bearer <token>
```

Token expiry: 24 hours
Refresh strategy: Sliding window

## Rate Limiting
- 100 requests/minute per user
- 1000 requests/minute per IP
- Headers:
  - `X-RateLimit-Limit`
  - `X-RateLimit-Remaining`
  - `X-RateLimit-Reset`

## Pagination
Use query parameters:
- `page` (default: 1)
- `limit` (default: 20, max: 100)

Response includes:
```javascript
{
  "data": [...],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "pages": 8
  }
}
```

## Example Endpoint
```javascript
// GET /api/users?page=1&limit=20
router.get('/users',
  authenticate(),           // Verify JWT
  validateQuery(schema),    // Validate query params
  rateLimit(100),          // Rate limiting
  async (req, res) => {
    const { page = 1, limit = 20 } = req.query;
    const users = await userService.findAll(page, limit);
    res.json({
      success: true,
      data: users.data,
      meta: {
        page,
        limit,
        total: users.total,
        pages: Math.ceil(users.total / limit),
        timestamp: new Date().toISOString(),
        requestId: req.id
      }
    });
  }
);
```
```

**Usage**:
```bash
> /skill load company-api-patterns

> Generate API endpoint for products
# Claude uses company patterns from skill

> What's our error response format?
# Claude references loaded skill
```

---

## Team Collaboration

### Sharing Commands

**Option 1: Commit to Repository**
```bash
# .claude/commands/
# Commit this directory to git
git add .claude/commands/
git commit -m "Add team commands"

# Teammates get commands automatically
git pull
```

**Option 2: Company Plugin**
```bash
# Create company plugin
@company/claude-code-plugin/
  ├── commands/
  │   ├── security-review.md
  │   ├── generate-api.md
  │   └── review-pr.md
  ├── skills/
  │   └── company-patterns.md
  └── package.json

# Publish to private npm
npm publish --registry=https://npm.company.com

# Team installs
claude plugin install @company/claude-code-plugin
```

---

### Template Repository

Create a template repository for new projects:

```bash
company-node-template/
├── .claude/
│   ├── commands/
│   │   ├── security-review.md
│   │   ├── generate-tests.md
│   │   └── review-pr.md
│   └── skills/
│       └── company-patterns.md
├── CLAUDE.md              # Pre-filled with company standards
├── package.json
├── .gitignore
└── ...

# New project
git clone git@github.com:company/node-template.git my-new-project
cd my-new-project
# Already has all company commands + skills!
```

---

## Quick Reference

### Command Cheat Sheet

| Task | Command |
|------|---------|
| **List commands** | `/help` |
| **List plugins** | `claude plugin list` |
| **Install plugin** | `claude plugin install @org/plugin` |
| **Enable plugin** | `claude plugin enable plugin-name` |
| **Load skill** | `/skill load skill-name` |
| **List skills** | `/skill list` |
| **Create command** | Create `.claude/commands/name.md` |

### Command Template

```markdown
---
description: [What it does]
argument-hint: [arg1] [arg2]
---

# Command Name

[Your prompt here]

Use $1, $2 for arguments
Use $ARGUMENTS for all arguments

@CLAUDE.md
@relevant-files
```

---

## Next Steps

- **Learn Prompting**: [Prompt Engineering](../05-prompt-context-mastery/14-prompt-engineering)
- **See Real Workflows**: [Daily Workflows](../01-fundamentals-core-concepts/03b-daily-workflows)
- **Set Up Project**: [CLAUDE.md Guide](../01-fundamentals-core-concepts/02b-claude-md-guide)

---

[← Back: Advanced CLI Patterns](07-advanced-cli-patterns) | [Next: Part 3 API & Agents →](../03-advanced-api-agent-development)


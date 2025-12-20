---
title: "Section 4: Core Workflows"
parent: "Part 1: Fundamentals & Core Concepts"
nav_order: 4
---

# Section 4: Core Workflows

Essential development patterns for daily work with Claude Code. These workflows are applicable whether you're using CLI, API, or Agent SDK.

---

## 3.1 The 7-Phase Feature Development Workflow

Claude Code's systematic approach to building features ensures quality and maintainability.

```mermaid
graph TD
    Start[Feature Request] --> Phase1[Phase 1:<br/>Codebase Exploration]
    Phase1 --> Phase2[Phase 2:<br/>Requirements Clarification]
    Phase2 --> Phase3[Phase 3:<br/>Pattern Analysis]
    Phase3 --> Phase4[Phase 4:<br/>Architecture Design]
    Phase4 --> Phase5[Phase 5:<br/>Implementation]
    Phase5 --> Phase6[Phase 6:<br/>Testing]
    Phase6 --> Phase7[Phase 7:<br/>Review & Refinement]
    Phase7 --> Complete[Feature Complete]
```

### Phase 1: Codebase Exploration

**Objective:** Understand existing code patterns before implementing.

**CLI Commands:**
```bash
# Explore related features
claude "Show me how authentication is currently implemented"

# Find similar patterns
claude "Find examples of API endpoints that use pagination"

# Understand architecture
claude "Explain the database layer architecture in this project"
```

**What Claude does:**
- Searches codebase for relevant patterns
- Identifies key files and components
- Maps architectural relationships
- Documents design patterns in use

⚠️ **Anti-Pattern**: Starting implementation without exploring existing patterns  
✅ **Better**: Always run Phase 1 exploration before coding new features  
💡 **Why**: Your codebase already has established patterns. Following existing conventions ensures consistency and reduces technical debt. Building without exploration leads to inconsistent code styles.

### Phase 2: Requirements Clarification

**Objective:** Identify ambiguities and edge cases before coding.

**Example Interaction:**
```bash
claude "I need to add user roles (admin, editor, viewer) to the system. \
@CLAUDE.md What questions do you have before we proceed?"
```

**Claude will ask:**
- How should roles be stored? (database table, enum, JSON)
- Role inheritance? (can admin do everything editor can?)
- Dynamic roles or fixed set?
- Role-based UI changes needed?
- Migration strategy for existing users?
- Permission checking: middleware or service layer?

**Best practice:** Answer all questions before proceeding to design.

### Phase 3: Pattern Analysis

**Objective:** Ensure consistency with existing codebase.

```bash
claude "Analyze our current patterns for:
1. How we structure Express routes
2. How we handle database transactions
3. How we write tests for new features
4. Error handling conventions"
```

**Claude extracts:**
- Code organization patterns
- Naming conventions
- Technology stack usage
- Test patterns
- Documentation standards

### Phase 4: Architecture Design

**Objective:** Design multiple implementation approaches with trade-offs.

```bash
claude "Design 3 approaches for implementing user roles:
1. Minimal changes (quick implementation)
2. Clean architecture (best practices)
3. Balanced (pragmatic approach)

For each, provide:
- Files to create/modify
- Database changes needed
- Pros and cons
- Implementation time estimate"
```

**Claude provides:**
- Multiple architectural approaches
- Trade-off analysis
- Clear recommendation
- Implementation roadmap

**Human decides:** Review all options, select best fit.

### Phase 5: Implementation

**Objective:** Build the feature following approved architecture.

```bash
# Begin implementation
claude "Implement the user roles feature using the balanced approach \
we discussed. Start with database migrations."
```

**Claude's process:**
1. Reads all relevant files
2. Follows established patterns
3. Implements incrementally
4. Documents changes
5. Updates as it progresses

**Incremental approach:**
```bash
# Step by step
claude "Create the roles migration file"
claude "Add role column to users table"
claude "Create Role enum type"
claude "Add role check middleware"
claude "Update auth service"
```

### Phase 6: Testing

**Objective:** Ensure feature works correctly.

```bash
claude "Generate comprehensive tests for the roles feature:
- Unit tests for middleware
- Integration tests for API endpoints
- E2E tests for role-based access
Use our existing test patterns from @tests/"
```

**Test generation includes:**
- Unit tests for core logic
- Integration tests for APIs
- Edge case coverage
- Mock external dependencies
- Test data fixtures

### Phase 7: Review & Refinement

**Objective:** Polish and optimize before merging.

```bash
# Code review
claude "Review the roles implementation for:
- Security vulnerabilities
- Performance issues
- Code quality concerns
- Missing edge cases
- Documentation completeness"

# Refinement
claude "Refactor the role check middleware to be more efficient"
```

---

## 3.2 Debugging Workflow

```mermaid
graph LR
    Bug[Bug Report] --> Reproduce[Reproduce<br/>Locally]
    Reproduce --> Analyze[Analyze<br/>Error]
    Analyze --> Diagnose[Diagnose<br/>Root Cause]
    Diagnose --> Fix[Implement<br/>Fix]
    Fix --> Test[Test Fix]
    Test --> Verify[Verify No<br/>Regressions]
```

### Step 1: Reproduce the Bug

```bash
# Provide error details
claude "I'm getting this error:
$(cat error.log)

How can I reproduce this locally?"
```

### Step 2: Analyze the Error

```bash
# Paste full error stack
claude "Analyze this error stack trace:
TypeError: Cannot read property 'id' of undefined
    at UserService.getProfile (src/services/user.js:45)
    at /src/routes/users.js:123
    ...

@src/services/user.js @src/routes/users.js
What's the root cause?"
```

### Step 3: Diagnose Root Cause

Claude analyzes:
- Stack trace
- Relevant code files
- Data flow
- Potential null/undefined issues
- Race conditions
- Edge cases

⚠️ **Anti-Pattern**: Giving Claude only the error message without code context  
✅ **Better**: Include full stack trace + relevant files using `--files` or `@filename`  
💡 **Why**: Claude needs to see the code to understand what went wrong. Just the error message forces Claude to guess, leading to generic advice instead of specific fixes.

### Step 4: Implement Fix

```bash
claude "Fix the bug by adding proper null checking in UserService.getProfile.
Ensure we handle the case where user doesn't exist."
```

### Step 5: Test Fix

```bash
claude "Generate a test that:
1. Reproduces the original bug
2. Verifies the fix works
3. Prevents regression"
```

### Debugging Example: Full Session

```bash
# 1. Report bug
$ claude "Users are getting 500 errors when accessing /api/profile"

# Claude: "Can you share the error logs and the route handler?"

# 2. Provide context
$ cat logs/error.log | claude "Here are the logs. @src/routes/users.js"

# Claude analyzes and finds: "The issue is in getUserProfile - 
# it doesn't handle the case where req.user is undefined"

# 3. Fix
$ claude "Fix the getUserProfile route to handle missing req.user"

# Claude implements fix with proper error handling

# 4. Test
$ claude "Generate test for this fix"

# Claude creates test that reproduces bug and verifies fix

# 5. Verify
$ npm test
# All tests pass ✓
```

---

## 3.3 Code Navigation & Comprehension

### Understanding Unfamiliar Codebases

```bash
# Get overview
claude "Give me a high-level overview of this codebase structure"

# Understand specific feature
claude "How does the authentication system work? 
Trace the flow from login request to JWT generation"

# Find dependencies
claude "What external services does this project depend on?
List APIs, databases, and third-party integrations"
```

⚠️ **Anti-Pattern**: Reading entire large files upfront (`--files="src/**/*.ts"`)  
✅ **Better**: Use progressive disclosure - start with README/package.json, then narrow to specific areas  
💡 **Why**: Loading 100+ files wastes time and tokens. Start broad (overview), then drill down to relevant sections. This is 5-10x faster and uses 90% fewer tokens.

### Tracing Code Flow

```bash
# Entry point to execution
claude "Trace the execution flow for:
POST /api/orders - from request to database"

# Understanding data transformations
claude "Show how user data is transformed from:
Database row → Service layer → API response"
```

### Finding Examples

```bash
# Pattern discovery
claude "Show me 3 examples of how we implement pagination in this codebase"

# Error handling patterns
claude "Find all places where we handle database errors. 
What patterns are most common?"
```

---

## 3.4 Automated Task Execution

### Lint Fixing

```bash
# Auto-fix linting errors
claude "Fix all ESLint errors in src/services/"

# Or pipe lint output
npm run lint 2>&1 | claude "Fix these lint errors"
```

### Merge Conflict Resolution

```bash
# Show conflicts
git diff --name-only --diff-filter=U | claude "Resolve merge conflicts in these files. \
Prefer 'ours' for package.json, 'theirs' for config files"
```

### Release Notes Generation

```bash
# Generate from git log
git log --oneline v1.0.0..HEAD | claude "Generate release notes \
categorized by: Features, Bug Fixes, Breaking Changes, Documentation"
```

### Documentation Updates

```bash
# Update README
claude "Update README.md to reflect the new role-based access control feature. \
Include setup instructions and usage examples"

# API documentation
claude "Generate OpenAPI documentation for all routes in src/routes/users.js"
```

---

## 3.5 Test-Driven Development (TDD)

```mermaid
graph LR
    Write[Write<br/>Failing Test] --> Implement[Implement<br/>Feature]
    Implement --> Pass[Test<br/>Passes]
    Pass --> Refactor[Refactor<br/>Code]
    Refactor --> Write
```

### TDD Workflow with Claude

```bash
# 1. Write test first
claude "Write a test for a function that validates email addresses:
- Should accept valid emails
- Should reject invalid formats
- Should reject emails without @ symbol
- Should reject emails without domain

Use Jest, follow our test patterns in @tests/"

# 2. Implement to pass test
claude "Implement the email validation function to make the tests pass"

# 3. Refactor
claude "Refactor the validation function for better readability 
while keeping tests green"
```

### Example: TDD for API Endpoint

```bash
# Step 1: Test first
$ claude "Write integration test for:
POST /api/users
- Should create user with valid data
- Should return 400 with invalid email
- Should return 409 if email exists
- Should hash password before saving"

# Step 2: Run test (fails)
$ npm test
# ❌ Tests fail (expected)

# Step 3: Implement endpoint
$ claude "Implement POST /api/users endpoint to pass all tests"

# Step 4: Run tests (pass)
$ npm test
# ✓ All tests pass

# Step 5: Refactor
$ claude "Refactor the user creation logic to use a service layer"

# Step 6: Verify tests still pass
$ npm test
# ✓ Tests still pass
```

---

## 3.6 Git Workflow Integration

### Pre-Commit Workflow

```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# Get staged files
STAGED=$(git diff --cached --name-only --diff-filter=ACM)

# Review with Claude
echo "$STAGED" | claude "Review these staged files for:
- Console.log statements (remove for production)
- Commented-out code (remove)
- TODOs without tickets
- Hardcoded values that should be env vars

Exit with error if issues found."
EOF

chmod +x .git/hooks/pre-commit
```

### Commit Message Generation

```bash
# Generate from diff
git diff --cached | claude "Generate a conventional commit message. \
Format: type(scope): description"

# Example output:
# feat(auth): add role-based access control
#
# - Add roles table migration
# - Implement role check middleware  
# - Add role field to User model
# - Update auth tests
```

### Code Review Automation

```bash
# Review PR changes
git diff main...feature-branch | claude "Review these changes:
1. Code quality issues
2. Potential bugs
3. Security concerns
4. Performance implications
5. Test coverage gaps

Provide specific line references."
```

### Branch Strategy Support

```bash
# Generate feature branch
claude "Suggest a branch name for: implementing user profile photo uploads"
# Output: feature/user-profile-photo-upload

# Create branch with context
git checkout -b $(claude "branch name for OAuth2 integration")
```

---

## 3.7 Refactoring Patterns

### Safe Refactoring Process

```mermaid
graph TD
    Start[Refactoring Need] --> Tests{Tests<br/>Exist?}
    Tests -->|No| WriteTests[Write Tests<br/>for Current Behavior]
    Tests -->|Yes| Refactor[Perform<br/>Refactoring]
    WriteTests --> Refactor
    Refactor --> RunTests[Run Tests]
    RunTests --> Pass{All Pass?}
    Pass -->|No| Fix[Fix Issues]
    Fix --> RunTests
    Pass -->|Yes| Complete[Refactoring<br/>Complete]
```

### Refactoring Examples

**Extract Function:**
```bash
claude "Refactor this function by extracting the validation logic into a separate function:
@src/services/user.js:createUser"
```

**Convert Class to Hooks:**
```bash
claude "Convert this React class component to a functional component with hooks:
@src/components/UserProfile.jsx"
```

**Extract Service Layer:**
```bash
claude "Extract business logic from this route handler into a service:
@src/routes/orders.js:createOrder"
```

---

## 3.8 Rapid Prototyping Workflow

### Quick Spike Implementation

```bash
# Spike: Test feasibility quickly
claude "Create a quick prototype of a real-time notification system using WebSockets. \
Include basic server and client. Don't worry about error handling yet."
```

### Throwaway vs. Production Code

**Spike (Throwaway):**
- Quick and dirty
- Test feasibility
- Explore approaches
- No tests needed
- Delete after learning

**Production:**
- Follow patterns
- Full test coverage
- Error handling
- Documentation
- Code review

```bash
# Transition spike to production
claude "Convert this WebSocket spike into production-ready code:
- Add error handling
- Add reconnection logic
- Add tests
- Follow our patterns in @src/services/"
```

---

## 3.9 Workflow Cheat Sheet

| Task | Command Pattern |
|------|-----------------|
| **Start feature** | `claude "I need to implement [feature]. @CLAUDE.md What questions do you have?"` |
| **Debug error** | `cat error.log \| claude "Analyze this error. @relevant-file"` |
| **Write tests** | `claude "Generate tests for @src/file.js following @tests/patterns"` |
| **Refactor code** | `claude "Refactor @src/file.js to [improvement]"` |
| **Review changes** | `git diff \| claude "Review these changes"` |
| **Generate docs** | `claude "Generate API docs for @src/routes/users.js"` |
| **Fix lint** | `npm run lint 2>&1 \| claude "Fix these issues"` |
| **Resolve conflicts** | `git diff --name-only --diff-filter=U \| claude "Resolve merge conflicts"` |
| **Create migration** | `claude "Generate database migration to add [changes]"` |
| **Security review** | `claude "Review @src/ for security vulnerabilities"` |

---

## 3.10 Workflow Best Practices

### ✅ Do's

1. **Provide Context**
   ```bash
   # Good: Include relevant context
   claude "Add validation @src/services/user.js @CLAUDE.md"
   
   # Bad: Vague request without context
   claude "add validation"
   ```

2. **Be Specific**
   ```bash
   # Good: Clear requirements
   claude "Add email validation using regex that checks for @ and domain. \
   Return error message 'Invalid email format' if validation fails"
   
   # Bad: Ambiguous
   claude "validate emails"
   ```

3. **Incremental Changes**
   ```bash
   # Good: Step by step
   claude "1. Add migration for roles table"
   claude "2. Update User model with role field"
   claude "3. Add role check middleware"
   
   # Bad: Everything at once
   claude "Add complete role-based access control to entire app"
   ```

4. **Review Before Accepting**
   - Always review generated code
   - Run tests before committing
   - Check for security issues
   - Verify it follows project patterns

### ❌ Don'ts

1. **Don't Skip Context**
   - Always include CLAUDE.md
   - Reference relevant files
   - Provide error logs
   - Share related patterns

2. **Don't Accept Blindly**
   - Review all changes
   - Understand the code
   - Run tests
   - Check for side effects

3. **Don't Overload Single Request**
   - Break complex tasks into steps
   - One feature at a time
   - Clear separation of concerns

4. **Don't Ignore Errors**
   - Fix linting errors
   - Address test failures
   - Resolve warnings
   - Handle edge cases

---

## Quick Workflow Templates

### New Feature Template

```bash
#!/bin/bash
# new-feature.sh

FEATURE_NAME="$1"

# Phase 1: Exploration
claude "Explore codebase for similar features to: $FEATURE_NAME"

# Phase 2: Clarification
claude "What questions do you have about implementing: $FEATURE_NAME? @CLAUDE.md"

# Phase 3: Design
claude "Design 3 approaches for: $FEATURE_NAME. Provide pros/cons for each."

# Phase 4: Implementation (after human approval)
# claude "Implement $FEATURE_NAME using approved approach"

# Phase 5: Testing
# claude "Generate comprehensive tests for $FEATURE_NAME"

# Phase 6: Review
# claude "Review implementation for quality, security, performance"
```

### Bug Fix Template

```bash
#!/bin/bash
# bugfix.sh

# 1. Reproduce
claude "How to reproduce: $(cat bug-report.txt)"

# 2. Analyze
cat logs/error.log | claude "Analyze this error. @src/relevant-file.js"

# 3. Fix
claude "Fix the identified issue with proper error handling"

# 4. Test
claude "Generate test that reproduces bug and verifies fix"

# 5. Verify
npm test
```

---

[← Back: Environment Setup](02-environment-setup.md) | [Next: Daily Workflows →](05-daily-workflows.md)




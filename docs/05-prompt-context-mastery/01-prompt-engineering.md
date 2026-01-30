---
title: "Section 01: Advanced Prompt Engineering - Practical Patterns"
parent: "Part 5: Prompt Engineering & Context Mastery"
nav_order: 1
---

# Section 01: Advanced Prompt Engineering - Practical Patterns

**Copy-paste ready prompts for real development tasks**

This section provides battle-tested prompt patterns with examples, variations, and best practices from production use.

---

## Table of Contents

**Core Principles**
- [Why Prompting Matters](#why-prompting-matters)
- [The 4 Pillars of Good Prompts](#the-4-pillars-of-good-prompts)

**Pattern Library**
- [Feature Development](#pattern-library-feature-development)
- [Debugging & Performance](#pattern-library-debugging--performance)
- [Code Review](#pattern-library-code-review)
- [Refactoring](#pattern-library-refactoring)
- [Testing](#pattern-library-testing)
- [Documentation](#pattern-library-documentation)
- [Project Setup](#pattern-library-project-setup)

**Advanced Techniques**
- [Chain-of-Thought](#technique-1-chain-of-thought)
- [Role-Based Prompting](#technique-2-role-based-prompting)
- [Few-Shot Examples](#technique-3-few-shot-examples)
- [Constraint-Based Prompting](#technique-4-constraint-based-prompting)

**Quick Reference**
- [Common Mistakes to Avoid](#common-mistakes-to-avoid)
- [Template Cheat Sheet](#template-cheat-sheet)

---

## Why Prompting Matters

**Bad Prompt:**
```
"Make it better"
```
- Vague, no context, no direction
- Claude has to guess

**Good Prompt:**
```
"Refactor @src/auth.js for readability:
- Extract functions (max 20 lines each)
- Add descriptive names
- Add JSDoc comments
- Follow @CLAUDE.md patterns"
```
- Specific, contextual, actionable
- Clear success criteria

**Result:** 10x better output from good prompts

---

## The 4 Pillars of Good Prompts

### 1. Be Specific

```bash
# ❌ Bad
claude "add validation"

# ✅ Good
claude "Add email validation to @src/models/User.js:
- Check format with regex (RFC 5322)
- Check domain exists (DNS lookup)
- Reject disposable providers
- Return specific error messages"
```

### 2. Provide Context

```bash
# ❌ Bad
claude "fix the bug"

# ✅ Good
claude "Fix bug in @src/payment.js line 45:
Error: 'Cannot read property amount of undefined'
When: User clicks pay before entering amount
Expected: Show validation error
Actual: Application crashes

@src/payment.js
@src/validators/payment.js
@error.log"
```

⚠️ **Avoid:** Vague prompts without examples  
✅ **Better:** Include error messages, file context, and 2-3 examples  
💡 **Why:** Context enables targeted fixes, not generic advice

### 3. Specify Constraints

```bash
# ❌ Bad
claude "refactor this code"

# ✅ Good
claude "Refactor @src/legacy.js:
MUST:
- Maintain backward compatibility
- Keep existing API signatures
- Add tests before refactoring
MUST NOT:
- Change database schema
- Modify public methods
- Break existing tests"
```

### 4. Include Examples

```bash
# ❌ Bad
claude "write tests"

# ✅ Good
claude "Write tests for @src/services/user.js
Follow this pattern from @tests/service.test.js:

describe('UserService', () => {
  describe('create', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const userData = { email: 'test@example.com' };
      
      // Act
      const user = await userService.create(userData);
      
      // Assert
      expect(user).toBeDefined();
    });
  });
});

Generate similar tests for all UserService methods."
```

⚠️ **Avoid:** No examples (forces Claude to guess)  
✅ **Better:** Include 2-3 examples of desired style  
💡 **Why:** Few-shot prompting produces consistent results

---

## Pattern Library: Feature Development

### Pattern 1: Feature Request with Planning

**When:** PM gives you a feature, start with clarification

**Template:**
```bash
claude "
I need to implement: [FEATURE_NAME]

Current state:
@relevant-file-1
@relevant-file-2

Requirements:
1. [Requirement 1]
2. [Requirement 2]

Constraints:
- Must work with [SYSTEM]
- Cannot break [FEATURE]
- Performance: [REQUIREMENT]

Questions:
1. What edge cases should I consider?
2. How will this affect [EXISTING_FEATURE]?
3. What tests are needed?
4. Any architectural concerns?

Don't implement yet - ask clarifying questions first.
@CLAUDE.md
"
```

**Example:**
```bash
claude "
I need to implement: Real-time notifications

Current state:
@src/services/notification.js
@src/api/notifications.js

Requirements:
1. Users see notifications without refresh
2. Support 3 types: info, warning, error
3. Persist across sessions
4. Mark as read functionality

Constraints:
- Must work with existing auth
- No external services (no Pusher/Firebase)
- Max 100ms latency
- Support 10K concurrent users

Questions:
1. WebSocket vs Server-Sent Events vs Long polling?
2. How to handle offline users?
3. Database schema?
4. Prevent notification spam?

Don't implement yet - analyze first.
@CLAUDE.md
"
```

---

### Pattern 2: Incremental Development

**When:** Building complex features step-by-step

⚠️ **Avoid:** Building entire feature in one massive prompt  
✅ **Better:** Break into steps (DB → model → service → API → tests)  
💡 **Why:** Catch issues early, easier to review

**Template:**
```bash
# Step 1: Database
claude "Step 1: Database layer for [FEATURE]
Create migration following @migrations/example.sql
Requirements: [LIST]
Show migration, don't apply yet."

# Step 2: Model
claude "Step 2: Data model for [FEATURE]
Follow @src/models/Example.js
Include validation, relationships, methods
@CLAUDE.md"

# Step 3: Service
claude "Step 3: Business logic
Methods: [LIST]
Pattern: @src/services/Example.js"

# Step 4: API
claude "Step 4: API endpoints
Routes: POST/GET/PUT/DELETE /api/[resource]
Pattern: @src/routes/Example.js
Auth required"

# Step 5: Tests
claude "Step 5: Tests
Unit + Integration + Edge cases
Pattern: @tests/example.test.js"
```

---

### Pattern 3: Performance-Critical Features

**Template:**
```bash
claude "
Implement [FEATURE] with performance focus

Requirements:
[LIST]

Performance targets:
- Response time: < [X]ms (p95)
- Throughput: > [X] req/sec
- Memory: < [X]MB per request
- DB queries: Max [X] per request

Consider:
- Caching strategy
- Database indexing
- Query optimization
- Async processing

Show:
1. Implementation approach
2. Performance optimization plan
3. How to measure/verify

@CLAUDE.md
"
```

---

## Pattern Library: Debugging & Performance

### Pattern 4: Error Analysis

⚠️ **Avoid:** "Fix this error" without context  
✅ **Better:** Include full stack trace, recent changes, frequency  
💡 **Why:** Context pinpoints root cause in seconds

**Template:**
```bash
cat error.log | claude "
Error occurred in production:

[STACK TRACE]

Context:
- When: [timestamp/frequency]
- User action: [what they did]
- Expected: [behavior]
- Actual: [behavior]
- Recent changes: [PR/deploy info]

Files:
@file1
@file2

Provide:
- Root cause analysis
- Fix with explanation
- Test to prevent regression
"
```

**Example:**
```bash
tail -n 100 logs/error.log | claude "
TypeError: Cannot read property 'id' of undefined
    at UserService.getProfile (src/services/user.js:45:23)
    at /src/routes/users.js:123:31

Context:
- When: Started 2 hours ago, 50+ occurrences
- User action: Click 'View Profile' after login
- Expected: Show profile
- Actual: 500 error
- Recent: Deployed PR #234 (auth refactor) 3h ago

Files:
@src/services/user.js
@src/routes/users.js
@src/middleware/auth.js

Provide:
- Root cause
- Fix
- Test
- Why didn't tests catch this?
"
```

---

### Pattern 5: Performance Debugging

**Template:**
```bash
claude "
Endpoint [URL] is slow: [X]ms

Profile:
- Database: [X]ms
- Logic: [X]ms
- External API: [X]ms
- Serialization: [X]ms

Expected: < [Y]ms
Actual: [X]ms ([Z]x slower)

Files:
@endpoint
@model
@service

Analyze:
1. Identify bottleneck
2. Suggest optimizations
3. Show optimized code
4. Estimate improvement
5. Trade-offs

Constraints:
[LIST]
"
```

**Example:**
```bash
claude "
/api/users/:id/orders is slow: 2000ms

Profile:
- Database: 1800ms (!!!)
- Logic: 150ms
- Serialization: 50ms

Expected: < 200ms
Actual: 2000ms (10x slower)

Load: 1000 users/min, ~50 orders each
Database: PostgreSQL

@src/routes/users.js:getUserOrders
@src/models/Order.js

Analyze:
1. What's wrong with query?
2. N+1 problem?
3. Missing indexes?
4. Should we paginate?
5. Caching strategy?

Show:
- Current query + why slow
- Optimized query + EXPLAIN
- Index recommendations
- Expected improvement

Cannot change API response format
"
```

---

### Pattern 6: Intermittent Bugs

**Template:**
```bash
claude "
Intermittent: [DESCRIPTION]

Pattern:
- Frequency: [X]%
- Conditions: [WHEN]
- Affected users: [WHO]
- Cannot reproduce locally

Logs:
[PASTE]

Hypothesis:
[YOUR GUESS]

Files:
@file1
@file2

Investigate:
1. Analyze logs for patterns
2. What triggers it?
3. Race condition?
4. Concurrency issue?
5. Environment-specific?

Provide:
- Root cause theory
- How to reproduce
- Fix
- Test strategy
"
```

---

## Pattern Library: Code Review

### Pattern 7: Comprehensive Code Review

**Template:**
```bash
git diff main..branch | claude "
Code review for: [FEATURE]

Check:
🔴 Critical:
- Security (SQL injection, XSS, auth bypass)
- Data integrity
- Breaking changes

🟡 Important:
- Performance (N+1, missing indexes)
- Error handling
- Test coverage
- Code quality (DRY, naming, organization)

🟢 Nice-to-have:
- Documentation
- Comments
- Optimization opportunities

For each issue:
- Severity: Critical/High/Medium/Low
- Location: file:line
- Problem: What's wrong
- Fix: Specific solution
- Why: Explanation

Balance perfect vs pragmatic.
@CLAUDE.md
"
```

Checklist for AI-generated code: [PR Review Guide](../07-reference-troubleshooting/05-pr-review-guide).

**Variations:**

**Security-focused:**
```bash
git diff | claude "Security review:
Focus: SQL injection, XSS, auth, secrets in code
Severity + Location + Fix for each
@CLAUDE.md security standards"
```

**Performance-focused:**
```bash
git diff | claude "Performance review:
Check: N+1 queries, sync I/O, missing indexes
Impact + Location + Fix + Benchmark
@CLAUDE.md performance standards"
```

**Quality-focused:**
```bash
git diff | claude "Code quality review:
Focus: SRP, DRY, naming, errors, tests
Category + Location + Suggestion + Why
@CLAUDE.md conventions"
```

---

## Pattern Library: Refactoring

### Pattern 8: Safe Refactoring

**Template:**
```bash
claude "
Refactor @file for [GOAL]

SAFETY FIRST

Process:
1. Generate tests for CURRENT behavior
   (Don't change anything yet)
   
2. Wait for my approval
   
3. Then refactor:
   [LIST CHANGES]
   
4. Verify tests pass

Goals:
[LIST]

Constraints:
- Maintain backward compatibility
- Keep public API unchanged
- No behavior changes
[OTHER]

@file
@CLAUDE.md
"
```

**Example:**
```bash
claude "
Refactor @src/legacy-auth.js callbacks → async/await

SAFETY FIRST

Process:
1. Generate comprehensive tests FIRST
   - All public functions
   - Edge cases
   - Error cases
   (Don't refactor yet!)
   
2. I'll run tests and approve
   
3. Then refactor:
   - Callbacks → async/await
   - try/catch errors
   - Extract magic numbers
   
4. Verify tests pass

Goals:
- Modern async/await
- Better error handling
- More readable

Constraints:
- EXACT same behavior
- Public API unchanged
- All callers work unchanged

@src/legacy-auth.js
@CLAUDE.md
"
```

---

### Pattern 9: Extract Service Layer

**Template:**
```bash
claude "
Extract business logic from @route to service

Problem:
- Routes contain business logic
- Hard to test
- Code duplication

Target:
@example-route.js (thin controller)
@example-service.js (business logic)

Steps:
1. Analyze route handlers
2. Identify business logic
3. Design service interface
4. Show me plan (don't implement)

Then after approval:
5. Create service
6. Update route
7. Generate tests
8. Verify route tests pass

@route
@CLAUDE.md
"
```

---

## Pattern Library: Testing

### Pattern 10: Comprehensive Tests

**Template:**
```bash
claude "
Generate tests for @src-file

Coverage:
✅ Unit: All public methods
✅ Edge cases: null, undefined, empty, boundaries
✅ Errors: Network fail, DB errors, validation
✅ Integration: Real dependencies
✅ Mocks: External services only

Structure (follow @test-pattern):
describe('Class', () => {
  describe('method', () => {
    it('should ... when ...', () => {
      // Arrange
      // Act
      // Assert
    });
  });
});

Target: 100% coverage

Framework: [Jest/Mocha]
@src-file
@tests/pattern.test.js
@CLAUDE.md
"
```

---

### Pattern 11: Test-Driven Development

**Template:**
```bash
# Step 1: Failing test
claude "Write test FIRST for:

Feature: [DESCRIPTION]
Requirements: [LIST]

Test should:
1. Describe expected behavior
2. Will fail (feature doesn't exist)
3. Cover happy path + edge cases

DON'T implement feature yet.
Pattern: @tests/example.test.js"

# Step 2: Run (should fail)
npm test

# Step 3: Implement
claude "Implement feature to pass test:
@tests/new.test.js
Make ALL tests pass
Minimal implementation
@CLAUDE.md"

# Step 4: Run (should pass)
npm test

# Step 5: Refactor
claude "Tests green! Refactor for:
- Readability
- Performance
- Maintainability
Keep tests passing"
```

---

### Pattern 12: Fix Test Failures

**Template:**
```bash
npm test 2>&1 | claude "
Tests failing:

[OUTPUT]

Analyze:
1. What changed that broke tests?
2. Is code wrong or tests wrong?
3. Testing the right thing?

Then:
- If code wrong: Fix code
- If tests wrong: Fix tests
- If requirements changed: Update both

Show:
- Root cause
- What to fix
- The fix
- Explanation

@src/implementation
@tests/failing.test.js
"
```

---

## Pattern Library: Documentation

### Pattern 13: Inline Documentation

**Template:**
```bash
claude "
Add documentation to @src-file

Style: [JSDoc/docstrings]

Include:
✅ Module/class description
✅ Public methods:
   - Purpose
   - @param (type, description)
   - @returns (type, description)
   - @throws (when, why)
   - @example (usage)
✅ Complex logic (why, not what)
✅ TODOs with tickets
✅ Deprecation warnings

Don't over-document:
❌ Obvious comments
❌ Redundant getters
✅ Focus on WHY and edge cases

@src-file
@CLAUDE.md
"
```

---

### Pattern 14: API Documentation

**Template:**
```bash
claude "
Generate API docs for @routes

Format: OpenAPI 3.0

For each endpoint:
- Path and method
- Description
- Parameters (path/query/body)
- Request schema
- Response schemas (success + errors)
- Examples
- Auth requirements
- Rate limits
- Error codes

Pattern: @docs/api/example.yaml
@routes
@CLAUDE.md
"
```

---

### Pattern 15: Architecture Documentation

**Template:**
```bash
claude "
Architecture docs for [SYSTEM]

Create: docs/architecture/[SYSTEM].md

Include:
1. Overview (1 paragraph)
2. Diagram (Mermaid)
3. Components:
   - Responsibility
   - Key files
   - Dependencies
4. Data flow
5. Design decisions:
   - What we chose
   - Why
   - Trade-offs
6. Security considerations
7. Performance characteristics
8. Error handling
9. Testing approach
10. Future improvements

Analyze:
@src/system/
@CLAUDE.md
"
```

---

## Pattern Library: Project Setup

### Pattern 16: Technology Selection

**Template:**
```bash
claude "
New [PROJECT_TYPE] project

Requirements:
[LIST]

Constraints:
- Team: [X] developers
- Timeline: [X] months
- Budget: [TIER]
- Scale: [USERS/LOAD]

Recommend:
1. Tech stack (with rationale)
2. Project structure
3. Key libraries
4. Dev tools
5. Deployment platform

For each:
- Why vs alternatives
- Pros/cons
- Learning curve
- Community support
- Long-term viability

Compare 2-3 options, recommend best.
"
```

---

### Pattern 17: Project Scaffolding

**Template:**
```bash
claude "
Create project structure for [TYPE]

Tech: [STACK]
Pattern: [MVC/Clean/etc]
Testing: [FRAMEWORK]

Generate:
1. Directory structure
2. Config files:
   - package.json/requirements.txt
   - .gitignore
   - .env.example
   - README.md
   - CLAUDE.md
3. Starter files (skeleton)
4. Setup instructions

Production-ready:
- Linting configured
- Testing configured
- CI/CD ready
- Docker ready (optional)

Pattern: @examples/structure/
"
```

---

## Advanced Techniques

### Technique 1: Chain-of-Thought

**When:** Complex problems need step-by-step reasoning

**Template:**
```bash
claude "
[COMPLEX_PROBLEM]

Think step-by-step:
1. First, analyze [ASPECT 1]
2. Then, consider [ASPECT 2]
3. Next, evaluate [ASPECT 3]
4. Finally, synthesize [SOLUTION]

Show reasoning for each step.
Don't jump to solution.

@file1
@file2
"
```

**Example:**
```bash
claude "
Should we cache user profile API?

Think step-by-step:
1. Analyze current performance:
   - Response time
   - DB load
   - UX
   
2. Consider caching benefits:
   - Performance gain estimate
   - Reduced load
   - Complexity added
   
3. Evaluate challenges:
   - Invalidation strategy
   - Consistency
   - Memory
   
4. Recommend:
   - Yes/No with rationale
   - If yes: Redis vs in-memory vs CDN
   - Implementation approach
   - Rollout strategy

@src/routes/profile.js
@docs/performance.md
"
```

---

### Technique 2: Role-Based Prompting

**When:** Need specific expertise

**Template:**
```bash
claude "
Act as a [ROLE] with expertise in [DOMAIN].

Task: [SPECIFIC_TASK]

From your expert perspective:
- [Question 1]
- [Question 2]

Provide:
- Best practices
- Common pitfalls
- Specific recommendations

@relevant-files
"
```

**Examples:**

```bash
# Security expert
claude "Act as security engineer.
Review this auth implementation.
What vulnerabilities? How to exploit? How to fix?
@src/auth/login.js"

# Performance engineer
claude "Act as performance engineer in Node.js.
Optimize this pipeline.
What are bottlenecks? Memory concerns? Async opportunities?
@src/processors/pipeline.js"

# Database architect
claude "Act as database architect in PostgreSQL.
Design multi-tenant SaaS schema.
Isolation strategy? Performance? Scaling?
@docs/requirements.md"
```

---

### Technique 3: Few-Shot Examples

**When:** Want consistent output format

**Template:**
```bash
claude "
Generate [OUTPUT] following examples:

Example 1:
Input: [INPUT_1]
Output: [OUTPUT_1]

Example 2:
Input: [INPUT_2]
Output: [OUTPUT_2]

Example 3:
Input: [INPUT_3]
Output: [OUTPUT_3]

Now for:
Input: [YOUR_INPUT]
Output: ?
"
```

**Example:**
```bash
claude "
Generate commit messages following examples:

Example 1:
Input: Added login, created auth service, tests
Output:
feat(auth): implement user login

- Create authentication service
- Add JWT generation
- Add login route
- Update auth tests

Example 2:
Input: Fixed password reset bug
Output:
fix(auth): resolve password reset email

- Fix email template
- Add error handling
- Update tests

Now for:
Input: Added RBAC, updated middleware, roles table
Output: ?
"
```

---

### Technique 4: Constraint-Based Prompting

**When:** Need to limit scope or enforce rules

**Template:**
```bash
claude "
[TASK]

MUST do:
- [Required 1]
- [Required 2]

MUST NOT do:
- [Forbidden 1]
- [Forbidden 2]

Within constraints:
[REQUIREMENTS]

@files
"
```

**Example:**
```bash
claude "
Refactor auth system

MUST:
- Keep API endpoints unchanged
- Maintain backward compatibility
- Add comprehensive tests
- Follow error handling pattern

MUST NOT:
- Change database schema
- Modify JWT token format
- Break existing clients
- Remove functionality

Within constraints, refactor to:
- Use async/await
- Extract service layer
- Improve error messages
- Add logging

@src/auth/
@CLAUDE.md
"
```

---

## Common Mistakes to Avoid

Full list and fixes: [Anti-Patterns & Common Mistakes](../07-reference-troubleshooting/04-antipatterns).

### ❌ Mistake 1: Vague Requests
```bash
# Bad
claude "make it better"
claude "fix this"

# Good
claude "Refactor for readability: extract functions, descriptive names, error handling"
claude "Fix null pointer on line 45 when user undefined"
```

### ❌ Mistake 2: No Context
```bash
# Bad
claude "add authentication"

# Good
claude "Add JWT auth to @src/routes/api.js following @src/middleware/auth-example.js. Use httpOnly cookies. @CLAUDE.md"
```

### ❌ Mistake 3: Everything At Once
```bash
# Bad
claude "Build complete e-commerce: users, products, cart, payment, orders, admin"

# Good (incremental)
claude "Step 1: User registration with JWT"
# Wait, then:
claude "Step 2: Product CRUD API"
# Continue step-by-step
```

### ❌ Mistake 4: Ignoring Project Patterns
```bash
# Bad
claude "Add an API endpoint"

# Good
claude "Add POST /api/users following @src/routes/example.js. Include validation, error handling, tests. @CLAUDE.md"
```

### ❌ Mistake 5: No Success Criteria
```bash
# Bad
claude "write tests"

# Good
claude "Generate tests for @src/service.js:
- Unit: All public methods
- Edge cases: null, undefined, empty
- Errors: Network, timeout
- Coverage: 90%+
- Pattern: @tests/example.test.js"
```

---

## Template Cheat Sheet

### Feature Development
```bash
"Implement [FEATURE]
Requirements: [LIST]
Constraints: [LIST]
Following @CLAUDE.md
Ask clarifying questions first"
```

### Debugging
```bash
"Fix error: [ERROR] in @file:line
Context: [WHEN]
Show: root cause, fix, test"
```

### Code Review
```bash
git diff | claude "Review for: security, performance, quality
Report: severity, location, fix
@CLAUDE.md"
```

### Refactoring
```bash
"Refactor @file for [GOAL]
MUST: maintain compatibility
MUST NOT: change public API
Generate tests first"
```

### Testing
```bash
"Generate tests for @file
Unit + edge cases + errors
Coverage: 100%
Pattern: @tests/example.test.js"
```

### Documentation
```bash
"Add JSDoc to @file
Include: descriptions, @param, @returns, @throws, @example
@CLAUDE.md docs style"
```

---

## Next Steps

- **Set Up CLAUDE.md**: [Section 2b: CLAUDE.md Guide](../01-fundamentals-core-concepts/02b-claude-md-guide.md)
- **Optimize Context & Cost**: [Section 02: Optimization Guide](02-optimization-guide.md)
- **Explore Workflows**: [Section 3b: Daily Workflows](../01-fundamentals-core-concepts/03b-daily-workflows.md)

---

[← Back to Part 5](README.md) | [Next: Optimization Guide →](02-optimization-guide.md)


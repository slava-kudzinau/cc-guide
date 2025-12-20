---
title: "Section 14: Advanced Prompt Engineering - Practical Patterns Library"
parent: "Part 5: Prompt Engineering & Context Mastery"
nav_order: 1
---

# Section 14: Advanced Prompt Engineering - Practical Patterns Library

This section provides **copy-paste ready prompts** for real development tasks. Every pattern includes examples, variations, and best practices from Anthropic engineers.

---

## Why Prompting Matters

**Bad Prompt**:
```
"Make it better"
```
- Vague, no context, no direction
- Claude has to guess what you want
- Results vary wildly

**Good Prompt**:
```
"Refactor @src/auth.js for readability:
- Extract functions (max 20 lines each)
- Add descriptive names
- Add JSDoc comments
- Follow @CLAUDE.md patterns"
```
- Specific, contextual, actionable
- Clear success criteria
- Consistent with project patterns

**Result**: 10x better output from good prompts

---

## Core Prompting Principles

### 1. Be Specific

```bash
# ❌ Bad
claude "add validation"

# ✅ Good
claude "Add email validation to @src/models/User.js:
- Check format with regex (RFC 5322)
- Check domain exists (DNS lookup)
- Reject disposable email providers
- Return specific error messages"
```

### 2. Provide Context

```bash
# ❌ Bad
claude "fix the bug"

# ✅ Good
claude "Fix bug in @src/payment.js line 45:
Error: 'Cannot read property amount of undefined'
Happens when: User clicks pay before entering amount
Expected: Show validation error
Actual: Application crashes

@src/payment.js
@src/validators/payment.js
@error.log"
```

⚠️ **Anti-Pattern**: Vague prompts without examples or context  
✅ **Better**: Include error messages, file context, and 2-3 examples of desired output  
💡 **Why**: Claude needs context to give specific answers. "Fix my code" gets generic advice. "Fix this error [paste] in this file [attach]" gets targeted fixes.

### 3. Specify Constraints

```bash
# ❌ Bad
claude "refactor this code"

# ✅ Good
claude "Refactor @src/legacy.js:
Must:
- Maintain backward compatibility
- Keep existing API signatures
- Add tests before refactoring
Must NOT:
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

⚠️ **Anti-Pattern**: No examples in prompts (forces Claude to guess your style)  
✅ **Better**: Include 2-3 examples of desired output format/style  
💡 **Why**: Few-shot prompting (with examples) produces consistent, on-brand results. Without examples, output style varies wildly.

---

## Pattern Library: Feature Development

### Pattern 1: Feature Request with Clarification

**When**: PM gives you a feature request

**Template**:
```bash
claude "
I need to implement: [FEATURE_NAME]

Current state:
@relevant-file-1
@relevant-file-2

Requirements:
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

Constraints:
- Must work with existing [SYSTEM]
- Cannot break [FEATURE]
- Performance: [REQUIREMENT]
- Security: [CONSIDERATION]

Questions for you:
1. What edge cases should I consider?
2. How will this affect [EXISTING_FEATURE]?
3. What tests are needed?
4. Any architectural concerns?

Don't implement yet - ask clarifying questions first.

@CLAUDE.md
"
```

**Real Example**:
```bash
claude "
I need to implement: Real-time notifications

Current state:
@src/services/notification.js
@src/api/notifications.js

Requirements:
1. Users see notifications without page refresh
2. Support 3 types: info, warning, error
3. Notifications persist across sessions
4. Mark as read functionality

Constraints:
- Must work with existing auth system
- Cannot use external services (no Pusher/Firebase)
- Max 100ms latency for delivery
- Support 10,000 concurrent users

Questions for you:
1. WebSocket vs Server-Sent Events vs Long polling?
2. How to handle offline users?
3. Database schema for storing notifications?
4. How to prevent notification spam?

Don't implement yet - ask clarifying questions first.

@CLAUDE.md
"
```

---

### Pattern 2: Incremental Feature Development

**When**: Building feature step-by-step

⚠️ **Anti-Pattern**: Building entire feature in one massive prompt  
✅ **Better**: Break into steps (database → model → service → API → tests) with review between each  
💡 **Why**: Large prompts create large, untested code blocks that are hard to review. Incremental development catches issues early and lets you course-correct.

**Template**:
```bash
# Step 1: Database
claude "
Step 1 of [FEATURE]: Database layer

Create migration for [CHANGES]
Follow our migration pattern: @migrations/example_migration.sql

Requirements:
- [Requirement]
- [Requirement]

Show me the migration, don't apply yet.
"

# Step 2: Model
claude "
Step 2 of [FEATURE]: Data model

Create/update model for [ENTITY]
Follow pattern: @src/models/ExampleModel.js

Include:
- Validation
- Relationships
- Methods

@CLAUDE.md
"

# Step 3: Service
claude "
Step 3 of [FEATURE]: Business logic

Create service with:
- [method1]: [description]
- [method2]: [description]

Pattern: @src/services/ExampleService.js
"

# Step 4: API
claude "
Step 4 of [FEATURE]: API endpoints

Create routes:
- POST /api/[resource]
- GET /api/[resource]/:id
- PUT /api/[resource]/:id
- DELETE /api/[resource]/:id

Pattern: @src/routes/ExampleRoutes.js
Auth: Required for all endpoints
"

# Step 5: Tests
claude "
Step 5 of [FEATURE]: Tests

Generate comprehensive tests:
- Unit: Services and models
- Integration: API endpoints
- Edge cases: Validation, errors

Pattern: @tests/example.test.js
"
```

---

### Pattern 3: Feature with Performance Requirements

**Template**:
```bash
claude "
Implement [FEATURE] with performance focus

Requirements:
[List requirements]

Performance targets:
- Response time: < [X]ms (p95)
- Throughput: > [X] requests/sec
- Memory: < [X]MB per request
- Database queries: Max [X] per request

Optimization strategies to consider:
- Caching (where appropriate)
- Database indexing
- Query optimization
- Async processing (if applicable)

Show me:
1. Implementation approach
2. Performance optimization plan
3. How to measure/verify performance

@CLAUDE.md
@src/config/performance.js
"
```

**Real Example**:
```bash
claude "
Implement product search with performance focus

Requirements:
- Full-text search across name, description, tags
- Filter by category, price range, availability
- Sort by relevance, price, date
- Pagination (50 items per page)

Performance targets:
- Response time: < 100ms (p95)
- Throughput: > 1000 searches/sec
- Database queries: Max 2 per request
- Support 1M+ products

Optimization strategies to consider:
- Elasticsearch vs PostgreSQL full-text
- Redis caching of popular searches
- Database indexing strategy
- Query result caching

Show me:
1. Implementation approach (with tech choices)
2. Caching strategy
3. Index strategy
4. How to measure performance

@CLAUDE.md
@src/models/Product.js
@src/config/database.js
"
```

---

## Pattern Library: Debugging

### Pattern 4: Error Analysis

⚠️ **Anti-Pattern**: Asking "fix this error" without providing the error message or context  
✅ **Better**: Include full stack trace, recent changes, frequency, and what user was doing  
💡 **Why**: "Fix my error" gives generic debugging advice. Full context (error + files + recent changes) pinpoints root cause in seconds.

**Template**:
```bash
cat error.log | claude "
Error occurred in production:

[Paste error stack trace]

Context:
- When: [timestamp/frequency]
- User action: [what they did]
- Expected: [what should happen]
- Actual: [what happened]

Files involved:
@file1
@file2

Questions:
1. What's the root cause?
2. Why is it happening now (recent changes)?
3. How to fix it?
4. How to prevent similar issues?

Provide:
- Root cause analysis
- Fix with explanation
- Test to prevent regression
"
```

**Real Example**:
```bash
tail -n 100 logs/error.log | claude "
Error occurred in production:

TypeError: Cannot read property 'id' of undefined
    at UserService.getProfile (src/services/user.js:45:23)
    at /src/routes/users.js:123:31
    at Layer.handle [as handle_request] (express/lib/router/layer.js:95:5)

Context:
- When: Started 2 hours ago, 50+ occurrences
- User action: Clicking 'View Profile' after login
- Expected: Show user profile page
- Actual: 500 Internal Server Error
- Recent changes: Deployed PR #234 (auth refactor) 3 hours ago

Files involved:
@src/services/user.js
@src/routes/users.js
@src/middleware/auth.js

Questions:
1. What's the root cause?
2. Why related to auth refactor?
3. How to fix it?
4. Why didn't tests catch this?

Provide:
- Root cause analysis
- Fix with explanation
- Test to prevent regression
"
```

---

### Pattern 5: Performance Debugging

**Template**:
```bash
claude "
Endpoint [URL] is slow: [X]ms response time

Performance profile:
- Database query: [X]ms
- Business logic: [X]ms
- External API: [X]ms
- Response serialization: [X]ms

Expected: < [Y]ms
Actual: [X]ms ([Z]x slower)

Context:
@slow-endpoint-file
@database-model
@related-services

Analyze and optimize:
1. Identify bottleneck
2. Suggest optimizations
3. Show optimized code
4. Estimate performance gain
5. Trade-offs (if any)

Constraints:
- Can't change database schema
- Must maintain backward compatibility
- [Other constraints]
"
```

**Real Example**:
```bash
claude "
Endpoint /api/users/:id/orders is slow: 2000ms response time

Performance profile:
- Database query: 1800ms (!!!)
- Business logic: 150ms
- Response serialization: 50ms

Expected: < 200ms
Actual: 2000ms (10x slower)

Load:
- 1000 users/minute hitting this endpoint
- Each user has ~50 orders on average
- Database: PostgreSQL

Context:
@src/routes/users.js:getUserOrders
@src/models/Order.js
@src/models/User.js

Analyze and optimize:
1. What's wrong with the query? (1800ms is way too slow)
2. N+1 query problem?
3. Missing indexes?
4. Should we paginate?
5. Caching strategy?

Show me:
1. Current query (explain what's slow)
2. Optimized query (with EXPLAIN ANALYZE)
3. Index recommendations
4. Caching strategy (if applicable)
5. Expected performance improvement

Constraints:
- Can't change API response format (backward compatibility)
- Can add indexes
- Can add caching
"
```

---

### Pattern 6: Intermittent Bug Investigation

**Template**:
```bash
claude "
Intermittent bug: [DESCRIPTION]

Occurrence pattern:
- Frequency: [X]% of requests
- When: [conditions]
- Users affected: [description]
- Cannot reproduce locally: [Yes/No]

Error logs:
[Paste logs]

Hypothesis:
[Your guess about the cause]

Context:
@file1
@file2
@config

Investigate:
1. Analyze logs for patterns
2. What conditions trigger it?
3. Race condition?
4. Concurrency issue?
5. Environment-specific?

Provide:
- Root cause theory
- How to reproduce reliably
- Fix
- How to test the fix
"
```

---

## Pattern Library: Code Review

### Pattern 7: Security-Focused Review

**Template**:
```bash
git diff main..feature-branch | claude "
Security review for this PR:

Focus areas:
🔴 Critical:
- SQL injection
- XSS vulnerabilities
- Authentication bypass
- Authorization issues
- Secrets in code

🟡 Important:
- Input validation
- Output encoding
- CSRF protection
- Rate limiting
- Logging sensitive data

For each issue found:
- Severity: Critical/High/Medium/Low
- Location: file:line
- Explanation: Why it's a problem
- Fix: Specific code fix
- Prevention: How to avoid in future

@CLAUDE.md security standards
"
```

**Real Example**:
```bash
git diff main..feature/api-search | claude "
Security review for this PR: API search feature

Focus areas:
🔴 Critical:
- SQL injection in search queries
- XSS in search results
- Authentication on search endpoint
- Authorization (who can search what?)
- API rate limiting

🟡 Important:
- Input validation (search terms)
- Output sanitization (results)
- Search query logging (PII?)
- Error messages (info leakage?)

Files changed:
@src/routes/search.js
@src/services/search-service.js
@src/models/search-query.js

For each issue:
- Severity
- Location (file:line)
- Explanation
- Fix (show code)
- Test to verify fix

@CLAUDE.md security section
"
```

---

### Pattern 8: Performance Review

**Template**:
```bash
git diff main..feature-branch | claude "
Performance review for this PR:

Check for:
🔴 Red flags:
- N+1 database queries
- Synchronous I/O in hot paths
- Missing database indexes
- Memory leaks
- Unbounded loops

🟡 Optimizations:
- Cacheable queries
- Batch operations
- Async opportunities
- Unnecessary computations

For each issue:
- Impact: High/Medium/Low
- Location: file:line
- Problem: What's slow
- Fix: How to optimize
- Benchmark: Expected improvement

@CLAUDE.md performance standards
"
```

---

### Pattern 9: Code Quality Review

**Template**:
```bash
git diff main..feature-branch | claude "
Code quality review:

Standards to check:
@CLAUDE.md conventions

Focus areas:
- Code organization (SRP, DRY)
- Naming (descriptive, consistent)
- Error handling (comprehensive, logged)
- Comments (why, not what)
- Test coverage (adequate, meaningful)
- Edge cases (handled, tested)

For each issue:
- Category: Organization/Naming/Errors/Tests/Docs
- Location: file:line
- Current: What's wrong
- Better: Suggested improvement
- Why: Explanation

Be constructive. Balance perfect vs pragmatic.
"
```

---

## Pattern Library: Refactoring

### Pattern 10: Safe Refactoring

**Template**:
```bash
claude "
Refactor @target-file for [GOAL]

IMPORTANT: Safety first

Process:
1. First, generate tests for CURRENT behavior
   (Don't change anything yet)
   
2. Wait for my approval of tests
   
3. Then refactor with these changes:
   [List specific changes]
   
4. Verify all tests still pass

Refactoring goals:
- [Goal 1]
- [Goal 2]

Constraints:
- Maintain backward compatibility
- Keep public API unchanged
- Don't change behavior, only structure
- [Other constraints]

@target-file
@CLAUDE.md patterns
"
```

**Real Example**:
```bash
claude "
Refactor @src/legacy-auth.js from callbacks to async/await

IMPORTANT: Safety first

Process:
1. First, generate comprehensive tests for CURRENT behavior
   - All public functions
   - Edge cases
   - Error cases
   (Don't refactor anything yet!)
   
2. I'll run tests and approve
   
3. Then refactor:
   - Convert callbacks to async/await
   - Use try/catch for errors
   - Modern error handling
   - Extract magic numbers to constants
   
4. Verify all tests still pass

Refactoring goals:
- Modern async/await (no callbacks)
- Better error handling
- More readable code
- Extract configuration

Constraints:
- MUST maintain exact same behavior
- Public API signatures stay the same
- All existing callers should work unchanged
- No breaking changes

@src/legacy-auth.js
@CLAUDE.md patterns
"
```

---

### Pattern 11: Extract Service Layer

**Template**:
```bash
claude "
Extract business logic from @route-file to service layer

Current problem:
- Routes contain business logic
- Hard to test
- Code duplication

Target pattern:
@example-route.js (thin controller)
@example-service.js (business logic)

Steps:
1. Analyze current route handlers
2. Identify business logic
3. Design service interface
4. Show me the plan (don't implement yet)

Then I'll approve and you implement:
5. Create service with business logic
6. Update route to use service
7. Generate service tests
8. Verify route tests still pass

@route-file
@CLAUDE.md service pattern
"
```

---

### Pattern 12: Modernize Codebase

**Template**:
```bash
claude "
Modernize @legacy-file from [OLD] to [NEW]

Changes:
- [Change 1]
- [Change 2]
- [Change 3]

Before refactoring:
1. Show me diff preview
2. List breaking changes (if any)
3. Migration path for consumers

Constraints:
- Maintain backward compatibility: [Yes/No]
- If breaking changes needed:
  - Add deprecation warnings first
  - Provide migration guide
  - Update all consumers in this PR

@legacy-file
@CLAUDE.md modern patterns
"
```

---

## Pattern Library: Testing

### Pattern 13: Comprehensive Test Generation

**Template**:
```bash
claude "
Generate comprehensive tests for @src-file

Test types needed:
✅ Unit tests: All public methods
✅ Edge cases: null, undefined, empty, boundary values
✅ Error cases: Network failures, DB errors, validation failures
✅ Integration: Real dependencies (no mocks)
✅ Mocks: External services only

Test structure (follow @test-pattern):
describe('ClassName', () => {
  describe('methodName', () => {
    it('should ... when ...', () => {
      // Arrange
      // Act
      // Assert
    });
  });
});

Coverage target: 100% for this file

Test framework: [Jest/Mocha/etc]
Assertion library: [expect/chai/etc]

@src-file
@tests/pattern-example.test.js
@CLAUDE.md testing standards
"
```

**Real Example**:
```bash
claude "
Generate comprehensive tests for @src/services/payment-service.js

Test types needed:
✅ Unit tests: processPayment, refundPayment, getPaymentStatus
✅ Edge cases: 
   - Zero amount
   - Negative amount
   - Very large amounts
   - Invalid card numbers
   - Expired cards
✅ Error cases:
   - Stripe API down
   - Network timeout
   - Database save fails
   - Idempotency key collision
✅ Integration: Database transactions
✅ Mocks: Stripe API only

Test structure (follow @tests/user-service.test.js):
describe('PaymentService', () => {
  describe('processPayment', () => {
    it('should process valid payment', async () => {
      // Arrange
      const paymentData = { amount: 5000, card: '4242...' };
      
      // Act
      const result = await paymentService.processPayment(paymentData);
      
      // Assert
      expect(result.status).toBe('succeeded');
    });
  });
});

Coverage target: 100% for PaymentService

Test framework: Jest
Database: Test database (not mocks)
Stripe: Mock (use stripe-mock)

@src/services/payment-service.js
@tests/user-service.test.js
@CLAUDE.md testing section
"
```

---

### Pattern 14: Test-Driven Development (TDD)

**Template**:
```bash
# Step 1: Write failing test
claude "
Write test FIRST for this feature:

Feature: [Description]

Requirements:
- [Requirement 1]
- [Requirement 2]

Write test that:
1. Describes expected behavior
2. Will fail (feature doesn't exist yet)
3. Covers happy path + edge cases

DON'T implement the feature yet, just the test.

Test pattern: @tests/example.test.js
"

# Step 2: Run test (should fail)
npm test

# Step 3: Implement feature
claude "
Now implement the feature to make this test pass:

Test file: @tests/new-feature.test.js

Requirements:
- Make ALL tests pass
- Follow patterns: @CLAUDE.md
- Minimal implementation (no gold plating)

@src/target-file
"

# Step 4: Run test (should pass)
npm test

# Step 5: Refactor (if needed)
claude "
Tests are green! Now refactor for:
- Readability
- Performance
- Maintainability

Keep tests passing.
"
```

---

### Pattern 15: Fix Test Failures

**Template**:
```bash
npm test 2>&1 | claude "
Tests are failing:

[Paste test output]

Analyze:
1. What changed that broke tests?
2. Is code wrong or tests wrong?
3. Are tests testing the right thing?

Then:
- If code is wrong: Fix code
- If tests are wrong: Fix tests
- If requirements changed: Update both

Show me:
- Root cause
- What to fix (code or tests)
- The fix
- Explanation

Context:
@src/implementation
@tests/failing-test.js
@CLAUDE.md
"
```

---

## Pattern Library: Documentation

### Pattern 16: Inline Code Documentation

**Template**:
```bash
claude "
Add comprehensive inline documentation to @src-file

Documentation style: [JSDoc/docstrings/etc]

Include:
✅ Module/class description
✅ Public method documentation:
   - Purpose
   - @param (type, description)
   - @returns (type, description)
   - @throws (when, why)
   - @example (usage)
✅ Complex logic explanation (why, not what)
✅ TODOs with ticket numbers (if any)
✅ Deprecation warnings (if applicable)

Style guide: @CLAUDE.md documentation

Don't over-document:
❌ No obvious comments ('increments i')
❌ No redundant comments ('getter for name')
✅ Focus on WHY and edge cases

@src-file
"
```

---

### Pattern 17: API Documentation

**Template**:
```bash
claude "
Generate API documentation for @api-routes-file

Format: OpenAPI 3.0 (Swagger)

For each endpoint include:
- Path and method
- Description
- Parameters (path, query, body)
- Request body schema
- Response schemas (success + errors)
- Example requests/responses
- Authentication requirements
- Rate limiting
- Error codes

Follow pattern: @docs/api/example.yaml

@api-routes-file
@CLAUDE.md API standards
"
```

---

### Pattern 18: Architecture Documentation

**Template**:
```bash
claude "
Generate architecture documentation for [SYSTEM]

Create: docs/architecture/[SYSTEM].md

Include:
1. Overview (1 paragraph: what does it do?)
2. High-level diagram (Mermaid)
3. Component breakdown:
   - Responsibility
   - Key classes/files
   - Dependencies
4. Data flow (request → response)
5. Key design decisions:
   - What we chose
   - Why we chose it
   - Trade-offs
6. Security considerations
7. Performance characteristics
8. Error handling strategy
9. Testing approach
10. Future improvements

Analyze:
@src/system/
@CLAUDE.md architecture principles
"
```

---

## Pattern Library: Project Setup

### Pattern 19: Technology Selection

**Template**:
```bash
claude "
I'm starting a new [PROJECT_TYPE] project.

Requirements:
- [Requirement 1]
- [Requirement 2]

Constraints:
- Team size: [X] developers
- Timeline: [X] months
- Budget: [tier]
- Scale: [users/requests]

Recommend:
1. Tech stack (with rationale)
2. Project structure
3. Key libraries/frameworks
4. Development tools
5. Deployment platform

For each choice explain:
- Why this vs alternatives
- Pros/cons
- Learning curve
- Community support
- Long-term viability

Compare 2-3 options, then recommend best fit.
"
```

---

### Pattern 20: Project Scaffolding

**Template**:
```bash
claude "
Create project structure for [PROJECT_TYPE]

Requirements:
- Technology: [stack]
- Patterns: [MVC/Clean/etc]
- Testing: [framework]
- Linting: [Yes/No]

Generate:
1. Directory structure
2. Essential config files:
   - package.json / requirements.txt / etc
   - .gitignore
   - .env.example
   - README.md
   - CLAUDE.md
3. Starter files (skeleton, no implementation)
4. Setup instructions

Make it production-ready:
- Linting configured
- Testing configured
- CI/CD ready
- Docker ready (optional)

Patterns: @examples/project-structure/
"
```

---

## Advanced Prompting Techniques

### Technique 1: Chain-of-Thought

**When**: Complex problems requiring step-by-step reasoning

**Template**:
```bash
claude "
[COMPLEX_PROBLEM]

Think through this step-by-step:
1. First, analyze [ASPECT 1]
2. Then, consider [ASPECT 2]
3. Next, evaluate [ASPECT 3]
4. Finally, synthesize [SOLUTION]

Show your reasoning for each step.
Don't jump to solution.

Context:
@file1
@file2
"
```

**Example**:
```bash
claude "
Should we implement caching for our user profile API?

Think through this step-by-step:
1. First, analyze current performance:
   - Response time
   - Database load
   - User experience
   
2. Then, consider caching benefits:
   - Performance improvement estimate
   - Reduced database load
   - Complexity added
   
3. Next, evaluate caching challenges:
   - Cache invalidation strategy
   - Consistency concerns
   - Memory requirements
   
4. Finally, recommend:
   - Yes/No with rationale
   - If yes: Redis vs in-memory vs CDN
   - Implementation approach
   - Rollout strategy

Show your reasoning for each step.

Context:
@src/routes/profile.js
@src/services/user-service.js
@docs/performance-requirements.md
"
```

---

### Technique 2: Role-Based Prompting

**When**: Need specific expertise

**Template**:
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

Context:
@relevant-files
"
```

**Examples**:
```bash
# Security expert
claude "
Act as a security engineer with expertise in web application security.

Task: Review this authentication implementation

From your security perspective:
- What vulnerabilities exist?
- What's the attack surface?
- How to exploit it?
- How to fix it?

Provide specific code fixes.

@src/auth/login.js
@src/middleware/jwt.js
"

# Performance engineer
claude "
Act as a performance engineer with expertise in Node.js optimization.

Task: Optimize this data processing pipeline

From your performance perspective:
- What are the bottlenecks?
- Memory usage concerns?
- Async optimization opportunities?
- Profiling recommendations?

Provide specific optimizations with benchmarks.

@src/processors/data-pipeline.js
"

# Database architect
claude "
Act as a database architect with expertise in PostgreSQL.

Task: Design schema for multi-tenant SaaS

From your database perspective:
- Schema isolation strategy?
- Query performance optimization?
- Backup and recovery approach?
- Scaling strategy?

Provide schema design + migration plan.

Requirements: @docs/requirements.md
"
```

---

### Technique 3: Multishot Examples (Few-Shot Learning)

**When**: Want consistent output format or style

**Template**:
```bash
claude "
Generate [OUTPUT_TYPE] following these examples:

Example 1:
Input: [INPUT_1]
Output: [OUTPUT_1]

Example 2:
Input: [INPUT_2]
Output: [OUTPUT_2]

Example 3:
Input: [INPUT_3]
Output: [OUTPUT_3]

Now generate for:
Input: [YOUR_INPUT]
Output: ?
"
```

**Example**:
```bash
claude "
Generate commit messages following these examples:

Example 1:
Input: Added user login feature, created auth service, updated tests
Output: 
feat(auth): implement user login

- Create authentication service
- Add JWT token generation
- Add login route and controller
- Update auth tests

Example 2:
Input: Fixed bug where users couldn't reset password
Output:
fix(auth): resolve password reset email issue

- Fix email template rendering
- Add proper error handling
- Update password reset tests

Example 3:
Input: Refactored payment service to use Stripe, removed PayPal
Output:
refactor(payment): migrate from PayPal to Stripe

- Implement Stripe payment processor
- Remove PayPal dependencies
- Update payment tests
- Add Stripe configuration docs

BREAKING CHANGE: PayPal payment method removed

Now generate for:
Input: Added role-based access control, updated middleware, created roles table
Output: ?
"
```

---

### Technique 4: Constraint-Based Prompting

**When**: Need to limit scope or enforce rules

**Template**:
```bash
claude "
[TASK]

MUST do:
- [Required action 1]
- [Required action 2]

MUST NOT do:
- [Forbidden action 1]
- [Forbidden action 2]

Within these constraints:
[Additional requirements]

@relevant-files
"
```

**Example**:
```bash
claude "
Refactor this authentication system

MUST do:
- Keep existing API endpoints unchanged
- Maintain backward compatibility
- Add comprehensive tests
- Follow our error handling pattern

MUST NOT do:
- Change database schema
- Modify JWT token format
- Break existing client applications
- Remove any existing functionality

Within these constraints, refactor to:
- Use async/await (not callbacks)
- Extract service layer
- Improve error messages
- Add logging

@src/auth/
@CLAUDE.md patterns
"
```

---

## Prompting Anti-Patterns

### ❌ Anti-Pattern 1: Vague Requests

```bash
# Bad
claude "make it better"
claude "fix this"
claude "improve performance"

# Good
claude "Refactor for readability: extract long functions, add descriptive names, add error handling"
claude "Fix null pointer exception on line 45 when user is undefined"
claude "Optimize database query: reduce from 2000ms to <200ms by adding indexes or caching"
```

---

### ❌ Anti-Pattern 2: No Context

```bash
# Bad
claude "add authentication"

# Good
claude "Add JWT authentication to @src/routes/api.js following @src/middleware/auth-example.js pattern. Store tokens in httpOnly cookies. @CLAUDE.md"
```

---

### ❌ Anti-Pattern 3: Everything At Once

```bash
# Bad
claude "Build complete e-commerce site with user management, product catalog, shopping cart, payment processing, order management, admin dashboard"

# Good (incremental)
claude "Step 1: Set up user registration and login with JWT"
# Wait for completion
claude "Step 2: Add product model and CRUD API"
# Wait for completion
claude "Step 3: Implement shopping cart"
# Continue step-by-step
```

---

### ❌ Anti-Pattern 4: Ignoring Project Patterns

```bash
# Bad
claude "Add an API endpoint"

# Good
claude "Add POST /api/users endpoint following our REST pattern @src/routes/example-route.js. Include validation middleware, error handling, and tests. @CLAUDE.md API conventions"
```

---

### ❌ Anti-Pattern 5: No Success Criteria

```bash
# Bad
claude "write tests"

# Good
claude "Generate tests for @src/service.js:
- Unit tests: All public methods
- Edge cases: null, undefined, empty
- Error cases: Network fail, timeout
- Coverage target: 90%+
- Pattern: @tests/example.test.js"
```

---

## Quick Reference: Prompt Templates

### Feature Development
```bash
"Implement [FEATURE] with requirements: [LIST], constraints: [LIST], following @CLAUDE.md patterns. Ask clarifying questions first."
```

### Debugging
```bash
"Fix error: [ERROR] in @file:line. Context: [WHEN IT HAPPENS]. Show root cause, fix, and test."
```

### Code Review
```bash
git diff | claude "Review for: security, performance, quality. Report: severity, location, fix. @CLAUDE.md standards"
```

### Refactoring
```bash
"Refactor @file for [GOAL]. MUST: maintain compatibility. MUST NOT: change public API. Generate tests first."
```

### Testing
```bash
"Generate comprehensive tests for @file: unit, edge cases, errors. Coverage: 100%. Pattern: @tests/example.test.js"
```

### Documentation
```bash
"Add JSDoc to @file: method descriptions, @param, @returns, @throws, @example. Style: @CLAUDE.md docs"
```

---

## Next Steps

- **Set Up CLAUDE.md**: [Section 2b: CLAUDE.md Guide](../01-fundamentals-core-concepts/02b-claude-md-guide)
- **Learn Context Optimization**: [Section 15: Context Management](15-context-management)
- **Explore Daily Workflows**: [Section 3b: Daily Workflows](../01-fundamentals-core-concepts/03b-daily-workflows)

---

[← Back to Part 5 Index](README) | [Next: Context Management →](15-context-management)


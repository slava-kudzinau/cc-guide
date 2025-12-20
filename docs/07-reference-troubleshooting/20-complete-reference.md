---
title: "Section 20: Complete Reference Guide"
parent: "Part 7: Reference, Troubleshooting & Future"
nav_order: 1
---

# Section 20: Complete Reference Guide

## CLI Command Reference

### Basic Commands
```bash
# Interactive mode
claude

# One-shot command
claude "your question"

# With file context
claude "@src/file.js explain this"

# Extended thinking
claude --thinking=5000 "complex task"

# Specific model
claude --model claude-opus-4-0 "task"

# Output to file
claude "generate code" > output.js
```

### Advanced CLI Options
```bash
--api-key KEY          # Override API key
--model MODEL          # Specify model
--thinking BUDGET      # Extended thinking budget
--max-tokens N         # Max output tokens
--platform PLATFORM    # anthropic|bedrock|vertex
--debug                # Debug mode
--version              # Show version
--help                 # Show help
```

## API Parameter Reference

### Messages API
```typescript
{
  model: "claude-sonnet-4-5",
  max_tokens: 4096,
  thinking: {
    type: "enabled",
    budget_tokens: 5000
  },
  system: "You are a helpful assistant",
  messages: [
    { role: "user", content: "Hello" }
  ],
  temperature: 1.0,
  top_p: 0.9
}
```

## Prompt Templates Library

**Copy-Paste Ready Prompts for Daily Development**

All prompts below are production-ready - no placeholders to replace. Copy, paste, and use immediately.

---

### 🔍 Code Review Prompts

#### Comprehensive Security Review

```bash
git diff --cached | claude "Review for security vulnerabilities:

Critical:
- SQL injection (parameterized queries?)
- XSS vulnerabilities (input sanitization?)
- Authentication bypasses
- Secrets in code (API keys, passwords)
- CORS misconfigurations

High Priority:
- Input validation missing
- Error messages leaking info
- Insecure dependencies
- Missing rate limiting
- Weak cryptography

Format as:
🔴 Critical Issues (block merge)
🟡 High Priority (fix before deploy)
🟢 Good Security Practices

Include file:line references for each issue."
```

**When to use:** Before every commit  
**Time:** 30-60 seconds

---

#### Performance Review

```bash
git diff main | claude "Analyze for performance issues:

Backend:
- N+1 database queries
- Missing database indexes
- Inefficient algorithms (O(n²) or worse)
- Memory leaks (unclosed connections)
- Blocking operations

Frontend:
- Unnecessary re-renders
- Large bundle size
- Missing code splitting
- Unoptimized images
- No caching strategy

Provide:
1. Issue location (file:line)
2. Current performance impact
3. Specific fix with code
4. Expected improvement"
```

**When to use:** Before PR, after performance-critical changes  
**Time:** 1-2 minutes

---

#### Architecture Review

```bash
git diff main | claude "Review architecture decisions:

Evaluate:
- Design patterns used
- Separation of concerns
- SOLID principles adherence
- Scalability considerations
- Technical debt introduced

Questions:
- Is this the right abstraction?
- Will this scale to 10x traffic?
- Are dependencies appropriate?
- Is error handling comprehensive?
- Does this fit the existing architecture?

Be critical - challenge decisions constructively."
```

**When to use:** Major refactors, new features  
**Time:** 2-3 minutes

---

#### Quick Lint Check

```bash
git diff --cached | claude "Quick review:
- Remove console.logs
- Remove commented code
- Check for TODOs without tickets
- Verify consistent formatting
- Check for debugging code

List issues only, no explanations needed."
```

**When to use:** Before every commit  
**Time:** 10-15 seconds

---

### ✅ Testing Prompts

#### Generate Unit Tests

```bash
claude "Generate Jest unit tests for src/utils/validation.ts:

Requirements:
- Test all exported functions
- Cover happy path + 3 error cases per function
- Use AAA pattern (Arrange, Act, Assert)
- Include edge cases (null, undefined, empty)
- Mock external dependencies
- Aim for 100% coverage

Format:
describe('function name', () => {
  it('should handle valid input', ...)
  it('should handle error case', ...)
})"
```

**When to use:** After writing new functions  
**Time:** 1-2 minutes

---

#### Generate Integration Tests

```bash
claude "Generate integration tests for the user registration API:

@src/routes/auth.ts
@src/models/user.ts

Test scenarios:
1. Successful registration with valid data
2. Duplicate email rejection
3. Invalid email format
4. Weak password rejection
5. Database connection failure
6. Email service failure

Use supertest + Jest. Include setup/teardown for database."
```

**When to use:** After API changes  
**Time:** 2-3 minutes

---

#### Generate E2E Tests

```bash
claude "Generate Playwright E2E test for user login flow:

Flow:
1. Navigate to /login
2. Enter credentials
3. Submit form
4. Verify redirect to /dashboard
5. Verify user name displayed
6. Logout and verify redirect

Include:
- Page object model pattern
- Error scenarios (wrong password)
- Loading states
- Mobile viewport test"
```

**When to use:** New user flows  
**Time:** 3-4 minutes

---

#### Suggest Missing Tests

```bash
npm test -- --coverage | claude "Analyze test coverage report.

What test cases are missing?
- Untested functions
- Uncovered error paths
- Missing edge cases
- Integration gaps

Suggest top 5 most important tests to add, prioritized by:
1. Risk (critical path > nice-to-have)
2. Complexity (complex logic needs more tests)
3. Change frequency (often changed code needs good coverage)"
```

**When to use:** Weekly code quality review  
**Time:** 2 minutes

---

### 🐛 Debugging Prompts

#### Analyze Test Failures

```bash
npm test 2>&1 | claude "Analyze test failures:

For each failure:
1. Root cause
2. Which code change likely broke it
3. Specific fix with code
4. How to prevent similar failures

Focus on the actual logic error, not just making tests pass."
```

**When to use:** When tests fail  
**Time:** 30-60 seconds

---

#### Debug Production Error

```bash
claude "Production error - help debug:

Error:
[paste full error message and stack trace]

Relevant code:
@src/api/users.ts
@src/middleware/auth.ts

Context:
- Started happening after deploy at 2pm
- Affects 5% of requests
- Only occurs for users with role 'admin'

Find:
1. Root cause
2. Why it affects only admins
3. Fix with code
4. How to prevent recurrence"
```

**When to use:** Production incidents  
**Time:** 2-3 minutes

---

#### Analyze Logs

```bash
tail -n 200 /var/log/app.log | claude "Analyze logs:

Find:
- Error patterns
- Most frequent errors
- Suspicious sequences
- Performance bottlenecks
- Security concerns

Summarize top 3 issues to investigate."
```

**When to use:** Investigating production issues  
**Time:** 1 minute

---

#### Debug React Re-Renders

```bash
claude "Component re-rendering too often:

@src/components/UserProfile.tsx

Symptoms:
- Renders 10+ times per second
- Browser becomes slow
- Console shows 'Maximum update depth exceeded'

Analyze:
1. State updates in render
2. Dependencies in useEffect
3. Unnecessary prop changes
4. Context re-renders

Provide specific fixes with code."
```

**When to use:** React performance issues  
**Time:** 1-2 minutes

---

### 📚 Documentation Prompts

#### Generate API Documentation

```bash
claude "Generate API documentation for all routes in src/routes/

@src/routes/

Format in markdown:

## Endpoint Name
`POST /api/endpoint`

**Description:** What it does

**Authentication:** Required/Optional

**Request:**
```json
{ example request }
```

**Response:**
```json
{ example response }
```

**Errors:**
- 400: Description
- 401: Description

**Example:**
```bash
curl example
```

Include all endpoints."
```

**When to use:** After API changes  
**Time:** 3-5 minutes

---

#### Update README

```bash
git diff main src/routes/ | claude "Update README.md based on API changes:

If new endpoints added: Add to API section
If endpoints removed: Remove from docs
If parameters changed: Update examples
If authentication changed: Update auth docs

Keep existing README structure and style."
```

**When to use:** Before every PR with API changes  
**Time:** 1 minute

---

#### Generate Architecture Decision Record (ADR)

```bash
claude "Create ADR for today's decision to migrate from REST to GraphQL:

Title: ADR-XXX: Migrate to GraphQL

Context: What problem we're solving
- Current REST API has over-fetching issues
- Mobile clients need flexible queries
- 30+ endpoints becoming hard to maintain

Decision: What we decided
- Migrate to GraphQL with Apollo Server
- Keep REST for legacy clients (6 months)
- Use DataLoader for N+1 prevention

Consequences:
- Positive: Better mobile performance, single endpoint
- Negative: Team learning curve, build complexity
- Neutral: Need new monitoring tools

Status: Accepted

Date: [today]"
```

**When to use:** After major architectural decisions  
**Time:** 2-3 minutes

---

#### Generate Changelog

```bash
git log --since='1 week ago' --pretty=format:'%s' | claude "Generate CHANGELOG.md entry:

Format:
## [Version] - Date

### Added
- New features

### Changed
- Modifications

### Fixed
- Bug fixes

### Security
- Security updates

Group commits by type (feat/fix/refactor/etc).
Use user-friendly language, not git commit messages."
```

**When to use:** Release preparation  
**Time:** 1-2 minutes

---

### 🔨 Refactoring Prompts

#### Modernize Legacy Code

```bash
claude "Refactor src/utils/legacy.js to modern ES6+:

@src/utils/legacy.js

Requirements:
- Convert to ES6 modules
- Use const/let instead of var
- Convert callbacks to async/await
- Use arrow functions
- Add TypeScript types
- Preserve exact behavior (no logic changes)

Show before/after diff for verification."
```

**When to use:** Technical debt cleanup  
**Time:** 2-3 minutes

---

#### Extract Reusable Component

```bash
claude "Extract reusable component from UserProfile.tsx:

@src/components/UserProfile.tsx

The avatar section (lines 45-67) is duplicated in 3 components.

Create:
1. Separate Avatar.tsx component
2. Props interface
3. Update UserProfile to use it
4. Identify other components that should use it

Make it flexible for different avatar sizes and styles."
```

**When to use:** Removing code duplication  
**Time:** 2-3 minutes

---

#### Improve Error Handling

```bash
git diff main | claude "Review new code and add comprehensive error handling:

Add:
- Try-catch for async operations
- Input validation
- Graceful degradation
- User-friendly error messages
- Logging for debugging
- Specific error types (not generic 'Error')

Show updated code with error handling."
```

**When to use:** After initial implementation  
**Time:** 2-3 minutes

---

#### Optimize Database Queries

```bash
claude "Optimize database queries in src/services/users.ts:

@src/services/users.ts

Look for:
- N+1 queries (use eager loading)
- Missing indexes
- SELECT * (select only needed fields)
- Inefficient joins
- Missing pagination
- No query caching

Provide:
1. Current query performance issues
2. Optimized queries
3. Recommended indexes
4. Expected performance improvement"
```

**When to use:** Performance optimization  
**Time:** 3-5 minutes

---

### 🏗️ Architecture & Design Prompts

#### Design New Feature

```bash
claude "Design architecture for real-time notifications feature:

Requirements:
- Push notifications to web + mobile
- Notification history
- Read/unread status
- Categories (mentions, updates, system)
- 1M+ users scale

Provide:
1. Technology choices (WebSockets? Server-Sent Events? Push API?)
2. Database schema
3. API endpoints
4. Client-side architecture
5. Scalability considerations
6. Cost estimates

Be specific with technologies and reasons."
```

**When to use:** Planning new features  
**Time:** 5-10 minutes

---

#### Database Schema Design

```bash
claude "Design database schema for multi-tenant SaaS:

Requirements:
- Organizations (tenants)
- Users (belong to organizations)
- Projects (belong to organizations)
- Tasks (belong to projects)
- Comments (belong to tasks)
- File attachments
- Audit log

Provide:
1. Tables with columns and types
2. Relationships (foreign keys)
3. Indexes for performance
4. Data isolation strategy
5. Migration plan from current single-tenant schema"
```

**When to use:** Database design  
**Time:** 5-10 minutes

---

#### API Design

```bash
claude "Design REST API for project management tool:

Resources:
- Projects
- Tasks
- Users
- Comments
- Files

Provide:
1. All endpoints (GET/POST/PUT/DELETE)
2. Request/response formats
3. Authentication strategy
4. Pagination approach
5. Filtering/sorting
6. Versioning strategy
7. Rate limiting

Follow REST best practices."
```

**When to use:** API planning  
**Time:** 5-10 minutes

---

### 🚀 DevOps & Deployment Prompts

#### Generate Terraform/IaC

```bash
claude "Generate Terraform configuration for:

Infrastructure:
- AWS RDS PostgreSQL (db.t3.medium)
- ElastiCache Redis (cache.t3.micro)
- Application Load Balancer
- ECS Fargate (2 tasks)
- S3 bucket for static assets
- CloudFront CDN
- Route53 DNS

Environment: Production
Region: us-east-1

Include:
- Security groups
- IAM roles
- Backup configuration
- Monitoring alarms
- Cost optimization tags"
```

**When to use:** Infrastructure provisioning  
**Time:** 5-10 minutes

---

#### Generate CI/CD Pipeline

```bash
claude "Generate GitHub Actions workflow:

Pipeline:
1. Lint (ESLint + Prettier)
2. Test (Jest with coverage > 80%)
3. Build (Docker image)
4. Security scan (Snyk)
5. Deploy to staging (on main branch)
6. Run E2E tests (Playwright)
7. Deploy to production (on tag v*)

Include:
- Caching for speed
- Parallel jobs where possible
- Deployment approvals
- Rollback on failure
- Slack notifications"
```

**When to use:** Setting up CI/CD  
**Time:** 5-10 minutes

---

#### Docker Optimization

```bash
claude "Optimize this Dockerfile:

@Dockerfile

Current build time: 5 minutes
Current image size: 1.2GB

Optimize for:
- Faster builds (use layer caching)
- Smaller image (multi-stage build)
- Security (non-root user, minimal base)
- Production-ready (health checks)

Show before/after with explanations."
```

**When to use:** Docker optimization  
**Time:** 2-3 minutes

---

#### Generate Kubernetes Manifests

```bash
claude "Generate Kubernetes manifests for Node.js API:

Requirements:
- Deployment (3 replicas)
- Service (LoadBalancer)
- ConfigMap (environment config)
- Secret (API keys)
- HorizontalPodAutoscaler (scale 3-10 pods)
- Ingress (with TLS)
- Health checks (liveness + readiness)

Include resource limits and monitoring labels."
```

**When to use:** Kubernetes deployment  
**Time:** 5 minutes

---

### 🔒 Security Prompts

#### Security Audit

```bash
git log -p --since='1 week ago' | claude "Security audit of recent changes:

Check for:
- Secrets committed (API keys, passwords)
- SQL injection vulnerabilities
- XSS vulnerabilities
- Authentication issues
- Authorization bypasses
- Insecure dependencies
- Missing input validation
- Cryptography mistakes

🔴 Critical issues: Block deployment
🟡 High priority: Fix ASAP
🟢 Recommendations: Plan to address"
```

**When to use:** Weekly security review  
**Time:** 2-3 minutes

---

#### Dependency Vulnerability Analysis

```bash
npm audit | claude "Analyze dependency vulnerabilities:

Prioritize:
1. Vulnerabilities in direct dependencies (easier to fix)
2. Critical/High severity
3. Exploitability in our use case
4. Availability of patches

For top 5 vulnerabilities:
- Risk assessment (how exploitable in our app?)
- Recommended fix (update version or alternative package)
- Urgency (fix today vs next sprint)"
```

**When to use:** Weekly dependency review  
**Time:** 2-3 minutes

---

#### Generate Security Headers

```bash
claude "Generate security headers for Express app:

@src/middleware/security.ts

Add headers for:
- Content Security Policy (CSP)
- X-Frame-Options
- X-Content-Type-Options
- Strict-Transport-Security (HSTS)
- X-XSS-Protection
- Referrer-Policy
- Permissions-Policy

Use helmet.js. Provide configuration tuned for:
- SPA (React)
- API endpoints
- File uploads
- WebSockets

Include explanations for each header."
```

**When to use:** Security hardening  
**Time:** 2-3 minutes

---

### 🎨 Frontend Development Prompts

#### Convert Design to Code

```bash
# Attach screenshot first, then:

claude "Implement this design in React:

Requirements:
- Responsive (mobile, tablet, desktop)
- Tailwind CSS
- TypeScript
- Accessible (ARIA labels, keyboard nav)
- Loading states
- Error states

Component structure:
- Break into reusable sub-components
- Props interfaces
- State management approach"
```

**When to use:** Implementing UI designs  
**Time:** 5-10 minutes

---

#### Optimize React Performance

```bash
claude "Optimize React component performance:

@src/components/ProductList.tsx

Issues:
- Re-renders on every prop change
- Renders 100+ products at once
- Images not lazy loaded

Apply:
- React.memo for components
- useMemo for expensive calculations
- useCallback for event handlers
- Virtual scrolling for long lists
- Lazy loading for images

Show before/after performance impact."
```

**When to use:** Performance optimization  
**Time:** 3-5 minutes

---

#### Generate Form with Validation

```bash
claude "Generate React form with validation:

Form: User Registration

Fields:
- Email (required, valid email)
- Password (required, min 8 chars, 1 uppercase, 1 number)
- Confirm Password (must match)
- Name (required, min 2 chars)
- Phone (optional, valid format)

Use:
- React Hook Form
- Zod for validation
- TypeScript
- Error messages on blur
- Submit button disabled until valid
- Loading state during submission"
```

**When to use:** Building forms  
**Time:** 3-5 minutes

---

### 📊 Data Analysis Prompts

#### Analyze SQL Query Performance

```bash
EXPLAIN ANALYZE [your query here] | claude "Analyze query performance:

Identify:
- Sequential scans (should use index)
- Expensive operations
- Missing indexes
- Inefficient joins

Provide:
1. Current bottlenecks
2. Recommended indexes
3. Query rewrite suggestions
4. Expected performance improvement"
```

**When to use:** Database optimization  
**Time:** 2-3 minutes

---

#### Generate SQL Queries

```bash
claude "Generate SQL queries for analytics dashboard:

Tables:
@src/database/schema.sql

Queries needed:
1. Monthly revenue (group by month, show trend)
2. Top 10 products by sales
3. Customer retention rate (month-over-month)
4. Average order value by customer segment
5. Conversion funnel (visitors → signups → purchases)

Use:
- PostgreSQL syntax
- CTEs for readability
- Indexes for performance
- Comments explaining logic"
```

**When to use:** Analytics feature development  
**Time:** 5-10 minutes

---

#### Data Migration Script

```bash
claude "Generate data migration script:

Migration: Add 'subscription_tier' to users table

Steps:
1. Add new column (nullable initially)
2. Backfill data:
   - Users with active_subscription=true → 'premium'
   - Users created > 30 days ago → 'free'
   - Others → 'trial'
3. Make column non-nullable
4. Add index
5. Update application code references

Provide:
- SQL migration (up + down)
- Validation queries
- Rollback plan
- Estimated duration"
```

**When to use:** Database migrations  
**Time:** 5 minutes

---

### 🔄 Git & Version Control Prompts

#### Generate Commit Message

```bash
git diff --cached | claude "Generate conventional commit message:

Format:
type(scope): description

Types: feat|fix|refactor|docs|test|chore

Examples:
- feat(auth): add OAuth login
- fix(api): handle null user error
- refactor(db): optimize user queries

Based on staged changes, generate appropriate commit message.
Include body if changes are complex."
```

**When to use:** Before every commit  
**Time:** 5 seconds

---

#### Generate PR Description

```bash
git diff main | claude "Generate PR description:

## What Changed
[List main changes]

## Why
[Reason for changes]

## Testing Done
[How it was tested]

## Breaking Changes
[Any breaking changes? Migration needed?]

## Screenshots
[If UI changes]

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No secrets committed
- [ ] Backwards compatible OR migration provided"
```

**When to use:** Creating PRs  
**Time:** 1-2 minutes

---

#### Resolve Merge Conflicts

```bash
git diff --name-only --diff-filter=U | xargs cat | claude "Help resolve merge conflicts:

Files in conflict:
$(git diff --name-only --diff-filter=U)

Conflict diff:
$(git diff)

Analyze:
1. What changed in each branch
2. Which changes should be kept
3. How to merge both changes if both are needed
4. Potential issues after merge

Provide resolved code for each file."
```

**When to use:** Merge conflicts  
**Time:** 2-5 minutes

---

### 📈 Monitoring & Observability

#### Generate Monitoring Alerts

```bash
claude "Generate monitoring alerts for Node.js API:

Metrics to monitor:
- Response time (p50, p95, p99)
- Error rate (5xx errors)
- Request rate (traffic spikes/drops)
- Memory usage
- CPU usage
- Database connections
- Queue depth

For each:
- Threshold (when to alert)
- Severity (critical/warning)
- Alert message
- Runbook link

Use Prometheus + Alertmanager format."
```

**When to use:** Setting up monitoring  
**Time:** 5 minutes

---

#### Analyze Application Logs

```bash
tail -n 1000 /var/log/app.log | claude "Analyze application logs:

Find patterns:
- Error frequency and types
- Slow requests (> 1s response time)
- Failed authentication attempts
- Database connection issues
- Memory warnings

Provide:
1. Top 5 issues by frequency
2. Correlation between events
3. Recommendations to fix
4. Suggested additional logging"
```

**When to use:** Investigating issues  
**Time:** 2 minutes

---

## Using These Prompts Effectively

### Tips for Success

1. **Attach relevant files**: Use `@filename` or drag-drop for context
2. **Pipe command output**: `command | claude "prompt"` for analysis
3. **Be specific**: Better results with clear requirements
4. **Iterate**: Start with prompt, refine based on output
5. **Save custom versions**: Modify prompts for your team's needs

### Customizing for Your Project

Replace generic references with your specifics:
```bash
# Generic
claude "review code"

# Customized for your team
claude "review code - follow our team style guide in docs/STYLE.md, 
check against security policy in docs/SECURITY.md"
```

### Building Your Team Library

**Create a shared prompt library:**
```bash
# In your project
mkdir .claude-prompts/

# Save effective prompts
echo "git diff main | claude 'review following team checklist...'" > .claude-prompts/pr-review.sh

# Make executable
chmod +x .claude-prompts/*.sh

# Share with team via git
```

### Keyboard Shortcuts

**Save time with aliases:**
```bash
# Add to ~/.bashrc or ~/.zshrc
alias cr='git diff --cached | claude "code review"'
alias ct='npm test 2>&1 | claude "explain failures"'
alias cm='git diff --cached | claude "commit message"'

# Use:
git add .
cr    # Review
ct    # Test
cm    # Commit message
```

---

## Next-Level Prompt Engineering

### Chain Prompts

```bash
# Step 1: Generate code
claude "create user API" > output.ts

# Step 2: Generate tests
claude "write tests for output.ts" > output.test.ts

# Step 3: Review all
git add output.*
git diff --cached | claude "review generated code"
```

### Context7 Prompt Patterns

Use Context7 to access up-to-date library documentation in your prompts.

#### Basic Context7 Patterns

```bash
# Get latest documentation
claude "Context7: [library] [version] [topic]"

# Examples:
claude "Context7: Next.js 15 app router authentication"
claude "Context7: React 19 new hooks documentation"
claude "Context7: Prisma 5 client extensions"
```

#### Context7 + Code Analysis

```bash
# Review code using latest patterns
claude "Context7: Get latest Next.js 15 patterns, then review this code" \
  --files="src/app/page.tsx"

# Upgrade code to latest version
claude "Context7: React 19 migration guide - apply to this component" \
  --files="src/components/UserProfile.tsx"

# Check for deprecated features
claude "Context7: What's deprecated in Next.js 15 that this code uses?" \
  --files="src/app/**/*.tsx"
```

#### Context7 for Feature Development

```bash
# Learn then build
claude "Context7: Next.js 15 server actions best practices
Then create user login endpoint using those patterns"

# Compare approaches
claude "Context7: Compare Next.js 15 server actions vs API routes for this use case"

# Stay current
claude "Context7: Latest React 19 performance optimization patterns - apply to my app" \
  --files="src/components/Dashboard.tsx"
```

#### Context7 Prompt Library

**Frontend Development:**
```bash
# React
"Context7: React 19 [feature] - show examples"
"Context7: Compare React 18 vs React 19 [concept]"

# Next.js
"Context7: Next.js 15 [pattern] best practices"
"Context7: Next.js 15 migration from v14 breaking changes"

# Styling
"Context7: Tailwind CSS v4 [feature]"
"Context7: CSS container queries browser support"
```

**Backend Development:**
```bash
# Node.js
"Context7: Node.js 22 native TypeScript support setup"
"Context7: Node.js performance best practices 2024"

# Frameworks
"Context7: NestJS 10 [feature] implementation"
"Context7: Fastify v4 async hooks patterns"

# Databases
"Context7: Prisma 5 advanced queries"
"Context7: PostgreSQL 16 new features"
```

**DevOps & Cloud:**
```bash
# Infrastructure
"Context7: AWS CDK v3 [service] construct patterns"
"Context7: Terraform 1.7 best practices"

# Containers
"Context7: Docker Compose v2.24 watch mode"
"Context7: Kubernetes 1.29 deployment strategies"

# CI/CD
"Context7: GitHub Actions latest syntax"
"Context7: GitLab CI pipeline optimization 2024"
```

#### When to Use Context7

✅ **Use Context7 when:**
- Framework released new version in last 6 months
- Working with beta/preview features
- Need version-specific guidance
- Documentation recently updated
- Best practices evolved

❌ **Skip Context7 when:**
- Stable, mature APIs (Node.js core, Express basics)
- Internal/proprietary libraries
- Claude's training data is current enough

#### Context7 Troubleshooting Patterns

```bash
# Debug using latest patterns
claude "Context7: Common [framework] [version] pitfalls - check my code" \
  --files="src/app/api/route.ts"

# Fix deprecated code
claude "Context7: [library] deprecated features - find and fix in my code" \
  --files="src/**/*.ts"

# Performance issues
claude "Context7: [framework] [version] performance anti-patterns - audit my code" \
  --files="src/components/**/*.tsx"
```

#### Combining Context7 with Other Patterns

```bash
# Context7 + CLAUDE.md
# Create CLAUDE.md with project context
# Use Context7 for library-specific knowledge
claude "Using project context from CLAUDE.md and Context7 Next.js 15 patterns, 
implement user authentication"

# Context7 + Prompt caching
# First query creates cache
claude "Context7: Next.js 15 comprehensive guide"
# Subsequent queries use cache
claude "Based on previous Context7 Next.js info, create login page"

# Context7 + Skills
claude "Use @company-standards skill for code structure, 
Context7 Next.js 15 for framework patterns,
implement user dashboard"
```

### Prompt Templates with Functions

```bash
# Save as ~/.claude-functions.sh

code_review() {
  git diff "$1" | claude "Review changes:
  - Security issues
  - Performance problems
  - Best practices
  Focus area: $2"
}

# Use:
code_review main "authentication logic"
```

---

**Pro tip:** Copy this entire section to a local file for quick reference. Customize prompts for your team's specific needs and tech stack.

[← Back to Part 7 Index](README) | [Next: Troubleshooting →](21-troubleshooting)




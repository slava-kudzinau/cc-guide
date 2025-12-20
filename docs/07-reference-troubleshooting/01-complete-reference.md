---
title: "Section 01: Complete Reference Guide"
parent: "Part 7: Reference, Troubleshooting & Future"
nav_order: 1
---

# Section 01: Complete Reference Guide

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

## Essential Prompts

**The 12 most-used prompts for daily development.**

These cover 80% of daily use cases. For the complete library with 50+ prompts, see [Appendix: Comprehensive Prompt Library](appendix-prompt-library.md).

---

### 1. Security Review (Before Commit)

```bash
git diff --cached | claude "Review for security vulnerabilities:

Critical:
- SQL injection, XSS, auth bypasses
- Secrets in code
- Missing input validation

Format as 🔴 Critical, 🟡 High Priority, 🟢 Good Practices
Include file:line references."
```

⏱️ 30-60 seconds

---

### 2. Quick Lint Check (Before Commit)

```bash
git diff --cached | claude "Quick review:
- Remove console.logs and commented code
- Check for TODOs without tickets
- Verify formatting
List issues only, no explanations."
```

⏱️ 10-15 seconds

---

### 3. Generate Unit Tests

```bash
claude "Generate Jest unit tests for @src/utils/validation.ts:

Requirements:
- Test all exported functions
- Cover happy path + error cases
- Use AAA pattern
- Include edge cases (null, undefined, empty)
- Aim for 100% coverage"
```

⏱️ 1-2 minutes

---

### 4. Debug Production Error

```bash
claude "Production error - help debug:

Error: [paste stack trace]

Relevant code:
@src/api/users.ts
@src/middleware/auth.ts

Context:
- Started after deploy at 2pm
- Affects 5% of requests
- Only users with role 'admin'

Find root cause + fix + prevention."
```

⏱️ 2-3 minutes

---

### 5. Analyze Test Failures

```bash
npm test 2>&1 | claude "Analyze test failures:

For each failure:
1. Root cause
2. Which change likely broke it
3. Specific fix with code
4. How to prevent similar failures"
```

⏱️ 30-60 seconds

---

### 6. Generate Commit Message

```bash
git diff --cached | claude "Generate conventional commit message:

Format: type(scope): description
Types: feat|fix|refactor|docs|test|chore

Examples:
- feat(auth): add OAuth login
- fix(api): handle null user error

Based on staged changes."
```

⏱️ 5 seconds

---

### 7. Generate PR Description

```bash
git diff main | claude "Generate PR description:

## What Changed
## Why
## Testing Done
## Breaking Changes

Checklist:
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No secrets committed"
```

⏱️ 1-2 minutes

---

### 8. Update README After Changes

```bash
git diff main src/routes/ | claude "Update README.md based on API changes:

- New endpoints? Add to API section
- Removed endpoints? Remove from docs
- Changed parameters? Update examples
- Changed auth? Update auth docs

Keep existing README structure."
```

⏱️ 1 minute

---

### 9. Generate API Documentation

```bash
claude "Generate API docs for @src/routes/

Format in markdown:
## Endpoint Name
`POST /api/endpoint`
**Description:** What it does
**Request:** { example }
**Response:** { example }
**Errors:** 400, 401 descriptions"
```

⏱️ 3-5 minutes

---

### 10. Refactor Legacy Code

```bash
claude "Refactor @src/utils/legacy.js to modern ES6+:

Requirements:
- Convert to ES6 modules
- Use const/let instead of var
- Convert callbacks to async/await
- Add TypeScript types
- Preserve exact behavior"
```

⏱️ 2-3 minutes

---

### 11. Optimize Database Queries

```bash
claude "Optimize database queries in @src/services/users.ts:

Look for:
- N+1 queries (use eager loading)
- Missing indexes
- SELECT * (select only needed fields)
- Inefficient joins

Provide optimized queries + recommended indexes."
```

⏱️ 3-5 minutes

---

### 12. Analyze Application Logs

```bash
tail -n 200 /var/log/app.log | claude "Analyze logs:

Find:
- Error patterns
- Most frequent errors
- Performance bottlenecks

Summarize top 3 issues to investigate."
```

⏱️ 1 minute

---

## More Prompts

**Want more?** See [Appendix: Comprehensive Prompt Library](appendix-prompt-library.md) for 50+ prompts covering:
- Advanced security audits
- E2E testing
- Docker & Kubernetes
- React performance
- Data migrations
- And much more

---

## Using Prompts Effectively

**Tips:**
1. Attach relevant files with `@filename`
2. Pipe command output: `command | claude "prompt"`
3. Be specific with requirements
4. Customize for your project patterns

**Save time with aliases:**
```bash
# Add to ~/.bashrc
alias cr='git diff --cached | claude "code review"'
alias cm='git diff --cached | claude "commit message"'
```

---

## Context7 Integration

Access up-to-date library documentation in prompts:

```bash
# Get latest framework patterns
claude "Context7: Next.js 15 app router authentication"
claude "Context7: React 19 new hooks documentation"

# Review code with latest patterns
claude "Context7: Next.js 15 patterns, then review @src/app/page.tsx"

# Check for deprecated features
claude "Context7: What's deprecated in Next.js 15 in my code?" @src/app/**/*.tsx
```

**When to use Context7:**
- Framework released in last 6 months
- Need version-specific guidance
- Working with beta features

See [Context7 documentation](https://context7.ai) for complete integration guide.

[← Back to Part 7 Index](README.md) | [Next: Troubleshooting →](02-troubleshooting.md)




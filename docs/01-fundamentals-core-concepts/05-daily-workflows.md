---
title: "Section 5: Day-in-the-Life - Real Developer Workflows"
parent: "Part 1: Fundamentals & Core Concepts"
nav_order: 5
---

# Section 5: Day-in-the-Life - Real Developer Workflows

This guide shows you **exactly** how to use Claude Code throughout your workday. Every scenario is real, practical, and copy-paste ready.

---

## Morning: Getting Started (8:00 AM - 9:00 AM)

### Scenario 1: Monday Morning Catch-Up

**Situation**: You return after the weekend. What happened while you were away?

```bash
# 1. Update local repository
git pull origin main

# 2. Understand what changed
git log --since="Friday 5pm" --oneline --all | claude "
Summarize changes since Friday:
- What features were added?
- Any bug fixes?
- What do I need to know?
- Any breaking changes?

@CLAUDE.md
"

# 3. Check your branch status
git log main..feature/your-branch --oneline | claude "
I'm working on [feature name].
Based on main branch changes, do I need to:
- Rebase?
- Resolve conflicts?
- Update tests?

@CLAUDE.md
"
```

**Time saved**: 15 minutes (vs manually reviewing PRs)

---

### Scenario 2: Stand-Up Preparation

**Situation**: Stand-up in 10 minutes, need to summarize your work

```bash
# Generate stand-up summary
git log --since="yesterday" --author="your-email" --oneline | claude "
Generate stand-up summary:

Format:
**Yesterday:**
- [What I completed]

**Today:**
- [What I plan to do]

**Blockers:**
- [Any blockers]

Based on my commits and current branch status.
"
```

**Time saved**: 5 minutes

---

## Mid-Morning: Feature Development (9:00 AM - 12:00 PM)

### Scenario 3: New Feature Request

**Situation**: PM on Slack: "We need user profile photos ASAP"

```bash
# Step 1: Create feature branch
git checkout -b feature/user-profile-photos

# Step 2: Understand current system
claude "
I need to add user profile photo uploads.

Current system analysis:
1. How do we currently handle file uploads? (if at all)
2. What image storage do we use? (S3? Cloudinary? Local?)
3. Where is user data stored?
4. Show me similar features in the codebase

@CLAUDE.md
@src/models/User.js
@src/routes/
"

# Step 3: Clarifying questions
claude "
For profile photo feature:

Questions:
1. File size limits?
2. Allowed formats? (JPEG, PNG, GIF, WEBP?)
3. Resize/crop needed?
4. Default avatar if no photo?

Suggest technical approach based on our stack.
@CLAUDE.md
"

# Step 4: Create implementation plan
claude "
Create implementation plan for profile photos:

Checklist format:
- [ ] Database changes (if needed)
- [ ] Model updates
- [ ] API endpoints
- [ ] Service logic
- [ ] Validation
- [ ] Error handling
- [ ] Tests
- [ ] Documentation

Break down into small, testable steps.
@CLAUDE.md
"

# Step 5: Implement incrementally
claude "
Step 1: Add photo_url column to users table.

Generate migration file following our pattern:
@migrations/example_migration.sql

Don't run it yet, show me first.
"
# Review, then continue step-by-step...
```

**Time saved**: 30 minutes (vs figuring out patterns yourself)

---

### Scenario 4: Implementing Complex Logic

**Situation**: Need to implement photo upload with resize

```bash
claude "
Implement profile photo upload endpoint:

Requirements:
- POST /api/users/:id/photo
- Accept multipart/form-data
- Validate: max 5MB, only JPEG/PNG
- Resize to 200x200 thumbnail
- Upload to Cloudinary
- Update user.photo_url
- Return photo URL

Follow our patterns:
@src/routes/users.js (endpoint pattern)
@src/services/upload-service.js (file upload)
@CLAUDE.md

Steps:
1. Show me the endpoint (route level)
2. Show me the service logic
3. Show me validation middleware
4. Then I'll review before you implement tests

Don't implement everything at once.
"

# After reviewing route and service:
claude "
Now generate comprehensive tests:

@tests/routes/users.test.js (endpoint tests)
@tests/services/upload-service.test.js (service tests)

Cover:
- Happy path (valid upload)
- File too large (5MB+ rejection)
- Invalid format (reject .gif)
- Rate limit exceeded
- Cloudinary failure
- Database update failure

Pattern: @tests/example.test.js
"
```

**Time saved**: 1 hour (vs writing all this from scratch)

---

## Lunch: Code Review Time (12:00 PM - 1:00 PM)

### Scenario 5: Reviewing Teammate's PR

**Situation**: Teammate asks for code review on Slack

```bash
# 1. Check out their branch
git fetch origin
git checkout feature/payment-refactor

# 2. High-level overview
git diff main...HEAD --stat | claude "
Give me overview of this PR:

- What changed? (high level)
- How many files?
- What's the scope?
- Any red flags at first glance?
- Estimate review time needed

@CLAUDE.md
"

# 3. Detailed review
git diff main...HEAD | claude "
Comprehensive code review:

Check for:
🔴 Critical:
- Security issues (payment handling!)
- Data loss risks
- Breaking changes
- Race conditions

🟡 Important:
- Code quality
- Test coverage
- Error handling
- Performance issues

For each issue:
- Severity (Critical/High/Medium/Low)
- Location (file:line)
- Problem description
- Suggested fix

@CLAUDE.md code standards
"

# 4. Generate review comment
claude "
Generate PR review comment summarizing findings:

Format:
## Great Work ✅
- [Positive feedback]

## Critical Issues 🔴
- [Issue + suggested fix]

## Suggestions 🟡
- [Improvements]

## Nitpicks 💭
- [Minor style issues]

Be constructive and specific.
"
```

**Time saved**: 10 minutes (deeper review in less time)

---

## Afternoon: Bug Fixing (1:00 PM - 3:00 PM)

### Scenario 6: Production Bug Reported

**Situation**: User reports: "Checkout fails with Visa cards"

```bash
# 1. Check error logs
tail -n 100 logs/error.log | claude "
Production issue: Checkout fails with Visa cards

Error logs:
[paste error from logs]

Error: Invalid card number format
  at validateCard (src/utils/card-validator.js:23)
  at processPayment (src/services/payment.js:45)

Context:
- Started 2 hours ago
- User action: Enter Visa, click Pay
- Expected: Charge succeeds
- Actual: Validation error

Questions:
1. What's the root cause?
2. Why only Visa? (MasterCard works fine)
3. Recent changes that could cause this?
4. How to fix?

@src/utils/card-validator.js
@src/services/payment.js
"

# 2. Fix the bug
claude "
Fix the Visa validation regex:

Requirements:
- Accept 16-digit Visa cards
- Starts with 4
- Accept formats: XXXX-XXXX-XXXX-XXXX or XXXXXXXXXXXXXXXX
- Update tests to prevent regression

@src/utils/card-validator.js
@tests/card-validator.test.js

Show fix + new tests.
"

# 3. Verify fix
npm test -- card-validator.test.js
# ✅ All tests pass

# 4. Prevent future regressions
claude "
Generate comprehensive test cases for ALL card types:

Visa:
- Valid: 4242424242424242
- Valid with dashes: 4242-4242-4242-4242
- Invalid: 5555555555554444 (MasterCard number)
- Invalid: 424242 (too short)

MasterCard, Amex, Discover:
- [similar coverage]

Pattern: @tests/card-validator.test.js
"

# 5. Quick deploy (hotfix)
git add .
git commit -m "fix(payment): correct Visa card validation regex

- Fix regex to accept 16-digit Visa cards
- Add comprehensive card validation tests
- Resolves production issue affecting Visa users

Fixes #789"

git push origin hotfix/visa-validation
```

**Time saved**: 20 minutes (vs debugging manually)

---

### Scenario 7: Intermittent Test Failure

**Situation**: CI fails randomly, "flaky" test

```bash
npm test 2>&1 | claude "
Test fails intermittently:

Error:
  ✓ should create user (45ms)
  ✓ should update user (38ms)
  ✗ should delete user (timeout: 5000ms exceeded)

This test passes locally, fails in CI ~30% of the time.

Analyze:
@tests/user.test.js:deleteUser test

Possible causes:
- Race condition?
- Async issue (missing await)?
- Database not cleaned between tests?
- Timing issue?
- External dependency?

Show:
1. Root cause hypothesis
2. How to make test deterministic
3. Fix
"

claude "
Fix the flaky test:

Add proper async cleanup:
- Use beforeEach with await
- Ensure database fully reset
- Add timeout buffer if needed

@tests/user.test.js
@tests/setup.js

Show fixed test + setup.
"
```

**Time saved**: 30 minutes (flaky tests are hard to debug)

---

## Late Afternoon: Refactoring (3:00 PM - 5:00 PM)

### Scenario 8: Safe Refactoring

**Situation**: UserController.js has been bothering you for months

```bash
# 1. Safety net: Comprehensive tests FIRST
claude "
Generate comprehensive tests for CURRENT behavior:

@src/controllers/UserController.js

Cover:
- ALL public methods
- Edge cases
- Error cases

Goal: 100% confidence before refactoring.

I want tests that will FAIL if behavior changes.

Pattern: @tests/controllers/user-controller.test.js
"

# Review tests
# Run tests: npm test -- user-controller.test.js
# ✅ All pass

# 2. Refactoring plan
claude "
Refactor plan for @src/controllers/UserController.js

Current problems:
- 500 lines (too long!)
- Mixed concerns (validation + logic + DB)
- Duplicate code
- Hard to test

Proposed refactoring:
1. Extract validation → validators/user-validator.js
2. Extract business logic → services/user-service.js
3. Extract DB access → repositories/user-repository.js
4. Slim controller to orchestration only

Show before/after structure (no implementation yet).

@CLAUDE.md patterns
"

# 3. Incremental refactoring
claude "
Step 1: Extract validation logic.

Create: src/validators/user-validator.js

Move all validation from controller.
Keep controller exactly the same (just delegate to validator).

@src/controllers/UserController.js
@CLAUDE.md validation pattern
"

# Implement each step
# Run tests after EACH step: npm test -- user-controller.test.js
# ✅ Still pass

# 4. Final verification
npm test  # All tests
git diff  # Review ALL changes
npm run lint  # Code style
```

**Time saved**: 2 hours (systematic refactoring with confidence)

---

## End of Day: Cleanup & Planning (5:00 PM - 5:30 PM)

### Scenario 9: Daily Wrap-Up

**Situation**: Time to commit, create PR, plan tomorrow

```bash
# 1. Review today's work
git log --since="this morning" --author="your-email" --oneline | claude "
Summarize what I accomplished today:
- Completed features
- Bugs fixed
- Refactoring done
- Loose ends for tomorrow
"

# 2. Pre-commit review
git diff --cached | claude "
Pre-commit review:

Check for:
- Debug code (console.log, debugger)
- Commented-out code (delete it)
- TODO comments without tickets
- Hardcoded values (should be env vars)
- Secrets (API keys, passwords)
- Large files (assets that should be .gitignored)

Flag anything suspicious.

@CLAUDE.md commit standards
"

# Fix issues
git add -p  # Stage changes interactively

# 3. Generate commit message
git diff --cached | claude "
Generate conventional commit message:

Format: type(scope): description

Types: feat, fix, refactor, docs, test, chore

Include:
- What changed
- Why
- Breaking changes (if any)

Max 72 chars for first line.

@CLAUDE.md commit format
"

# 4. Generate PR description
claude "
Generate PR description for feature/user-profile-photos:

Template:
## What
[Summary of changes]

## Why
[Business reason]

## How to Test
[Step-by-step]

## Checklist
- [ ] Tests pass
- [ ] Linting passes
- [ ] Documentation updated
- [ ] No breaking changes

Based on commits: 
$(git log main..HEAD --oneline)

@CLAUDE.md PR template
"

# 5. Plan for tomorrow
claude "
Based on today's work, create tomorrow's plan:

Today I completed:
- Profile photo upload feature

Tomorrow I should:
1. [Incomplete items]
2. [Follow-up tasks]
3. [New priorities]

Priority order with time estimates.

@CLAUDE.md
"
```

**Time saved**: 15 minutes (organized wrap-up)

---

## Quick Reference: Daily Command Patterns

| Time of Day | Task | Command Pattern |
|------------|------|-----------------|
| **Morning** | Catch up | `git log --since="yesterday" \| claude "What changed?"` |
| **Morning** | Stand-up | `git log --author="me" \| claude "Generate standup summary"` |
| **Anytime** | Start feature | `claude "I need to implement [X]. Ask clarifying questions. @CLAUDE.md"` |
| **Anytime** | Debug | `[error output] \| claude "Root cause + fix"` |
| **Lunch** | Code review | `git diff main..PR \| claude "Review for: security, quality, performance"` |
| **Afternoon** | Refactor | `claude "Refactor @file. Generate tests FIRST. @CLAUDE.md"` |
| **End of day** | Commit | `git diff --cached \| claude "Generate conventional commit message"` |
| **End of day** | PR description | `claude "Generate PR description. Commits: $(git log main..HEAD)"` |
| **Emergency** | Production issue | `tail -n 200 error.log \| claude "🚨 URGENT: Diagnose + fix ASAP"` |

---

## Power User Tips

### Alias Common Commands

```bash
# .bashrc or .zshrc
alias cr='git diff | claude "Code review: security, quality, performance"'
alias analyze='npm test 2>&1 | claude "Analyze test results. Show failures + fixes."'
alias standup='git log --since="yesterday" --author="me" | claude "Generate standup summary"'
```

### Pre-Commit Hook

```bash
# .git/hooks/pre-commit
#!/bin/bash
git diff --cached | claude "
Check for:
- console.log / debugger
- Secrets
- TODOs without tickets

Exit 1 if found.
"
```

### Morning Routine Script

```bash
#!/bin/bash
# morning.sh

echo "🌅 Good morning! Catching up..."

git pull origin main
git log --since="yesterday" --oneline | claude "What's new?"
npm test | claude "Any test issues?"

echo "✅ Ready to code!"
```

---

## Next Steps

- **Master Prompting**: [Part 5: Prompt & Context Mastery](../../docs/05-prompt-context-mastery)
- **Learn Interactive Features**: [Part 2: Tools Mastery](../../docs/02-tools-mastery)
- **Understand Core Workflows**: [Core Workflows](04-core-workflows.md)

---

[← Back: Core Workflows](04-core-workflows.md) | [Next: Part 2 Tools Mastery →](../../docs/02-tools-mastery)

---
title: "Section 3b: Day-in-the-Life - Real Developer Workflows"
parent: "Part 1: Fundamentals & Core Concepts"
nav_order: 5
---

# Section 3b: Day-in-the-Life - Real Developer Workflows

This guide shows you **exactly** how to use Claude Code throughout your workday, from morning stand-up to end-of-day cleanup. Every scenario is real, practical, and copy-paste ready.

---

## Morning: Getting Started (8:00 AM - 9:00 AM)

### Scenario 1: Monday Morning Catch-Up

**Situation**: You return after the weekend. What happened while you were away?

```bash
# 1. Update local repository
git pull origin main
git status

# 2. Understand what changed
git log --since="Friday 5pm" --oneline --all | claude "
Summarize changes since Friday:
- What features were added?
- Any bug fixes?
- What do I need to know?
- Any breaking changes?

@CLAUDE.md
"

# Claude output:
# "3 major changes:
# 1. PR #234: Added role-based access control (BE AWARE: new middleware)
# 2. PR #235: Fixed payment timeout bug  
# 3. PR #236: Updated database schema (migration required!)
#
# Action items for you:
# - Run migrations: npm run migration:run
# - Test RBAC with different roles
# - Check if your feature branch needs rebase"

# 3. Check your branch status
git log main..feature/your-branch --oneline | claude "
I'm working on [feature name].
Based on main branch changes, do I need to:
- Rebase?
- Resolve conflicts?
- Update tests?
- Anything else?
"

# 4. Check test status
npm test 2>&1 | claude "
Any test failures?
If yes, are they related to weekend changes or my feature?
Quick diagnosis + fix recommendation.
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

# Claude generates:
# **Yesterday:**
# - Implemented user profile edit functionality
# - Added validation for profile fields
# - Created unit tests for profile service
#
# **Today:**
# - Add profile photo upload
# - Integration tests for profile API
# - Update documentation
#
# **Blockers:**
# - Waiting on design feedback for photo upload UI
```

**Time saved**: 5 minutes

---

## Mid-Morning: Feature Development (9:00 AM - 12:00 PM)

### Scenario 3: New Feature Request from PM

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

# Claude responds with current patterns

# Step 3: Clarifying questions
claude "
For profile photo feature:

Questions:
1. File size limits?
2. Allowed formats? (JPEG, PNG, GIF, WEBP?)
3. Resize/crop needed?
4. Default avatar if no photo?
5. Where in UI? (multiple places?)
6. Update existing user or new users only?
7. Delete old photo when uploading new?

Suggest technical approach based on our stack.

@CLAUDE.md
"

# Claude suggests approach with pros/cons

# Step 4: Create detailed plan
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
Show estimated time for each.

@CLAUDE.md
"

# Step 5: Implement incrementally
claude "
Step 1: Add photo_url column to users table.

Generate migration file following our pattern:
@migrations/example_migration.sql

Don't run it yet, show me first.
"

# Review migration
# Approve

claude "
Step 2: Update User model with photo_url field.

Follow pattern: @src/models/User.js
Include:
- Validation (URL format)
- Default value (null)
- Getter/setter if needed
"

# Continue step-by-step...
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

# Claude shows route
# You review: "Looks good, but add rate limiting"

claude "
Add rate limiting to photo upload:
- Max 10 uploads per hour per user
- Use our rate limiter: @src/middleware/rate-limit.js
"

# Claude updates route with rate limiting

claude "
Now show me the service logic for:
1. Image validation
2. Resize
3. Cloudinary upload
4. Database update
5. Error handling

@src/services/upload-service.js
"

# Review service logic
# Approve

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

# Claude: "Medium-sized PR, 8 files, refactoring payment service.
# Estimated review: 15 minutes. No obvious red flags."

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

# Claude finds issues:
# - Critical: API key exposed in logs (line 45)
# - High: No transaction handling (line 67)
# - Medium: Missing error logging (line 89)

# 4. Security-focused review
git diff main...HEAD | claude "
Security review for payment code:

Focus on:
- Secrets exposure
- SQL injection (if any raw queries)
- Input validation
- Error messages (no sensitive data leaked?)
- Logging (no card numbers/tokens?)
- Rate limiting
- Idempotency

@src/services/payment-service.js
@src/routes/payment.js

For each issue, show:
- Location
- Problem
- Specific code fix
"

# 5. Generate review comment
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

# Copy review to GitHub PR
```

**Time saved**: 10 minutes (deeper review in less time)

---

## Afternoon: Bug Fixing (1:00 PM - 3:00 PM)

### Scenario 6: Production Bug Reported

**Situation**: User reports: "Checkout fails with Visa cards"

```bash
# 1. Reproduce the issue
npm start
# Try checkout with Visa → ERROR

# 2. Check error logs
tail -n 100 logs/error.log | claude "
Production issue: Checkout fails with Visa cards

Error logs:
[paste error from logs]

Error: Invalid card number format
  at validateCard (src/utils/card-validator.js:23)
  at processPayment (src/services/payment.js:45)
  ...

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

# Claude identifies: "Visa regex was updated in commit abc123
# (2 hours ago). New regex is too strict."

# 3. Analyze the problematic code
claude "
Compare Visa validation with MasterCard validation:

Show both regexes:
@src/utils/card-validator.js

Explain:
- What's wrong with Visa regex?
- Why does MasterCard work?
- Correct regex for Visa (16 digits, starts with 4)

@CLAUDE.md
"

# Claude explains the issue

# 4. Fix the bug
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

# 5. Verify fix
npm test -- card-validator.test.js
# ✅ All tests pass

npm start
# Manual test: Visa card → ✅ Works!

# 6. Prevent future regressions
claude "
Generate comprehensive test cases for ALL card types:

Visa:
- Valid: 4242424242424242
- Valid with dashes: 4242-4242-4242-4242
- Invalid: 5555555555554444 (MasterCard number)
- Invalid: 424242 (too short)

MasterCard:
- Valid: 5555555555554444
- [more cases]

Amex:
- Valid: 378282246310005
- [more cases]

Discover:
- Valid: 6011111111111117
- [more cases]

Pattern: @tests/card-validator.test.js
"

# 7. Quick deploy (hotfix)
git add .
git commit -m "fix(payment): correct Visa card validation regex

- Fix regex to accept 16-digit Visa cards
- Add comprehensive card validation tests
- Resolves production issue affecting Visa users

Fixes #789"

git push origin hotfix/visa-validation

# Create PR, mark as HOTFIX
# Fast-track review and deploy
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

# Claude identifies: "Missing await on database cleanup.
# Test sometimes runs before previous test finishes cleanup."

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

### Scenario 8: That Ugly File Finally Gets Refactored

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

# Review plan
# Approve

# 3. Incremental refactoring
claude "
Step 1: Extract validation logic.

Create: src/validators/user-validator.js

Move all validation from controller.
Keep controller exactly the same (just delegate to validator).

@src/controllers/UserController.js
@CLAUDE.md validation pattern
"

# Implement
# Run tests: npm test -- user-controller.test.js
# ✅ Still pass

claude "
Step 2: Extract business logic.

Create: src/services/user-service.js

Move business logic from controller.
Controller just calls service.

@src/controllers/UserController.js
@CLAUDE.md service pattern
"

# Implement
# Run tests: npm test -- user-controller.test.js
# ✅ Still pass

claude "
Step 3: Extract database access.

Create: src/repositories/user-repository.js

Move all DB queries.
Service calls repository.

@CLAUDE.md repository pattern
"

# Implement
# Run tests: npm test -- user-controller.test.js
# ✅ Still pass

# 4. Final verification
npm test  # All tests
git diff  # Review ALL changes
npm run lint  # Code style

# 5. Document the new pattern
claude "
Update @CLAUDE.md with this refactoring:

Add to 'Code Patterns' section:

### Controller → Service → Repository Pattern

Explain:
- When to use
- How to structure
- Show example from UserController
- Benefits

This is now our standard pattern.
"
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

# Claude: "Found 3 console.log statements in payment.js.
# Remove before committing."

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

# Claude generates:
# feat(profile): add user photo upload
#
# - Add photo upload endpoint
# - Integrate with Cloudinary
# - Add image validation and resize
# - Include comprehensive tests
#
# Closes #456

# Copy and commit
git commit -F- << 'EOF'
feat(profile): add user photo upload

- Add photo upload endpoint
- Integrate with Cloudinary
- Add image validation and resize
- Include comprehensive tests

Closes #456
EOF

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

## Screenshots
[If applicable]

## Checklist
- [ ] Tests pass
- [ ] Linting passes
- [ ] Documentation updated
- [ ] No breaking changes

Based on commits: 
$(git log main..HEAD --oneline)

@CLAUDE.md PR template
"

# Copy to GitHub PR

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

# Claude suggests:
# Tomorrow (Dec 20):
# 1. Integration tests for photo upload (1h)
# 2. Update API documentation (30min)
# 3. Start profile edit UI (2h)
# 4. Code review for PR #245 (30min)

# Save to notes
echo "PLAN-2025-12-20.md" > notes/
```

**Time saved**: 15 minutes (organized wrap-up)

---

## "Oh Crap" Moments

### Scenario 10: Accidentally Committed Secret

**Situation**: You committed an API key 😱

```bash
# PANIC MODE

claude "
URGENT: I committed an API key!

Commit: abc123def456
File: config/api-keys.js
Key: STRIPE_SECRET_KEY

I need to:
1. Remove from git history (ALL branches)
2. Revoke the key
3. Prevent this in future

How do I fix this safely?
Don't make it worse!

@.gitignore
@CLAUDE.md
"

# Claude provides step-by-step:
# 1. Revoke key FIRST (show where)
# 2. Remove from history (BFG or filter-branch)
# 3. Force push (coordinate with team)
# 4. Add .env to .gitignore
# 5. Set up pre-commit hook

# Follow instructions carefully
```

---

### Scenario 11: Broke Tests on Main

**Situation**: Your PR was merged, now main is broken 😨

```bash
npm test 2>&1 | claude "
URGENT: Main branch broken after my PR merge.

PR: #456 (profile photos)
Tests failing:
[paste test output]

Options:
1. Revert my PR?
2. Fix forward?
3. Something else?

Need to unblock team ASAP.
Show:
- Quickest fix (time estimate)
- Safest fix (risk assessment)
- Recommendation

@CLAUDE.md incident response
"

# Claude analyzes and recommends fastest safe fix
```

---

### Scenario 12: Production Down

**Situation**: Production is down, on-call paging you

```bash
# Check production logs
kubectl logs -n production pod/app-xyz --tail=200 | claude "
🚨 PRODUCTION DOWN 🚨

Error logs:
[paste last 200 lines]

Context:
- Happened 5 minutes ago
- All requests failing
- Last deploy: 1 hour ago (PR #458)

URGENT questions:
1. What's failing?
2. Related to recent deploy?
3. Quick fix or rollback?
4. ETA to resolve?

I need answer in <2 minutes.

@CLAUDE.md production runbook
"

# Claude provides fast diagnosis:
# "Database connection pool exhausted.
# Caused by: Missing connection.release() in PR #458
# Quick fix: Rollback deploy
# Proper fix: Add connection.release() + redeploy
# ETA: Rollback in 2 min, proper fix in 30 min"

# Execute rollback
# Follow up with proper fix
```

---

## Weekly Workflows

### Scenario 13: Weekly Planning

**Every Monday morning:**

```bash
# Review last week
git log --since="1 week ago" --author="your-email" --oneline | claude "
Last week summary:

Metrics:
- Features completed
- Bugs fixed
- PRs reviewed
- Lines of code

Insights:
- What went well
- What was blocked
- What took longer than expected

@CLAUDE.md
"

# Plan this week
claude "
This week's sprint plan:

Tickets assigned to me:
- [List from Jira/Linear]

For each:
- Priority (High/Medium/Low)
- Estimated time
- Dependencies
- Recommended order

Generate day-by-day plan (Mon-Fri).
"
```

---

### Scenario 14: Weekly Cleanup

**Every Friday afternoon:**

```bash
# Cleanup branches
git branch | claude "
I have many local branches:
[paste list]

Current sprint branches:
- feature/profile-photos (needs PR)
- feature/notification-system (in progress)
- fix/email-bug (merged to main)

Which branches should I:
- Keep (in progress)
- Delete (merged)
- Archive (not needed)

Generate commands to clean up.
"

# Cleanup old files
claude "
Find and clean up:
- .log files
- .DS_Store
- node_modules (if duplicated)
- Temp files
- Old screenshots

Generate cleanup script.

Don't delete:
- .env files
- Important docs
- In-progress work
"
```

---

## Tips for Maximum Efficiency

### 🚀 Power User Tips

1. **Alias Common Commands**
```bash
# .bashrc or .zshrc
alias cr='git diff | claude "Code review: security, quality, performance"'
alias analyze='npm test 2>&1 | claude "Analyze test results. Show failures + fixes."'
alias standup='git log --since="yesterday" --author="me" | claude "Generate standup summary"'
```

2. **Pre-Commit Hook**
```bash
# .git/hooks/pre-commit
#!/bin/bash
git diff --cached | claude "
Check for:
- console.log
- debugger
- Secrets
- TODOs without tickets

Exit 1 if found.
"
```

3. **Morning Routine Script**
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

## Next Steps

- **Master Prompting**: [Prompt Engineering Patterns](../05-prompt-context-mastery/14-prompt-engineering)
- **Learn Interactive Features**: [Plan Mode & Context Rewind](../02-cli-mastery/04c-interactive-features)
- **Optimize Context**: [Context Management](../05-prompt-context-mastery/15-context-management)

---

[← Back: Core Workflows](03-core-workflows) | [Next: Part 2 CLI Mastery →](../../docs/02-cli-mastery)


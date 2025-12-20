---
title: "Section 15: Context Management & Cost Optimization"
parent: "Part 5: Prompt Engineering & Context Mastery"
nav_order: 2
---

# Section 15: Context Management & Cost Optimization

**What You'll Learn:**
- How to manage token budgets effectively
- Prompt caching strategies (90% cost reduction)
- Real cost examples with actual numbers
- Monthly budget planning by developer type
- Optimization techniques that actually work

**Time to read:** 25-30 minutes  
**Potential savings:** $50-500+ per month for teams

---

## Table of Contents

1. [Understanding Claude Code Costs](#understanding-claude-code-costs)
2. [Cost Optimization Strategies](#cost-optimization-strategies)
3. [Real-World Cost Examples](#real-world-cost-examples)
4. [Monthly Budget Planning](#monthly-budget-planning)
5. [Prompt Caching Deep Dive](#prompt-caching-deep-dive)
6. [Token Budget Management](#token-budget-management)
7. [Context Selection Strategies](#context-selection-strategies)
8. [Monitoring and Alerts](#monitoring-and-alerts)
9. [ROI Calculation](#roi-calculation)

---

## Understanding Claude Code Costs

### Pricing Structure (December 2025)

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Cached Input (per 1M tokens) |
|-------|----------------------|------------------------|------------------------------|
| **Haiku 4.5** | $0.25 | $1.25 | $0.025 (90% off) |
| **Sonnet 4.5** | $3.00 | $15.00 | $0.30 (90% off) |
| **Opus 4.1** | $15.00 | $75.00 | $1.50 (90% off) |

**Additional Pricing:**
- **Batch API**: 50% discount on all tokens (async processing)
- **Extended Thinking**: Counted as output tokens at output rates
- **Vision**: Same as text tokens (images converted to tokens)

**Note:** Prices subject to change. Check [console.anthropic.com/pricing](https://console.anthropic.com/pricing) for current rates.

### What Costs Money

**Every API call includes:**

1. **Input tokens:** Everything you send
   - Your prompt text
   - Attached file contents
   - CLAUDE.md (if present)
   - Conversation history
   - System instructions

2. **Output tokens:** Everything Claude generates
   - Response text
   - Code generation
   - Extended thinking tokens (if enabled)

3. **Cached tokens:** Repeated context (90% discount!)
   - CLAUDE.md automatically cached
   - Large file contents (>1024 tokens)
   - Repeated system instructions

### Cost Formula

```
Total Cost = (Input Tokens × Input Rate) 
           + (Output Tokens × Output Rate)
           + (Cached Tokens × Cache Rate)
           + (Extended Thinking × Output Rate)
```

### Example Cost Calculation

**Scenario:** Code review of PR with 500 lines changed

```
Input:
- Prompt: 100 tokens
- Git diff: 2,000 tokens
- CLAUDE.md: 1,000 tokens (cached after first use)
- Total: 3,100 tokens

Output:
- Review comments: 800 tokens

Using Sonnet 4.5:
- First message: (3,100 × $3/M) + (800 × $15/M) = $0.021
- Second message (cache hit): (100 + 2,000) × $3/M + 1,000 × $0.30/M + 800 × $15/M = $0.018
```

**Savings from caching: 14% on second message, more on subsequent ones**

---

## Cost Optimization Strategies

### Strategy 1: Create CLAUDE.md (90% Cost Reduction)

**Impact:** 💰💰💰💰💰 Highest  
**Effort:** ⚡ 5 minutes  
**Savings:** 70-90% on projects with multiple queries

**How it works:**
- Claude automatically caches CLAUDE.md contents
- Subsequent queries use cached version (90% cheaper)
- Cache valid for 5 minutes

**Example CLAUDE.md:**

```markdown
# Project: E-Commerce API

## Tech Stack
- Node.js 20 + Express
- TypeScript 5.3
- PostgreSQL 15 with Prisma
- Redis for caching
- AWS S3 for file storage

## Architecture
- RESTful API
- JWT authentication
- Role-based access control (admin, seller, buyer)
- Microservices pattern (auth, products, orders, payments)

## Database Schema
- users (id, email, password_hash, role, created_at)
- products (id, seller_id, name, price, inventory)
- orders (id, buyer_id, total, status, created_at)
- order_items (id, order_id, product_id, quantity, price)

## API Conventions
- Use async/await (no callbacks)
- Error handling via middleware
- All routes authenticated except /auth/login, /auth/register
- Response format: `{ success: boolean, data?: any, error?: string }`
- Pagination: `?page=1&limit=20`

## File Structure
- src/routes/ - API endpoints
- src/controllers/ - Business logic
- src/models/ - Database models
- src/middleware/ - Auth, validation, error handling
- src/utils/ - Helper functions
- tests/ - Jest tests

## Common Tasks
- Add new endpoint: Create route → controller → add tests
- Add database migration: `npx prisma migrate dev`
- Run tests: `npm test`
- Deploy: GitHub Actions auto-deploys main to staging

## Team Conventions
- Use conventional commits (feat:, fix:, refactor:)
- PRs require 1 approval + passing tests
- Code coverage must be >80%
- ESLint + Prettier for formatting
```

**Cost comparison (20 queries per day):**

```
WITHOUT CLAUDE.md:
- 20 queries × 1,000 token context = 20,000 tokens/day
- Monthly: 20K × 22 days = 440K tokens
- Cost: 440K × $3/M = $1.32/month (just for context!)

WITH CLAUDE.md (after first cache):
- First query: 1,000 tokens × $3/M = $0.003
- Next 19 queries: 1,000 × $0.30/M × 19 = $0.0057
- Monthly: 22 first + 418 cached = $0.19/month
- Savings: $1.13/month (85%)
```

**For a team of 10: $135/year saved just from CLAUDE.md!**

---

### Strategy 2: Use Appropriate Models (10x Cost Difference)

**Impact:** 💰💰💰💰 Very High  
**Effort:** ⚡ Change one flag  
**Savings:** 5-10x depending on task

**Decision matrix:**

| Task Type | Use This Model | Why |
|-----------|---------------|-----|
| Code formatting | Haiku 4.5 | 12x cheaper than Opus |
| Quick questions | Haiku 4.5 | Fast, cheap, accurate enough |
| Code review | Sonnet 4.5 | Good balance |
| Bug investigation | Sonnet 4.5 | Good reasoning |
| Architecture decisions | Opus 4.1 | Best reasoning |
| Complex refactoring | Opus 4.1 | Worth the cost |

**Cost comparison (same 1000 token input + 500 token output):**

```
Haiku 4.5:
(1000 × $0.25/M) + (500 × $1.25/M) = $0.000875

Sonnet 4.5:
(1000 × $3/M) + (500 × $15/M) = $0.0105
(12x more expensive)

Opus 4.1:
(1000 × $15/M) + (500 × $75/M) = $0.0525
(60x more expensive than Haiku!)
```

**Real example (daily workflow):**

```
Developer's day:
- 15 quick questions (Haiku): 15 × $0.001 = $0.015
- 5 code reviews (Sonnet): 5 × $0.01 = $0.05
- 1 architecture decision (Opus): 1 × $0.05 = $0.05
Total: $0.115/day

If everything used Opus:
- 21 queries × $0.05 = $1.05/day (9x more expensive!)
- Monthly difference: ($1.05 - $0.115) × 22 = $20.57
```

**Action:** Set default to Sonnet, use Haiku for simple tasks:
```bash
claude --config-set defaultModel claude-sonnet-4-5
```

---

### Strategy 3: Disable Extended Thinking by Default (2-3x Savings)

**Impact:** 💰💰💰 High  
**Effort:** ⚡ Instant  
**Savings:** 2-3x on tasks that don't need deep reasoning

**When extended thinking IS worth it:**
- ✅ Complex architecture decisions
- ✅ Multi-step debugging
- ✅ System design
- ✅ Security analysis
- ✅ Performance optimization planning

**When extended thinking is WASTE:**
- ❌ Code formatting
- ❌ Adding comments
- ❌ Simple refactoring
- ❌ Generating tests
- ❌ Quick questions

⚠️ **Anti-Pattern**: Enabling extended thinking by default for all queries  
✅ **Better**: Disable extended thinking by default, enable only for complex reasoning tasks  
💡 **Why**: Extended thinking adds 5-20 seconds latency and 2-4x cost. 80% of coding tasks don't benefit from it. Enable only for architecture, complex debugging, and system design.

**Cost comparison (2000 input, 1000 output):**

```
WITHOUT Extended Thinking (Sonnet):
(2000 × $3/M) + (1000 × $15/M) = $0.021

WITH Extended Thinking (5000 tokens):
(2000 × $3/M) + (5000 × $15/M) + (1000 × $15/M) = $0.096
(4.5x more expensive!)
```

**Real example:**

```
Task: "Add JSDoc comments to functions"

WITHOUT thinking: $0.01, 2 seconds
WITH thinking: $0.04, 5 seconds

Thinking provided zero benefit but 4x cost!
```

**Best practice:**
```bash
# Default: No thinking
claude "task"

# Explicit thinking for complex tasks only
claude --thinking=5000 "complex architectural decision"
```

---

### Strategy 4: Use Batch API for Async Work (50% Savings)

**Impact:** 💰💰💰💰 Very High  
**Effort:** ⚡⚡ Moderate  
**Savings:** 50% for async workloads

**When to use Batch API:**
- ✅ Processing 100+ files
- ✅ Generating documentation
- ✅ Code analysis (non-urgent)
- ✅ Test generation for entire codebase
- ✅ Refactoring many files

**When NOT to use:**
- ❌ Interactive development
- ❌ Urgent debugging
- ❌ Need immediate results

**Cost comparison (process 100 files):**

```
STANDARD API:
- 100 files × 2,000 tokens each = 200K tokens
- Cost: 200K × $3/M = $0.60

BATCH API:
- Same 200K tokens × 50% discount
- Cost: $0.30
- Savings: $0.30 (50%)
```

**Usage:**
```bash
# Create batch job
claude --batch input.jsonl --output=output.jsonl

# Check status
claude --batch-status job-id

# Get results (when complete)
claude --batch-results job-id > results.jsonl
```

**Monthly savings (weekly batch jobs):**

```
Weekly batch documentation generation:
- Standard: $5/week × 4 = $20/month
- Batch: $2.50/week × 4 = $10/month
- Annual savings: $120
```

---

### Strategy 5: Minimize Context Size (Variable Savings)

**Impact:** 💰💰💰 Medium-High  
**Effort:** ⚡⚡ Ongoing practice  
**Savings:** 30-70% depending on usage

**Anti-patterns (expensive):**

```bash
# ❌ Attach entire directory
claude "explain auth" @src/**/*.ts
# Sends 50+ files, 100K+ tokens

# ❌ Attach full conversation history
[Long conversation with 20 messages]
# Each message includes entire history
```

**Good patterns (cost-effective):**

```bash
# ✅ Specific files only
claude "explain auth" @src/auth/validate.ts @src/middleware/auth.ts
# Sends 2 files, 3K tokens

# ✅ Use codebase search first
claude "find auth validation code"
# Then read specific file
claude "explain lines 45-67 in src/auth/validate.ts"
```

**Cost comparison (finding specific function):**

```
ANTI-PATTERN:
- Read all 50 files in src/: 100,000 tokens
- Cost: 100K × $3/M = $0.30

GOOD PATTERN:
- Search: 1,000 tokens → $0.003
- Read specific file: 3,000 tokens → $0.009
- Total: $0.012
- Savings: $0.288 (96%!)
```

**Tips:**
- Use `@file` for specific files, not glob patterns
- Search first, then read specific sections
- Detach files after use (in VS Code Extension)
- Use CLAUDE.md for project-wide context

---

## Real-World Cost Examples

### Example 1: Light Individual Developer

**Profile:**
- Uses Claude Code 2-3 hours/day
- Primarily for code review and quick questions
- Occasional debugging sessions

**Daily usage:**
- 10 quick questions (Haiku): 10 × 2K tokens
- 5 code reviews (Sonnet): 5 × 10K tokens
- 2 debugging sessions (Sonnet): 2 × 20K tokens
- Total: ~100K tokens/day

**Monthly cost calculation:**

```
Haiku queries: 10/day × 22 days × 2K = 440K tokens
Cost: 440K × $0.375/M (avg input+output) = $0.17

Sonnet reviews: 5/day × 22 days × 10K = 1.1M tokens
Cost: 1.1M × $9/M (avg) = $9.90

Sonnet debugging: 2/day × 22 days × 20K = 880K tokens
Cost: 880K × $9/M = $7.92

Total: $18/month

WITH OPTIMIZATION:
- CLAUDE.md caching: -70% on Sonnet = $12.65
- Haiku by default: already optimized
- Total: ~$13/month

Optimized cost: $13/month
Unoptimized cost: $85/month (if using Opus for everything)
Savings: $72/month (85%)
```

---

### Example 2: Heavy User (AI-First Developer)

**Profile:**
- Uses Claude Code heavily (6+ hours/day)
- Pair programming with Claude
- Complex refactoring and architecture work

**Daily usage:**
- 30 quick interactions (Haiku): 60K tokens
- 15 code reviews (Sonnet): 150K tokens
- 5 complex tasks (Opus): 100K tokens
- 5 extended thinking sessions: 50K thinking tokens
- Total: ~360K tokens/day

**Monthly cost calculation:**

```
Haiku: 30 × 22 × 2K = 1.32M tokens
Cost: 1.32M × $0.375/M = $0.50

Sonnet: 15 × 22 × 10K = 3.3M tokens  
With 70% cached: 3.3M × $4.5/M = $14.85

Opus: 5 × 22 × 20K = 2.2M tokens
Cost: 2.2M × $45/M = $99.00

Extended thinking: 5 × 22 × 10K = 1.1M tokens
Cost: 1.1M × $15/M = $16.50

Total: $131/month

WITH FULL OPTIMIZATION:
- Use Sonnet instead of Opus where possible: -60%
- Limit extended thinking to truly complex tasks: -50%
- Aggressive caching and context management: -30%

Optimized cost: ~$45/month
Savings: $86/month
```

---

### Example 3: Team of 10 Developers

**Profile:**
- Mix of light (6), medium (3), heavy (1) users
- Shared CLAUDE.md and project context
- CI/CD automation

**Monthly usage breakdown:**

```
Light users (6 developers):
- 6 × $13/month = $78/month

Medium users (3 developers):
- 3 × $25/month = $75/month

Heavy user (1 developer):
- 1 × $45/month = $45/month

CI/CD automation:
- PR reviews: 50/week × 4 weeks × 10K tokens = 2M tokens
- Cost: 2M × $9/M = $18/month (Sonnet)
- Using Batch API: 50% discount = $9/month

Total team cost: $207/month optimized
($2,484/year)

WITHOUT OPTIMIZATION:
- If everyone used Opus: 10 × $85 = $850/month
- No caching: +30% = $1,105/month
- No Batch API: +$9 = $1,114/month

Annual savings: ($1,114 - $207) × 12 = $10,884/year
```

**ROI for team:**
- Cost: $2,484/year
- Time saved: 5 hours/week/developer × 50 weeks = 250 hours/year per dev
- Total: 2,500 hours/year for team
- Value at $100/hour: $250,000/year
- ROI: 100x return

---

## Monthly Budget Planning

### Setting Realistic Budgets

**By developer type:**

| Developer Type | Daily Use | Monthly Budget | Cost/Query |
|---------------|-----------|----------------|-----------|
| **Occasional** | 30 min | $5-10 | $0.01 |
| **Light** | 1-2 hours | $10-20 | $0.01 |
| **Medium** | 3-4 hours | $20-40 | $0.015 |
| **Heavy** | 5+ hours | $40-80 | $0.02 |
| **Power User** | All day | $80-150 | $0.025 |

**Budget allocation example (team of 10):**

```
Role-based budgets:
- Junior developers (4): $15/month each = $60
- Mid-level developers (4): $25/month each = $100  
- Senior developers (2): $50/month each = $100
- CI/CD automation: $20/month
- Buffer (20%): $56

Total budget: $336/month
Per developer average: $33.60/month
```

### Setting Budget Alerts

**CLI configuration:**
```bash
# Set personal monthly budget
claude --set-budget 50  # $50/month

# Alert at 80%
claude --alert-at 80

# Email notifications
claude --notify-email you@company.com

# Check current usage
claude --usage-stats --month=current
```

**VS Code Extension:**
```json
{
  "claudeCode.monthlyBudget": 50,
  "claudeCode.budgetAlertThreshold": 80,
  "claudeCode.showCostInResponse": true
}
```

### Monitoring Usage

**Daily check:**
```bash
claude --usage-today
```

**Weekly review:**
```bash
claude --usage-stats --week=current --detailed

# Example output:
# Week of Dec 18-24, 2025
# Total cost: $12.45
# Total queries: 347
# Avg cost/query: $0.036
# 
# By model:
# - Haiku: 180 queries, $0.85 (7%)
# - Sonnet: 152 queries, $9.60 (77%)
# - Opus: 15 queries, $2.00 (16%)
#
# Most expensive operations:
# 1. Extended thinking architecture: $0.85
# 2. Large file refactoring: $0.42
# 3. Full codebase analysis: $0.38
```

---

## Prompt Caching Deep Dive

### How Prompt Caching Works

**Cache lifecycle:**
```
Message 1:
┌────────────────────────────────────┐
│ CLAUDE.md (1000 tokens)           │ → Processed & Cached
│ + Your prompt (100 tokens)        │ → Processed
│ + Response (500 tokens)           │ → Generated
└────────────────────────────────────┘
Cost: (1100 × $3/M) + (500 × $15/M) = $0.0108

Message 2 (within 5 min):
┌────────────────────────────────────┐
│ CLAUDE.md (1000 tokens)           │ → FROM CACHE (90% off)
│ + Your prompt (100 tokens)        │ → Processed
│ + Response (500 tokens)           │ → Generated
└────────────────────────────────────┘
Cost: (1000 × $0.30/M) + (100 × $3/M) + (500 × $15/M) = $0.0083

Savings per message: $0.0025 (23%)
Over 100 messages: $0.25 saved
```

**Cache duration:** 5 minutes (refreshed on each use)

**What gets cached:**
- ✅ CLAUDE.md contents (automatic)
- ✅ Large file attachments (>1024 tokens)
- ✅ Repeated system instructions
- ✅ Conversation history (within same session)

**What doesn't get cached:**
- ❌ Small prompts (<1024 tokens)
- ❌ Content older than 5 minutes (no activity)
- ❌ Different file contents (even same filename)

⚠️ **Anti-Pattern**: Not using CLAUDE.md - repeating project context in every query  
✅ **Better**: Create CLAUDE.md with project info for automatic 90% cost savings via caching  
💡 **Why**: Without CLAUDE.md, every query re-sends the same context at full price. With CLAUDE.md, context is cached automatically, reducing costs by 90% on repeated queries.

### Optimizing Cache Hits

**Best practices:**

**1. Use CLAUDE.md for static context**
```markdown
# Put in CLAUDE.md (always cached):
- Project tech stack
- Architecture overview
- Coding conventions
- Common patterns

# Keep in prompts (varies per query):
- Specific question
- File references
- Error messages
```

**2. Batch related queries together**
```bash
# ✅ Good: Within 5 minutes
claude "review auth.ts"
# (30 seconds later)
claude "add tests for auth.ts"  # Cache hit!
# (1 minute later)
claude "document auth.ts"  # Cache hit!

# ❌ Bad: Spread over time
claude "review auth.ts"
# (10 minutes later - cache expired)
claude "add tests for auth.ts"  # Cache miss, full cost
```

**3. Structure large files strategically**
```bash
# If a file is referenced multiple times in a session:

# First reference: Full file (gets cached)
claude "explain src/api/users.ts"

# Later references: Use cache
claude "add pagination to users.ts"  # Cache hit
claude "add sorting to users.ts"  # Cache hit
```

**Cost savings example (10 queries on same project):**

```
WITHOUT cache-aware batching:
- 10 queries spread over day
- Each loads 1000 token CLAUDE.md
- Total: 10 × 1000 × $3/M = $0.03

WITH cache-aware batching:
- First query: 1000 × $3/M = $0.003
- Next 9 (cached): 9 × 1000 × $0.30/M = $0.0027
- Total: $0.0057

Savings: $0.0243 (81%)
Over a month: $0.50 saved
```

---

## Token Budget Management

### Understanding Token Counts

**Approximate token counts:**
- 1 token ≈ 4 characters (English)
- 1 token ≈ 0.75 words (English)
- 100 tokens ≈ 75 words
- 1000 tokens ≈ 750 words or ~30 lines of code

**Measuring tokens:**
```bash
# Count tokens in file
claude --count-tokens src/auth.ts

# Count tokens in string
echo "your text here" | claude --count-tokens

# Estimate before running
claude --dry-run "your prompt" @src/file.ts
```

### Token Budget Guidelines

**By task type:**

| Task | Input Budget | Output Budget | Extended Thinking |
|------|-------------|---------------|------------------|
| Quick question | 1K-2K | 200-500 | None |
| Code review | 5K-10K | 1K-2K | Optional (2K) |
| Bug investigation | 10K-20K | 2K-3K | 5K |
| Refactoring | 10K-30K | 5K-10K | 5K-10K |
| Architecture design | 20K-50K | 10K-20K | 10K-20K |

**Example: Budget-conscious code review**

```bash
# ❌ Expensive: Full file (5000 lines)
claude "review this" @src/huge-service.ts
# Input: 150K tokens = $0.45

# ✅ Cost-effective: Specific section
claude "review lines 234-456 in src/huge-service.ts"
# Input: 7K tokens = $0.021
# Savings: 95%
```

---

## Context Selection Strategies

### Strategy 1: Progressive Disclosure

**Start narrow, expand only if needed.**

```bash
# Step 1: High-level (fast, cheap)
claude "what does this project do?" @README.md @package.json
# 2K tokens, 2 seconds

# Step 2: If needed - specific area
claude "explain authentication flow" @src/auth/
# 10K tokens, 3 seconds

# Step 3: If needed - deep dive
claude "debug OAuth timeout" @src/auth/oauth.ts --include-logs
# 20K tokens, 5 seconds
```

**Cost comparison:**

```
All at once (anti-pattern):
- One query with entire src/: 200K tokens = $0.60

Progressive (smart pattern):
- Query 1: 2K = $0.006
- Query 2 (if needed): 10K = $0.03
- Query 3 (if needed): 20K = $0.06
- Most tasks stop at query 1-2
- Average cost: $0.036
- Savings: 94%
```

### Strategy 2: Use Codebase Search First

**Before reading files:**

```bash
# ❌ Expensive: Guess and read everything
claude "find JWT validation" @src/**/*.ts
# Reads 50+ files

# ✅ Cheap: Search first
claude "search codebase for JWT validation"
# Returns: "Found in src/auth/jwt.ts lines 45-67"

# Then read specific section
claude "explain lines 45-67 in src/auth/jwt.ts"
```

---

## Monitoring and Alerts

### Personal Monitoring

**Daily dashboard:**
```bash
#!/bin/bash
# Save as ~/bin/claude-daily-stats

echo "=== Claude Usage Today ==="
claude --usage-today

echo -e "\n=== Current Month ===" 
claude --usage-stats --month=current

echo -e "\n=== Budget Status ==="
claude --budget-status

echo -e "\n=== Most Expensive Operations ==="
claude --cost-report --today --top=5
```

**Weekly review script:**
```bash
#!/bin/bash
# Save as ~/bin/claude-weekly-review

echo "Week of $(date)"
claude --usage-stats --week=current --detailed

echo -e "\n=== Optimization Opportunities ==="
claude --analyze-usage --week=current | claude "suggest cost optimizations based on this usage data"
```

### Team Monitoring

**Team dashboard (requires API):**
```bash
# Get team usage
curl -H "Authorization: Bearer $ANTHROPIC_API_KEY" \
  https://api.anthropic.com/v1/usage/team/current-month

# Analyze in Claude
curl ... | claude "analyze team usage:
- Who's using most?
- What operations cost most?
- Optimization opportunities?
- Budget forecast for next month"
```

**Metrics to track:**
- Total spend vs budget
- Cost per developer
- Cost per query
- Cache hit rate
- Model distribution (% Haiku vs Sonnet vs Opus)
- Most expensive operations

---

## ROI Calculation

### Time Savings Value

**Typical time savings:**

| Task | Without Claude | With Claude | Time Saved |
|------|---------------|-------------|-----------|
| Code review | 30 min | 10 min | 20 min |
| Write tests | 45 min | 15 min | 30 min |
| Debug issue | 2 hours | 30 min | 90 min |
| Refactoring | 3 hours | 1 hour | 2 hours |
| Documentation | 1 hour | 20 min | 40 min |

**Monthly savings (medium user):**

```
Per week:
- 5 code reviews × 20 min = 100 min
- 10 test suites × 30 min = 300 min
- 2 debugging sessions × 90 min = 180 min
- 1 refactoring × 120 min = 120 min
- 3 documentation tasks × 40 min = 120 min

Total: 820 minutes/week = 13.7 hours/week
Monthly (4.33 weeks): 59 hours saved

Value at $100/hour: $5,900/month
Claude cost: $25/month
ROI: 236x return
```

### Team ROI

**Team of 10 developers:**

```
Monthly savings:
- 10 developers × 50 hours/month = 500 hours
- Value at $100/hour = $50,000/month

Cost:
- Claude Code: $250/month (team)
- Training time: 20 hours × $100 = $2,000 (one-time)

Monthly ROI: ($50,000 - $250) / $250 = 199x
Annual ROI: $600,000 / $3,000 = 200x

Payback period: < 1 week
```

### Beyond Direct Time Savings

**Additional value:**
- ✅ Fewer bugs (Claude catches issues in review)
- ✅ Better code quality (consistent patterns)
- ✅ Faster onboarding (Claude explains code)
- ✅ More documentation (lower barrier to create)
- ✅ Learning (developers learn from Claude's suggestions)

**Hard to quantify but real:**
- Reduced burnout (tedious tasks automated)
- Better work-life balance (less overtime debugging)
- Higher job satisfaction (more creative work)
- Competitive advantage (faster shipping)

---

## Cost Optimization Checklist

**Setup (one-time):**
- [ ] Create CLAUDE.md in all projects
- [ ] Set default model to Sonnet (not Opus)
- [ ] Disable extended thinking by default
- [ ] Configure budget alerts
- [ ] Install usage monitoring scripts

**Daily habits:**
- [ ] Use Haiku for simple tasks
- [ ] Attach only relevant files (not entire directories)
- [ ] Batch related queries together (within 5 min)
- [ ] Use codebase search before reading files
- [ ] Review daily costs: `claude --usage-today`

**Weekly review:**
- [ ] Check weekly spending
- [ ] Identify most expensive operations
- [ ] Adjust model selection if needed
- [ ] Update CLAUDE.md if project changed
- [ ] Share cost-saving tips with team

**Monthly optimization:**
- [ ] Review monthly costs vs budget
- [ ] Analyze cost per query trend
- [ ] Calculate ROI (time saved vs cost)
- [ ] Update budgets if needed
- [ ] Team cost review (if applicable)

---

## Summary

**Key takeaways:**

1. **CLAUDE.md is #1 optimization** → 70-90% savings
2. **Use appropriate models** → 10x cost difference
3. **Disable extended thinking by default** → 2-3x savings
4. **Batch API for async work** → 50% discount
5. **Context management matters** → 30-70% savings

**Expected costs (optimized):**
- Light user: $10-20/month
- Medium user: $20-40/month
- Heavy user: $40-80/month
- Team of 10: $200-400/month

**Typical ROI:** 50-200x return on investment

**Next steps:**
1. Create CLAUDE.md now (5 minutes)
2. Set budget alert
3. Use checklist above
4. Track savings over next month

---

[← Back: Prompt Engineering](14-prompt-engineering) | [Next: Multi-Model Strategies →](16-multi-model-strategies)

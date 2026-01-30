---
title: "Section 02: Context, Cost & Performance Optimization"
parent: "Part 5: Prompt Engineering & Context Mastery"
nav_order: 2
---

# Section 02: Context, Cost & Performance Optimization

**Complete guide to making Claude Code faster and cheaper**

**What You'll Learn:**
- Reduce costs by 70-90% with simple strategies
- Get 10-50x faster responses
- Real cost examples with actual numbers
- Performance optimization patterns that work

**Time to read:** 35 minutes  
**Potential savings:** $50-500+ per month

---

## Table of Contents

**Part A: Understanding Costs**
- [Pricing & Cost Formula](#pricing--cost-formula)
- [What Gets Cached](#what-gets-cached)

**Part B: Optimization Strategies**
- [Strategy 1: Create CLAUDE.md](#strategy-1-create-claudemd-90-cost-reduction)
- [Strategy 2: Smart Model Selection](#strategy-2-smart-model-selection-10x-difference)
- [Strategy 3: Disable Extended Thinking by Default](#strategy-3-disable-extended-thinking-by-default)
- [Strategy 4: Minimize Context Size](#strategy-4-minimize-context-size)
- [Strategy 5: Batch API for Async Work](#strategy-5-batch-api-for-async-work)

**Part C: Speed Optimization**
- [Parallel Tool Calls](#parallel-tool-calls)
- [Progressive Disclosure](#progressive-disclosure)
- [Streaming for Perceived Speed](#streaming-for-perceived-speed)

**Part D: Real-World Examples**
- [Cost Examples by Developer Type](#cost-examples-by-developer-type)
- [Performance Benchmarks](#performance-benchmarks)

**Part E: Monitoring & Planning**
- [Budget Planning](#budget-planning)
- [Performance Monitoring](#performance-monitoring)
- [ROI Calculation](#roi-calculation)

---

## Part A: Understanding Costs

### Pricing & Cost Formula

**Pricing (as of December 2025)**

> **Note:** Pricing may change. Always check [anthropic.com/pricing](https://www.anthropic.com/pricing) for current rates.

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Cached Input (90% off) |
|-------|----------------------|------------------------|------------------------|
| **Haiku 4.5** | $1.00 | $5.00 | $0.10 |
| **Sonnet 4.5** | $3.00 | $15.00 | $0.30 |
| **Opus 4.5** | $5.00 | $25.00 | $0.50 |

*Source: [Anthropic Pricing](https://www.anthropic.com/pricing) and [API Pricing](https://docs.claude.com/en/docs/about-claude/pricing).*

**Additional:**
- **Batch API**: 50% discount (async processing)
- **Extended Thinking**: Counted as output tokens
- **Vision**: Same as text tokens

**Cost Formula:**
```
Total = (Input Tokens × Input Rate) 
      + (Output Tokens × Output Rate)
      + (Cached Tokens × Cache Rate)
```

**What costs money:**
1. **Input tokens:** Your prompt + attached files + CLAUDE.md + history
2. **Output tokens:** Claude's response + extended thinking
3. **Cached tokens:** Repeated context (90% cheaper)

### What Gets Cached

**Automatically cached (within 5 minutes):**
- ✅ CLAUDE.md contents
- ✅ Large files (>1024 tokens)
- ✅ Repeated system instructions
- ✅ Conversation history

**Not cached:**
- ❌ Small prompts (<1024 tokens)
- ❌ Content older than 5 minutes
- ❌ Different content (even same filename)

**Cache lifecycle:**
```
Message 1: Process & cache CLAUDE.md (1000 tokens @ $3/M)
Message 2 (within 5 min): Use cache (1000 tokens @ $0.30/M)
Savings: 90% on cached content
```

---

## Part B: Optimization Strategies

### Strategy 1: Create CLAUDE.md (90% Cost Reduction)

**Impact:** 💰💰💰💰💰 Highest  
**Effort:** ⚡ 5 minutes  
**Savings:** 70-90% on projects with multiple queries

**Example CLAUDE.md:**

```markdown
# Project: E-Commerce API

## Tech Stack
- Node.js 20 + Express
- TypeScript 5.3
- PostgreSQL 15 with Prisma
- Redis for caching

## Architecture
- RESTful API
- JWT authentication
- Role-based access control (admin, seller, buyer)
- Microservices: auth, products, orders, payments

## Database Schema
- users (id, email, password_hash, role, created_at)
- products (id, seller_id, name, price, inventory)
- orders (id, buyer_id, total, status, created_at)
- order_items (id, order_id, product_id, quantity, price)

## API Conventions
- Use async/await (no callbacks)
- Error handling via middleware
- Response format: `{ success: boolean, data?: any, error?: string }`
- Pagination: `?page=1&limit=20`

## File Structure
- src/routes/ - API endpoints
- src/controllers/ - Business logic
- src/models/ - Database models
- src/middleware/ - Auth, validation, errors
- src/utils/ - Helpers
- tests/ - Jest tests

## Team Conventions
- Conventional commits (feat:, fix:, refactor:)
- PRs require 1 approval + passing tests
- Code coverage >80%
- ESLint + Prettier
```

**Cost comparison (20 queries/day):**

```
WITHOUT CLAUDE.md:
- 20 × 1,000 tokens/day = 20K tokens
- Monthly: 440K tokens × $3/M = $1.32/month

WITH CLAUDE.md (cached):
- First: 1,000 × $3/M = $0.003
- Next 19: 1,000 × $0.30/M × 19 = $0.0057
- Monthly: $0.19/month

Savings: $1.13/month (85%) per developer
Team of 10: $135/year saved!
```

---

### Strategy 2: Smart Model Selection (10x Difference)

**Impact:** 💰💰💰💰 Very High  
**Effort:** ⚡ Change one flag  
**Speedup:** 3-5x faster with Haiku

**Decision Matrix:**

| Task Type | Model | Why | Speed | Cost |
|-----------|-------|-----|-------|------|
| Code formatting | Haiku 4.5 | Sufficient | 5x faster | 60x cheaper |
| Quick questions | Haiku 4.5 | Fast, accurate | 3x faster | 12x cheaper |
| Code review (quick) | Haiku 4.5 | Catches obvious issues | 5x faster | 60x cheaper |
| Code review (deep) | Sonnet 4.5 | Better reasoning | Balanced | Balanced |
| Bug investigation | Sonnet 4.5 | Good analysis | Balanced | Balanced |
| Feature development | Sonnet 4.5 | Best default | Balanced | Balanced |
| Architecture decisions | Opus 4.5 | Complex reasoning | Slower | Expensive |
| Security audit (deep) | Opus 4.5 | Worth the cost | Slower | Expensive |

**Cost comparison (same 1000 input + 500 output):**

```
Haiku:   (1000 × $1/M) + (500 × $5/M) = $0.0035
Sonnet:  (1000 × $3/M) + (500 × $15/M) = $0.0105     (3x more)
Opus:    (1000 × $5/M) + (500 × $25/M) = $0.0175     (5x more)
```

**Daily workflow example:**

```
Developer's day:
- 15 quick questions (Haiku): $0.053
- 5 code reviews (Sonnet): $0.05
- 1 architecture decision (Opus 4.5): $0.0175
Total: $0.12/day = $2.60/month

If everything used Opus 4.5:
- 21 queries × $0.0175 = $0.37/day = $8/month
Monthly savings: $5.50 (69%)
```

**Set default model:**
```bash
claude --config-set defaultModel claude-sonnet-4-5
```

---

### Strategy 3: Disable Extended Thinking by Default

**Impact:** 💰💰💰 High (cost) + 🚀🚀🚀 High (speed)  
**Effort:** ⚡ Instant  
**Savings:** 2-4x faster, 2-3x cheaper

**When extended thinking helps:**
- ✅ Complex architecture decisions
- ✅ Multi-step debugging
- ✅ Trade-off analysis
- ✅ Security vulnerability analysis

**When it's wasteful:**
- ❌ Code formatting
- ❌ Adding comments
- ❌ Simple refactoring
- ❌ Generating tests
- ❌ Quick questions

**Cost & speed comparison:**

```
Task: "Add JSDoc comments"

WITHOUT thinking:
- Cost: $0.01
- Time: 2 seconds
- Quality: Excellent

WITH thinking (5000 tokens):
- Cost: $0.04 (4x more expensive)
- Time: 8 seconds (4x slower)
- Quality: Same
- Benefit: ZERO

Thinking added cost and latency with no benefit!
```

**Default approach:**
```bash
# Default: No thinking
claude "task"

# Explicit thinking for complex tasks only
claude "design microservices architecture" --thinking=5000
```

---

### Strategy 4: Minimize Context Size

**Impact:** 💰💰💰 High  
**Effort:** ⚡⚡ Ongoing practice  
**Savings:** 30-70% + much faster

**Anti-patterns:**

```bash
# ❌ Attach entire directory
claude "explain auth" @src/**/*.ts
# Sends 50+ files, 100K+ tokens, 40 seconds

# ❌ Send full conversation history
[20 messages in conversation]
# Each message includes entire history
```

**Good patterns:**

```bash
# ✅ Specific files only
claude "explain auth" @src/auth/validate.ts @src/middleware/auth.ts
# Sends 2 files, 3K tokens, 3 seconds

# ✅ Search first, then read specific sections
claude "find JWT validation code"
# Claude searches, identifies location
claude "explain lines 45-67 in src/auth/validate.ts"
# Only sends relevant section
```

**Cost comparison:**

```
ANTI-PATTERN (attach all):
- 100 files, 100K tokens
- Cost: $0.30
- Time: 40 seconds

GOOD PATTERN (search then read):
- Search: 1K tokens → $0.003
- Read specific: 3K tokens → $0.009
- Total: $0.012, 3 seconds

Savings: 96% cheaper, 13x faster
```

**Tips:**
- Use `@file` for specific files, not glob patterns
- Search first with codebase_search
- Use line ranges: `@file.ts:100-200`
- Detach files after use
- Put project context in CLAUDE.md

---

### Strategy 5: Batch API for Async Work

**Impact:** 💰💰💰💰 Very High  
**Effort:** ⚡⚡ Moderate  
**Savings:** 50% for async workloads

**When to use Batch API:**
- ✅ Processing 100+ files
- ✅ Generating documentation
- ✅ Code analysis (non-urgent)
- ✅ Test generation for entire codebase

**When NOT to use:**
- ❌ Interactive development
- ❌ Urgent debugging
- ❌ Need immediate results

**Cost comparison:**

```
Process 100 files:

STANDARD API:
- 100 × 2,000 tokens = 200K tokens
- Cost: 200K × $3/M = $0.60

BATCH API:
- Same 200K tokens × 50% discount
- Cost: $0.30
- Savings: $0.30 (50%)

Monthly (weekly batch jobs):
- Standard: $20/month
- Batch: $10/month
- Annual savings: $120
```

**Usage:**
```bash
# Create batch job
claude --batch input.jsonl --output=output.jsonl

# Check status
claude --batch-status job-id

# Get results
claude --batch-results job-id > results.jsonl
```

---

## Part C: Speed Optimization

### Parallel Tool Calls

**The Problem:** Sequential operations waste time

❌ **Slow: Sequential (10x latency)**
```bash
# Claude reads files one at a time
claude "analyze authentication"
# Internally:
# - Read login.ts (300ms)
# - Read jwt.ts (300ms)
# - Read session.ts (300ms)
# Total: 900ms
```

✅ **Fast: Parallel (1x latency)**
```bash
# Provide all files upfront
claude "analyze authentication" \
  @src/auth/login.ts \
  @src/auth/jwt.ts \
  @src/auth/session.ts
# Claude reads all in parallel: 300ms
# Speedup: 3x faster
```

**How to encourage parallelism:**
```bash
# Good: All context upfront
claude "compare implementations" @v1.ts @v2.ts @v3.ts

# Less optimal: Sequential questions
claude "show v1"
claude "show v2"
claude "compare them"
```

---

### Progressive Disclosure

**The Problem:** Loading too much context upfront

❌ **Slow: Everything at once**
```bash
claude "analyze project" @src/**/*.ts
# 100+ files, 200K tokens, 20+ seconds
# Claude overwhelmed, you wait
```

✅ **Fast: Start narrow, expand as needed**
```bash
# Step 1: High-level (2s)
claude "what does this do?" @README.md @package.json

# Step 2: Specific area (3s)
claude "explain auth flow" @src/auth/

# Step 3: Deep dive if needed (3s)
claude "how does OAuth refresh work?" @src/auth/oauth.ts

# Total: 8s with flexibility
# vs 20s upfront
```

**When to use:**
- ✅ Exploring unfamiliar codebases
- ✅ Debugging (start with error)
- ✅ Learning flows
- ❌ One-shot operations
- ❌ Batch processing

---

### Streaming for Perceived Speed

**Streaming** = See tokens as generated  
**Non-streaming** = Wait for complete response

```bash
# Streaming (default, feels 50-80% faster)
claude "explain codebase"
# ✅ See response immediately
# ✅ Can interrupt if wrong direction
# ✅ Better UX

# Non-streaming
claude "explain codebase" --no-stream
# ❌ Wait for entire response
# ❌ No feedback until complete
```

**When to disable streaming:**
- Piping to other commands
- Saving to files
- Parsing structured output (JSON)
- Automated scripts

**Example:**
```bash
# Interactive: Use streaming
claude "review code"

# Automation: Disable streaming
claude "generate JSON" --no-stream > output.json
```

---

## Part D: Real-World Examples

### Cost Examples by Developer Type

#### Example 1: Light User ($13/month)

**Profile:**
- Uses Claude 2-3 hours/day
- Code review and quick questions
- Occasional debugging

**Daily usage:**
- 10 quick questions (Haiku): 20K tokens
- 5 code reviews (Sonnet): 50K tokens
- 2 debugging sessions (Sonnet): 40K tokens
- Total: ~100K tokens/day

**Monthly cost (optimized):**
```
Haiku: 220K tokens × $0.375/M = $0.08
Sonnet (70% cached): 1.98M tokens × $4.5/M = $8.91
Extended thinking: 440K × $15/M = $6.60

Total: $13/month

WITHOUT optimization:
- All on Opus: $85/month
- Savings: $72/month (85%)
```

---

#### Example 2: Heavy User ($45/month)

**Profile:**
- Uses Claude 6+ hours/day
- Pair programming
- Complex refactoring

**Daily usage:**
- 30 quick interactions (Haiku): 60K tokens
- 15 code reviews (Sonnet): 150K tokens
- 5 complex tasks (Opus): 100K tokens
- 5 extended thinking sessions: 50K tokens

**Monthly cost (optimized):**
```
Haiku: 1.32M × $0.375/M = $0.50
Sonnet (70% cached): 3.3M × $4.5/M = $14.85
Opus: 2.2M × $45/M = $99.00
Extended thinking: 1.1M × $15/M = $16.50

Total: $131/month

WITH optimization:
- Use Sonnet instead of Opus: -60%
- Limit extended thinking: -50%
- Aggressive caching: -30%

Optimized: $45/month
Savings: $86/month
```

---

#### Example 3: Team of 10 ($207/month)

**Monthly breakdown:**
```
Light users (6): 6 × $13 = $78
Medium users (3): 3 × $25 = $75
Heavy user (1): 1 × $45 = $45
CI/CD (Batch API): $9

Team total: $207/month ($2,484/year)

WITHOUT optimization:
- All on Opus: $850/month
- No caching: +30%
- No Batch API: +$9
Unoptimized: $1,114/month

Annual savings: $10,884/year
```

**Team ROI:**
```
Cost: $2,484/year
Time saved: 250 hours/year per dev
Total: 2,500 hours/year
Value @ $100/hour: $250,000/year
ROI: 100x return
```

---

### Performance Benchmarks

#### Benchmark 1: Code Review

**Task:** Review git diff (500 lines)

**Unoptimized:**
```bash
git diff | claude "review all" --model="opus-4.1"
Time: 45 seconds
Cost: $0.25
```

**Optimized:**
```bash
git diff | claude "review critical issues" --model="haiku-4.5"
Time: 8 seconds
Cost: $0.004
Speedup: 5.6x faster
Savings: 98% cheaper
```

---

#### Benchmark 2: Debugging Session

**Task:** Fix TypeError in production

**Unoptimized:**
```bash
claude "fix error: [trace]" @src/**/*.ts
Context: 100 files, 50K lines
Time: 40 seconds
Cost: $0.45
```

**Optimized (progressive):**
```bash
# Step 1: Identify (3s)
claude "what causes: [stack trace]"
# → "Likely auth middleware line 234"

# Step 2: Examine (2s)
claude "show auth.ts:220-250"

# Step 3: Fix (3s)
claude "fix null reference in auth"

Total: 8 seconds, $0.08
Speedup: 5x faster
Savings: 82% cheaper
```

---

#### Benchmark 3: Batch Operations

**Task:** Add types to 50 JavaScript files

**Unoptimized (sequential):**
```bash
for file in src/**/*.js; do
  claude "add types" @$file
done
Time: 250 seconds
Cost: $2.50
```

**Optimized (parallel + model + batch):**
```bash
for file in src/**/*.js; do
  claude "add types" @$file --model="haiku-4.5"
done &
# Parallel with Haiku
Time: 10 seconds
Cost: $0.20
Speedup: 25x faster
Savings: 92% cheaper
```

**Even better (Batch API):**
```bash
claude-batch "add types" @src/**/*.js --model="haiku-4.5"
Time: ~15s (async, don't wait)
Cost: $0.10 (50% batch discount)
Savings: 96% cheaper
```

---

## Part E: Monitoring & Planning

### Budget Planning

**By developer type:**

| Type | Daily Use | Monthly Budget | Queries/Day |
|------|-----------|----------------|-------------|
| Occasional | 30 min | $5-10 | 10-20 |
| Light | 1-2 hours | $10-20 | 20-30 |
| Medium | 3-4 hours | $20-40 | 40-60 |
| Heavy | 5+ hours | $40-80 | 80-120 |
| Power User | All day | $80-150 | 150+ |

**Team budget allocation (10 developers):**
```
Junior (4): $15/month × 4 = $60
Mid-level (4): $25/month × 4 = $100
Senior (2): $50/month × 2 = $100
CI/CD automation: $20/month
Buffer (20%): $56

Total: $336/month
Per dev average: $33.60/month
```

**Set budget alerts:**
```bash
# Personal budget
claude --set-budget 50  # $50/month
claude --alert-at 80    # Warn at 80%

# Check usage
claude --usage-stats --month=current
```

---

### Performance Monitoring

**Daily check:**
```bash
claude --usage-today
```

**Weekly review:**
```bash
claude --usage-stats --week=current --detailed

# Example output:
# Week of Dec 18-24, 2025
# Total: $12.45, 347 queries
# Avg: $0.036/query
#
# By model:
# - Haiku: 180 queries, $0.85 (7%)
# - Sonnet: 152 queries, $9.60 (77%)
# - Opus: 15 queries, $2.00 (16%)
#
# Most expensive:
# 1. Architecture design: $0.85
# 2. Large refactoring: $0.42
# 3. Codebase analysis: $0.38
```

**Performance tracking:**
```bash
# Time operations
time claude "your query"

# Track tokens
claude "query" --verbose
# Shows: input, output, cached tokens, cost
```

**Set performance budgets:**
```bash
# Simple queries: < 2s
# Code reviews: < 5s
# Complex analysis: < 10s
# Batch jobs: Async (don't wait)
```

---

### ROI Calculation

**Time savings value:**

| Task | Without Claude | With Claude | Time Saved |
|------|---------------|-------------|-----------|
| Code review | 30 min | 10 min | 20 min |
| Write tests | 45 min | 15 min | 30 min |
| Debug issue | 2 hours | 30 min | 90 min |
| Refactoring | 3 hours | 1 hour | 2 hours |
| Documentation | 1 hour | 20 min | 40 min |

**Monthly ROI (medium user):**
```
Weekly savings:
- 5 reviews × 20 min = 100 min
- 10 test suites × 30 min = 300 min
- 2 debugging × 90 min = 180 min
- 1 refactoring × 120 min = 120 min
- 3 docs × 40 min = 120 min

Total: 820 min/week = 13.7 hours/week
Monthly: 59 hours saved

Value @ $100/hour: $5,900/month
Claude cost: $25/month
ROI: 236x return
```

**Team ROI (10 developers):**
```
Monthly savings: 500 hours
Value @ $100/hour: $50,000/month

Cost: $250/month
Monthly ROI: 199x
Annual ROI: $600,000 / $3,000 = 200x
Payback period: < 1 week
```

---

## Optimization Checklist

### Setup (One-Time)
- [ ] Create CLAUDE.md in all projects
- [ ] Set default model to Sonnet
- [ ] Disable extended thinking by default
- [ ] Configure budget alerts
- [ ] Install usage monitoring

### Daily Habits
- [ ] Use Haiku for simple tasks
- [ ] Attach only relevant files
- [ ] Batch queries within 5 minutes (caching)
- [ ] Search before reading files
- [ ] Check: `claude --usage-today`

### Weekly Review
- [ ] Check weekly spending
- [ ] Identify expensive operations
- [ ] Adjust model selection
- [ ] Update CLAUDE.md if needed
- [ ] Share tips with team

### Monthly Optimization
- [ ] Review costs vs budget
- [ ] Analyze cost/query trend
- [ ] Calculate ROI
- [ ] Update budgets
- [ ] Team cost review

---

## Summary

**Key Optimizations:**

1. **CLAUDE.md** → 70-90% cost savings (automatic caching)
2. **Smart model selection** → 10x cost difference, 3-5x speed
3. **Disable extended thinking** → 2-4x faster, 2-3x cheaper
4. **Minimize context** → 30-70% savings, much faster
5. **Batch API** → 50% discount for async work
6. **Parallel operations** → 10x faster for multi-file tasks
7. **Progressive disclosure** → Start fast, expand as needed
8. **Streaming** → 50-80% better perceived speed

**Expected Results:**
- **Cost:** Light user $10-20/month, Heavy user $40-80/month
- **Speed:** 10-50x faster with all optimizations
- **ROI:** 50-200x return on investment

**Quick Wins (Implement Today):**
- [ ] Create CLAUDE.md (5 minutes) → instant caching
- [ ] Use `--model="haiku-4.5"` for simple tasks → 5x faster
- [ ] Remove extended thinking from defaults → 2-4x faster
- [ ] Use file line ranges instead of full files → 90%+ savings

---

[← Back: Prompt Engineering](01-prompt-engineering.md) | [Next: Part 6 →](../../06-advanced-patterns-techniques/)


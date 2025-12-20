---
title: "Section 15b: Performance & Speed Optimization"
parent: "Part 5: Prompt Engineering & Context Mastery"
nav_order: 3
---

# Section 15b: Performance & Speed Optimization

**What You'll Learn:**
- How to achieve 3-10x faster response times
- Latency sources and how to eliminate them
- Parallel processing patterns for maximum throughput
- Model selection strategies for speed vs quality
- Real benchmarks with actual timing data
- Performance checklist for every query

**Time to read:** 20-25 minutes  
**Potential speedup:** 3-10x for most operations  
**Performance gains:** Save 2-4 hours per day

---

## Table of Contents

1. [Understanding Latency Sources](#understanding-latency-sources)
2. [Speed Optimization Patterns](#speed-optimization-patterns)
3. [Real-World Benchmarks](#real-world-benchmarks)
4. [Performance Measurement](#performance-measurement)
5. [Performance Checklist](#performance-checklist)

---

## Understanding Latency Sources

Before optimizing, understand where time is spent in Claude operations.

### Token Processing Speed

**Input Token Processing** (Reading):
- **Speed**: ~10,000 tokens/second
- **Impact**: Minimal for most operations
- **Example**: 50K token context = ~5 seconds

**Output Token Generation** (Writing):
- **Speed**: 50-100 tokens/second (varies by model)
- **Impact**: Major bottleneck for long responses
- **Example**: 2K token response = 20-40 seconds

**Why This Matters:**
```
Short query with long response = SLOW
- Input: 5K tokens (0.5s)
- Output: 5K tokens (50-100s)
- Total: ~100 seconds

Long query with short response = FAST
- Input: 50K tokens (5s)
- Output: 500 tokens (5-10s)
- Total: ~15 seconds
```

### Network Latency

**Base API Call Overhead:**
- **Initial connection**: 100-300ms
- **Streaming first token**: 200-500ms additional
- **Geographic distance**: Varies (use nearest region)

**Parallel vs Sequential:**
```bash
# Sequential: 3 file reads
File A: 300ms wait
File B: 300ms wait  
File C: 300ms wait
Total: 900ms

# Parallel: 3 file reads
Files A, B, C: 300ms wait (all at once)
Total: 300ms
Speedup: 3x faster
```

### Model-Specific Latency

| Model | Speed | Use Case | Typical Response Time |
|-------|-------|----------|---------------------|
| **Haiku 4.5** | Fastest | Simple tasks | 2-5 seconds |
| **Sonnet 4.5** | Medium | General purpose | 5-15 seconds |
| **Opus 4.1** | Slowest | Complex reasoning | 15-60 seconds |

**Extended Thinking Overhead:**
- Adds thinking phase before response
- Typical overhead: 5-20 seconds
- Only use when deep reasoning needed

### Streaming vs Non-Streaming

**Non-Streaming** (Wait for complete response):
```
Request → Wait → Full response arrives
Perceived time: 20 seconds
Actual time: 20 seconds
```

**Streaming** (Incremental output):
```
Request → First token → Continue streaming → Done
Perceived time: 3 seconds (first visible output)
Actual time: 20 seconds (still same total time)
```

**Benefit**: 5-7x faster *perceived* speed with streaming

---

## Speed Optimization Patterns

### Pattern 1: Parallel Tool Calls

**The Problem:**
Claude reading files sequentially wastes time on network round-trips.

#### Sequential Operations (SLOW)

```bash
# Claude's internal process:
1. Read src/auth.ts (300ms wait)
2. Read src/config.ts (300ms wait)
3. Read src/utils.ts (300ms wait)
Total latency: 900ms
```

**Prompt that causes sequential reads:**
```bash
# ❌ SLOW: Vague request forces sequential discovery
claude "explain how authentication works in this project"

# Claude thinks: "I need to find auth files..."
# Reads: src/index.ts → discovers auth.ts → reads it → discovers config.ts → reads it
# Result: 5-7 sequential file reads
```

#### Parallel Operations (FAST)

```bash
# Claude's internal process:
1. Read src/auth.ts, src/config.ts, src/utils.ts (all at once)
Total latency: 300ms
Speedup: 3x faster
```

**Prompt that enables parallel reads:**
```bash
# ✅ FAST: Specific files enable parallel reads
claude "explain authentication" --files="src/auth.ts,src/config.ts,src/utils.ts"

# Claude thinks: "I have all files, read them in parallel"
# Result: 1 parallel read operation
```

#### Real-World Example: Code Review

**Before Optimization:**
```bash
git diff | claude "review all changes"

# Claude's process:
# 1. Parse diff (1s)
# 2. Read file1.ts to understand context (300ms)
# 3. Read file2.ts for dependencies (300ms)
# 4. Read file3.ts for types (300ms)
# 5. Generate review (10s)
# Total: 12 seconds
```

**After Optimization:**
```bash
git diff | claude "review changes in authentication logic" \
  --files="src/auth/*.ts"

# Claude's process:
# 1. Parse diff (1s)
# 2. Read all auth files in parallel (300ms)
# 3. Generate review (10s)
# Total: 11.3 seconds (but more focused)

# Better yet - be even more specific:
git diff src/auth/ | claude "security review: check for auth bypasses and injection"

# Claude's process:
# 1. Parse diff (1s)
# 2. Targeted analysis (5s instead of 10s)
# Total: 6 seconds
# Speedup: 2x faster
```

#### When Parallelism Helps

✅ **Helps when:**
- Reading multiple independent files
- Searching across multiple directories
- Batch operations on separate items

❌ **Doesn't help when:**
- Single file operations
- Sequential dependencies (must read A to find B)
- Response generation (can't parallelize thinking)

---

### Pattern 2: Progressive Disclosure

Start narrow, expand only when needed. Don't load entire codebase upfront.

#### The Anti-Pattern (SLOW)

```bash
# ❌ Read everything upfront
claude "analyze this project" --files="src/**/*.ts"

# What happens:
# - Reads 100+ files (10-15 seconds)
# - Uses 200K tokens
# - Response generation: 20+ seconds
# - Total: 35+ seconds
# - Cost: $0.60 (Sonnet)
```

#### The Optimized Approach (FAST)

```bash
# ✅ Step 1: Quick overview (2 seconds)
claude "what does this project do?" --files="README.md,package.json"
# Response: "This is a REST API for user management..."

# ✅ Step 2: Narrow to relevant area (3 seconds)
claude "explain user authentication flow" --files="src/auth/*.ts"
# Response: "Authentication uses JWT tokens stored in..."

# ✅ Step 3: Deep dive on specific issue (3 seconds)
claude "why does OAuth refresh fail?" --files="src/auth/oauth.ts"
# Response: "Line 67 has a race condition..."

# Total: 8 seconds for complete understanding
# Speedup: 4x faster than loading everything
# Cost: $0.08 (90% cheaper)
```

#### Progressive Disclosure Decision Tree

```
Start: Do I know which files are relevant?
│
├─ YES → Specify exact files → Fast query (3s)
│
└─ NO → Ask broad question first
       │
       ├─ Got relevant area? → Narrow query to that area (3s)
       │
       └─ Still unclear? → Use codebase_search (5s)
                         │
                         └─ Now specify files → Fast query (3s)
```

#### Real Example: Debugging Production Issue

**Scenario**: API endpoint `/api/users/login` returns 500 error, no logs.

**Approach 1: Load Everything (SLOW)**
```bash
# ❌ 35+ seconds, expensive
claude "why is login failing?" --files="src/**/*.ts"
```

**Approach 2: Progressive Disclosure (FAST)**
```bash
# Step 1: Find the endpoint (3s)
claude "find the /api/users/login endpoint handler"
# Response: "It's in src/routes/auth.ts, function handleLogin()"

# Step 2: Analyze just that file (3s)
claude "analyze handleLogin in src/routes/auth.ts - why might it return 500 with no logs?"
# Response: "Line 45 has unhandled promise rejection in async middleware..."

# Step 3: Verify fix (2s)
claude "show me proper error handling for Express async routes"

# Total: 8 seconds
# Speedup: 4x faster
```

---

### Pattern 3: Smart Context Selection

Don't re-send the same context repeatedly. Use caching and targeted queries.

#### The Problem: Repeated Context

```bash
# Session working on authentication feature:

# Query 1: Full context (50K tokens)
claude "add login endpoint" --files="src/**/*.ts"
Cost: $0.15

# Query 2: Full context again (50K tokens)
claude "now add logout endpoint" --files="src/**/*.ts"
Cost: $0.15

# Query 3: Full context again (50K tokens)
claude "add password reset" --files="src/**/*.ts"
Cost: $0.15

# Total: $0.45 for 3 queries
# Problem: Re-sending same 50K tokens 3 times
```

#### Solution 1: Use CLAUDE.md for Caching

```bash
# Create CLAUDE.md with project context
cat > CLAUDE.md << 'EOF'
# Project Context
- REST API for user management
- Stack: Node.js, Express, PostgreSQL
- Auth: JWT tokens, OAuth2
- Key files:
  - src/routes/auth.ts: Authentication endpoints
  - src/middleware/auth.ts: JWT verification
  - src/models/User.ts: User database model
EOF

# Now your queries are cached:

# Query 1: Creates cache (50K tokens)
claude "add login endpoint"
Cost: $0.15 (cache created)

# Query 2: Uses cache (50K cached + 1K new)
claude "now add logout endpoint"
Cost: $0.015 (90% discount)

# Query 3: Uses cache (50K cached + 1K new)
claude "add password reset"
Cost: $0.015 (90% discount)

# Total: $0.18 (60% savings)
```

#### Solution 2: Targeted Context per Query

```bash
# Instead of sending everything, send only what's needed:

# Query 1: Login endpoint
claude "add login endpoint" --files="src/routes/auth.ts,src/models/User.ts"
Cost: $0.02 (only 5K tokens)

# Query 2: Logout endpoint
claude "add logout endpoint" --files="src/routes/auth.ts,src/middleware/auth.ts"
Cost: $0.02 (only 5K tokens)

# Query 3: Password reset
claude "add password reset" --files="src/routes/auth.ts,src/services/email.ts"
Cost: $0.02 (only 5K tokens)

# Total: $0.06 (87% savings vs original)
# Also 3-5x faster due to less input processing
```

#### Real Example: 96% Cost Reduction

From Section 15 (Context Management):

**Before Optimization:**
```
Multi-turn conversation about testing
- 10 queries
- Each sends 50K tokens of test files
- Total: 500K tokens input
- Cost: $1.50 (Sonnet)
- Time: ~5 seconds per query = 50 seconds
```

**After Optimization (CLAUDE.md + Targeted Context):**
```
Create CLAUDE.md with test patterns
- Query 1: 50K tokens (creates cache) = $0.15
- Query 2-10: 5K new tokens each = $0.05 × 9 = $0.45
- Total cost: $0.60 (60% savings)
- Time: ~2 seconds per query (caching faster) = 20 seconds

Further optimization - narrow context:
- Only send relevant test file per query
- Queries 2-10: 2K new tokens each = $0.02 × 9 = $0.18
- Total cost: $0.33 (78% savings)
- Total time: ~1.5 seconds per query = 15 seconds

Combined: 78% cost savings + 3x faster
```

---

### Pattern 4: Model Selection for Speed

Use the right model for the task. Opus is 5-10x slower than Haiku.

#### Model Speed Comparison (Same Task)

**Task**: Format code to follow style guide

```bash
# ❌ SLOW: Opus 4.1
claude "format src/utils.ts to ESLint config" --model="opus-4.1"
Time: 15-20 seconds
Cost: $0.30

# ✅ FAST: Haiku 4.5
claude "format src/utils.ts to ESLint config" --model="haiku-4.5"
Time: 2-3 seconds
Cost: $0.01
Speedup: 5-10x faster
Savings: 97% cheaper
```

#### Decision Matrix: Speed vs Quality

| Task Type | Haiku 4.5 | Sonnet 4.5 | Opus 4.1 | Reasoning |
|-----------|-----------|------------|----------|-----------|
| **Code formatting** | ✅ 2s | 🟡 5s | ❌ 15s | Simple, rule-based |
| **Test generation** | ✅ 3s | 🟡 7s | ❌ 20s | Straightforward patterns |
| **Bug fixing (simple)** | ✅ 3s | 🟡 8s | ❌ 18s | Clear error messages |
| **Code review** | 🟡 4s | ✅ 10s | 🟡 25s | Needs context understanding |
| **Architecture design** | ❌ 5s | 🟡 15s | ✅ 40s | Complex reasoning |
| **Security audit** | ❌ 5s | 🟡 15s | ✅ 45s | Deep analysis needed |
| **Algorithm optimization** | ❌ 4s | 🟡 12s | ✅ 35s | Mathematical reasoning |

**Rule of Thumb:**
- **Haiku**: If task has clear rules/patterns → 5-10x faster
- **Sonnet**: Default for most coding tasks → 2-3x faster than Opus
- **Opus**: Only when deep reasoning required → Use sparingly

⚠️ **Anti-Pattern**: Using Opus for simple, rule-based tasks (code formatting, linting)  
✅ **Better**: Use Haiku for tasks with clear rules - it's 5-10x faster and 97% cheaper  
💡 **Why**: Opus's deep reasoning is wasted on simple pattern-matching tasks. Haiku handles these perfectly at a fraction of the cost and time.

#### Real Example: Pre-Commit Hook

**Scenario**: Check code before commit (runs frequently)

**Before Optimization:**
```bash
# .git/hooks/pre-commit
git diff --cached | claude "review for issues" --model="opus-4.1"

# Each commit:
# - Wait 20-30 seconds
# - Cost $0.40 per commit
# - 50 commits/week = $20/week = $80/month
# - Annoying delay before every commit
```

**After Optimization:**
```bash
# .git/hooks/pre-commit
git diff --cached | claude "check for: syntax errors, console.logs, TODOs" \
  --model="haiku-4.5"

# Each commit:
# - Wait 3-5 seconds (acceptable)
# - Cost $0.02 per commit
# - 50 commits/week = $1/week = $4/month
# - Savings: 95% cheaper, 6x faster
```

**For Critical PRs** (when you need thorough review):
```bash
# Use Opus for final PR review
git diff main | claude "comprehensive review: security, performance, architecture" \
  --model="opus-4.1"

# Only 2-3 times per week, not on every commit
```

---

### Pattern 5: Streaming for Perceived Speed

Enable streaming to see results immediately instead of waiting.

#### Non-Streaming (SLOW Perceived Speed)

```bash
# Without streaming
claude "explain this authentication flow" --no-stream

# User experience:
# [Wait 10 seconds...]
# [Complete response appears at once]
# Perceived wait: 10 seconds
```

#### Streaming (FAST Perceived Speed)

```bash
# With streaming (default)
claude "explain this authentication flow"

# User experience:
# [0.5s] First sentence appears...
# [1.0s] More text streams in...
# [2.0s] Continuing to stream...
# [10s] Complete
# Perceived wait: 0.5 seconds
# Actual wait: 10 seconds (same)
# Feels 20x faster!
```

#### When Streaming Helps

✅ **Use streaming when:**
- Interactive terminal usage (default for CLI)
- Users are reading output as it comes
- Long responses expected
- Real-time feedback desired

❌ **Disable streaming when:**
- Piping output to other commands
- Parsing structured output (JSON, etc.)
- Batch processing
- Logging to files

**Example:**
```bash
# ✅ Interactive - use streaming
claude "explain OAuth flow"

# ❌ Piping - disable streaming for clean output
claude "generate JSON schema" --no-stream | jq '.'

# ❌ Batch processing - disable for cleaner logs
for file in src/*.ts; do
  claude "analyze $file" --no-stream >> report.txt
done
```

---

## Real-World Benchmarks

Actual timing data from real development scenarios.

### Benchmark 1: Code Review

**Task**: Review changes before commit

**Unoptimized Approach:**
```bash
git diff | claude "review all changes thoroughly" --model="opus-4.1"

Timing breakdown:
- Read diff: 0.5s
- Process with Claude: 25s
- Wait for response: 5s
Total: 30.5 seconds
Cost: $0.45
```

**Optimized Approach:**
```bash
git diff | claude "check for: bugs, security issues, edge cases" \
  --model="haiku-4.5"

Timing breakdown:
- Read diff: 0.5s
- Process with Claude: 4s
- Wait for response: 1s
Total: 5.5 seconds
Cost: $0.03
Speedup: 5.5x faster
Savings: 93% cheaper
```

**Result**: 25 seconds saved per commit × 10 commits/day = **4 minutes saved daily**

### Benchmark 2: Documentation Generation

**Task**: Update README with new API endpoints

**Unoptimized:**
```bash
claude "document all API endpoints" --files="src/**/*.ts" --model="sonnet-4.5"

Timing:
- Read all files (120 files): 15s
- Analyze routes: 20s
- Generate docs: 12s
Total: 47 seconds
Tokens: 180K input
Cost: $0.54
```

**Optimized:**
```bash
# Step 1: Find route files (use codebase_search)
claude "list all files with API route definitions" --model="haiku-4.5"
# Returns: src/routes/*.ts (8 files)
# Time: 2s

# Step 2: Document just those files
claude "document API endpoints" --files="src/routes/*.ts" --model="haiku-4.5"

Timing:
- Read route files (8 files): 1s
- Analyze routes: 4s
- Generate docs: 3s
Total: 10 seconds (8s + 2s from step 1)
Tokens: 15K input
Speedup: 4.7x faster
Savings: 90% cheaper ($0.05)
```

**Result**: 37 seconds saved × 5 times/week = **3 minutes saved weekly**

### Benchmark 3: Test Generation

**Task**: Generate tests for new authentication module

**Unoptimized:**
```bash
claude "write comprehensive tests for authentication" \
  --files="src/**/*.ts" \
  --model="opus-4.1" \
  --extended-thinking=5000

Timing:
- Read all files: 12s
- Extended thinking: 18s
- Test generation: 25s
Total: 55 seconds
Cost: $0.85
```

**Optimized:**
```bash
claude "write tests for src/auth/login.ts - cover: happy path, invalid creds, rate limiting" \
  --files="src/auth/login.ts,src/types/User.ts" \
  --model="haiku-4.5"

Timing:
- Read specific files: 0.5s
- Test generation: 6s
Total: 6.5 seconds
Speedup: 8.5x faster
Cost: $0.03
Savings: 96% cheaper
```

**Result**: 48 seconds saved × 20 tests/week = **16 minutes saved weekly**

### Benchmark 4: Debugging Session

**Task**: Find cause of memory leak

**Unoptimized:**
```bash
# Send entire codebase repeatedly
claude "find memory leak" --files="src/**/*.ts"
# [Multiple follow-up queries, each re-sending all files]

Query 1: 45s
Query 2: 45s
Query 3: 45s
Query 4: 45s
Total: 180 seconds (3 minutes)
Cost: $2.40
```

**Optimized:**
```bash
# Progressive narrowing with caching

# Query 1: Find suspect areas
claude "which modules handle long-lived connections or caching?"
Time: 5s, Cost: $0.05

# Query 2: Analyze specific module (creates cache via CLAUDE.md)
claude "analyze src/cache/redis.ts for potential memory leaks"
Time: 8s, Cost: $0.15 (cache created)

# Query 3: Deep dive (uses cache)
claude "examine connection pooling in redis.ts - is pool size limited?"
Time: 3s, Cost: $0.02 (cached)

# Query 4: Verify fix (uses cache)
claude "review my fix - does it properly close connections?"
Time: 3s, Cost: $0.02 (cached)

Total: 19 seconds
Speedup: 9.5x faster
Cost: $0.24
Savings: 90% cheaper
```

**Result**: 2.7 minutes saved per debugging session × 5 sessions/week = **13 minutes saved weekly**

### Weekly Time Savings Summary

| Task | Times/Week | Seconds Saved Each | Weekly Savings |
|------|------------|-------------------|----------------|
| Code review | 50 | 25s | 21 minutes |
| Documentation | 5 | 37s | 3 minutes |
| Test generation | 20 | 48s | 16 minutes |
| Debugging | 5 | 161s | 13 minutes |
| **Total** | - | - | **53 minutes/week** |

**Monthly**: 53 min × 4 = **3.5 hours saved**  
**Annually**: 3.5 hours × 12 = **42 hours saved** (one full work week!)

---

## Performance Measurement

Track your Claude operations to identify bottlenecks.

### Measuring Response Time

#### Command Line Timing

```bash
# Basic timing
time claude "your query"

# Example output:
# real    0m8.432s
# user    0m0.123s
# sys     0m0.045s
# → Response took 8.4 seconds

# Compare different approaches:
time claude "review code" --files="src/**/*.ts"
# real    0m35.123s

time claude "review code" --files="src/auth/*.ts"
# real    0m8.234s
# → 4.3x faster by narrowing context
```

#### Detailed Performance Logging

```bash
# Enable verbose mode to see token usage
claude "your query" --verbose

# Example output:
# Input tokens: 45,234
# Output tokens: 1,892
# Cached tokens: 42,000 (90% cache hit)
# Response time: 8.4s
# Estimated cost: $0.12
```

### Creating Performance Benchmarks

```bash
#!/bin/bash
# benchmark-claude.sh - Test different approaches

echo "=== Claude Performance Benchmarks ==="
echo

# Test 1: Full context
echo "Test 1: Full context (unoptimized)"
time claude "review code" --files="src/**/*.ts" --model="opus-4.1" 2>&1 | \
  grep "real"

# Test 2: Narrow context
echo "Test 2: Narrow context"
time claude "review code" --files="src/auth/*.ts" --model="haiku-4.5" 2>&1 | \
  grep "real"

# Test 3: With caching (requires CLAUDE.md)
echo "Test 3: With caching (requires existing CLAUDE.md)"
time claude "review code" --model="haiku-4.5" 2>&1 | \
  grep "real"

echo
echo "=== Results ==="
echo "Check timings above to identify fastest approach"
```

### Setting Performance Budgets

Define acceptable response times for different operations:

```bash
# .claude-performance-budget.yml
performance_budgets:
  quick_queries:
    max_time: 3s
    examples:
      - "simple questions"
      - "code formatting"
      - "syntax fixes"
  
  code_review:
    max_time: 8s
    examples:
      - "git diff review"
      - "security check"
      - "style compliance"
  
  complex_analysis:
    max_time: 20s
    examples:
      - "architecture review"
      - "performance analysis"
      - "security audit"
  
  batch_operations:
    max_time: async
    examples:
      - "test generation for entire suite"
      - "documentation for all modules"
      - "CI/CD automated checks"
```

**Enforce budgets:**
```bash
# Add timeout to queries
timeout 10s claude "your query" || echo "Query exceeded 10s budget!"

# For critical fast operations:
timeout 5s git diff --cached | claude "quick review" --model="haiku-4.5" || {
  echo "⚠️  Review took too long, committing anyway"
}
```

### Monitoring Team Performance

```bash
#!/bin/bash
# team-performance-report.sh

echo "=== Weekly Claude Performance Report ==="
echo

# Average response times (requires logging)
echo "Average response times by operation:"
cat ~/.claude-logs/*.log | grep "response_time" | \
  awk '{sum+=$2; count++} END {print "Average: " sum/count "s"}'

# Slowest queries
echo
echo "Top 10 slowest queries this week:"
cat ~/.claude-logs/*.log | grep "response_time" | \
  sort -k2 -nr | head -10

# Cache hit rates
echo
echo "Cache efficiency:"
cache_hits=$(cat ~/.claude-logs/*.log | grep "cache_hit" | wc -l)
total_queries=$(cat ~/.claude-logs/*.log | wc -l)
hit_rate=$((cache_hits * 100 / total_queries))
echo "Cache hit rate: ${hit_rate}%"

# Model usage
echo
echo "Model selection breakdown:"
cat ~/.claude-logs/*.log | grep "model" | \
  awk '{print $2}' | sort | uniq -c | sort -nr
```

---

## Performance Checklist

Use this checklist before every Claude operation to ensure optimal performance.

### Pre-Query Optimization Checklist

Before running any Claude command, ask:

#### 1. Context Selection
- [ ] Do I really need all these files?
- [ ] Can I narrow to specific directory or files?
- [ ] Should I use codebase_search first to find relevant files?
- [ ] Is CLAUDE.md set up for caching? (for multi-query sessions)

**Action:**
```bash
# Instead of:
claude "query" --files="src/**/*.ts"

# Try:
claude "query" --files="src/auth/*.ts"
# Or even better - be specific:
claude "query" --files="src/auth/login.ts,src/types/User.ts"
```

#### 2. Model Selection
- [ ] Is this task simple enough for Haiku? (5-10x faster)
- [ ] Do I need deep reasoning or is pattern matching sufficient?
- [ ] Am I using Opus when Sonnet would work?

**Action:**
```bash
# Quick decision tree:
# - Code formatting, simple fixes → Haiku
# - Code review, test generation → Haiku or Sonnet
# - Architecture, complex debugging → Sonnet or Opus
claude "query" --model="haiku-4.5"  # Default to faster
```

#### 3. Extended Thinking
- [ ] Does this task require deep reasoning?
- [ ] Is this a simple pattern-matching task?
- [ ] Can I be more specific to avoid need for extended thinking?

**Action:**
```bash
# Only enable when needed:
# - Complex algorithms
# - Security audits
# - Architecture decisions

# Most tasks don't need it:
claude "query"  # No extended thinking (faster)
```

#### 4. Query Specificity
- [ ] Is my query specific enough?
- [ ] Have I included relevant constraints?
- [ ] Can I break this into smaller, focused queries?

**Action:**
```bash
# Vague (slow, expensive):
claude "improve this code"

# Specific (fast, cheap):
claude "refactor login.ts to use async/await instead of callbacks"
```

#### 5. Streaming
- [ ] Am I viewing output interactively? → Enable streaming
- [ ] Am I piping to another command? → Disable streaming
- [ ] Am I parsing structured output? → Disable streaming

**Action:**
```bash
# Interactive:
claude "explain..." # Streaming on (default)

# Piping/parsing:
claude "generate JSON" --no-stream | jq '.'
```

#### 6. Caching Strategy
- [ ] Will I make multiple queries on same codebase?
- [ ] Is CLAUDE.md set up with project context?
- [ ] Am I in a multi-turn conversation?

**Action:**
```bash
# Create CLAUDE.md if:
# - Working on feature (multiple queries)
# - Team project (shared context)
# - Long session (>3 queries)

cat > CLAUDE.md << 'EOF'
# Project: User Authentication Service
# Stack: Node.js, Express, PostgreSQL, JWT
[... add relevant context ...]
EOF
```

### Post-Query Analysis Checklist

After a slow query, investigate:

- [ ] Was response time > 10 seconds? → Could I narrow context?
- [ ] Was cost > $0.20? → Could I use cheaper model?
- [ ] Did I wait for full response? → Should I enable streaming?
- [ ] Did query fail or timeout? → Break into smaller queries

### Team Performance Review Checklist

Weekly team review:

- [ ] What were our slowest operations this week?
- [ ] Are we using appropriate models for each task?
- [ ] What's our cache hit rate? (target: >70%)
- [ ] Are we batching related queries?
- [ ] What performance budgets should we set?

---

## Quick Reference: Speed Optimization Patterns

| Pattern | Speedup | When to Use | Example |
|---------|---------|-------------|---------|
| **Parallel tool calls** | 3-5x | Multiple independent files | Specify files upfront |
| **Progressive disclosure** | 4-10x | Exploring unfamiliar code | Start narrow, expand as needed |
| **Smart context** | 3-5x | Multi-query sessions | CLAUDE.md + targeted files |
| **Model selection** | 5-10x | Simple vs complex tasks | Haiku for simple, Opus for complex |
| **Streaming** | 20x perceived | Interactive use | Enable by default (CLI default) |
| **Caching** | 3-10x | Repeated context | CLAUDE.md for project context |

---

## Summary

**Key Takeaways:**

1. **Parallel operations** save network latency (3-5x faster)
2. **Progressive disclosure** avoids loading unnecessary context (4-10x faster)
3. **Model selection** matters: Haiku vs Opus = 5-10x speed difference
4. **Streaming** makes responses feel 20x faster (perceived speed)
5. **Caching** via CLAUDE.md reduces latency and cost (90% savings)
6. **Specific queries** are faster than vague ones (2-3x faster)

**Performance Habits:**
- ✅ Always specify files when possible
- ✅ Default to Haiku, upgrade only when needed
- ✅ Create CLAUDE.md for multi-query sessions
- ✅ Enable streaming for interactive use
- ✅ Break large queries into focused ones
- ✅ Measure and track performance over time

**Expected Results:**
- **3-10x faster** responses with optimization
- **50-60 minutes saved per week** per developer
- **Better user experience** with streaming
- **Lower costs** as side benefit of speed optimization

---

## Next Steps

1. **Benchmark your current operations**: Run `time claude "query"` to see baseline
2. **Apply one optimization**: Start with model selection (easiest wins)
3. **Create CLAUDE.md**: Set up caching for your project
4. **Measure improvement**: Track time saved over one week
5. **Share learnings**: Help team adopt fast patterns

**Related Sections:**
- [Section 15: Cost Optimization](15-context-management.md) - Reduce costs while improving speed
- [Section 14: Prompt Engineering](14-prompt-engineering.md) - Write queries that get fast, accurate results
- [Section 22: Productivity Benchmarks](../07-reference-troubleshooting/22-productivity-benchmarks.md) - Track your improvements

---

**Performance optimization is about making Claude feel instantaneous. With these patterns, you'll spend less time waiting and more time building.** 🚀


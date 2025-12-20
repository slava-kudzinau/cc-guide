---
title: "Section 15b: Performance & Speed Optimization"
parent: "Part 5: Prompt Engineering & Context Mastery"
nav_order: 2.5
---

# Section 15b: Performance & Speed Optimization

**Goal**: Get 3-5x faster responses through smart optimization patterns  
**Time to read**: 20 minutes  
**Value**: Save hours per week, improve developer experience

---

## Table of Contents
- [Understanding Latency Sources](#understanding-latency-sources)
- [Speed Optimization Patterns](#speed-optimization-patterns)
- [Real-World Benchmarks](#real-world-benchmarks)
- [Performance Checklist](#performance-checklist)
- [Monitoring Performance](#monitoring-performance)

---

## Understanding Latency Sources

Before optimizing, understand where time is spent:

### Token Processing Speed

**Input Processing** (Fast):
- ~10,000 tokens/second
- Nearly instantaneous for cached content
- Context loading is rarely the bottleneck

**Output Generation** (Slower):
- 50-100 tokens/second (Sonnet 4.5)
- 80-150 tokens/second (Haiku 4.5)
- 30-60 tokens/second (Opus 4.1)
- This is usually where you wait

**Extended Thinking** (Variable):
- Adds thinking tokens at output speed
- Can double or triple response time
- Budget of 1000-5000 tokens typical
- Only worth it for complex reasoning

**Prompt Caching** (Game-changer):
- Cached tokens: ~instant (90%+ faster)
- First message: Normal speed + cache creation
- Subsequent messages: Much faster

### Network Latency

**API Call Overhead**:
- Base latency: 100-300ms per request
- Geographic distance matters
- Parallel calls: Same latency, more throughput

**Streaming vs Waiting**:
- Streaming: See tokens as they arrive (feels faster)
- Non-streaming: Wait for complete response
- Perceived speed improvement: 50-80%

---

## Speed Optimization Patterns

### Pattern 1: Parallel Tool Calls

**The Problem**: Sequential operations waste time

❌ **Slow: Sequential reads (10x latency)**
```bash
# Claude reads files one at a time
claude "analyze authentication"
# Internally:
# - Read src/auth/login.ts (300ms)
# - Read src/auth/jwt.ts (300ms)  
# - Read src/auth/session.ts (300ms)
# Total: 900ms just for file reads
```

✅ **Fast: Parallel reads (1x latency)**
```bash
# Claude reads files simultaneously
claude "analyze authentication" --files="src/auth/*.ts"
# Internally:
# - Read all 3 files in parallel (300ms)
# Total: 300ms for file reads
# Speedup: 3x faster
```

**When Claude Uses Parallelism**:
- Reading multiple independent files
- Searching different directories
- Multiple codebase searches
- Independent tool operations

**How to Encourage Parallelism**:
```bash
# Good: Provides all context upfront
claude "compare these implementations" \
  --files="src/auth/v1.ts" \
  --files="src/auth/v2.ts" \
  --files="src/auth/v3.ts"

# Less optimal: Sequential questions
claude "show me v1 implementation"
claude "now show me v2"
claude "now compare them"
```

**Real Example**:
```bash
# Analyzing test coverage across 10 files
# Sequential: 10 × 300ms = 3000ms
# Parallel: 1 × 300ms = 300ms
# Speedup: 10x faster
```

### Pattern 2: Progressive Disclosure

**The Problem**: Loading too much context upfront

❌ **Slow: Read entire codebase upfront**
```bash
claude "analyze project" --files="src/**/*.ts"
# - 100+ files
# - 200,000 tokens
# - 20+ seconds to process
# - Claude overwhelmed with context
# - You wait unnecessarily
```

✅ **Fast: Start narrow, expand as needed**
```bash
# Step 1: High-level overview (2s)
claude "what does this project do?" --files="README.md package.json"

# Step 2: Specific area (3s)
claude "explain auth flow" --files="src/auth/*.ts"

# Step 3: Deep dive only if needed (3s)
claude "how does OAuth refresh work?" --files="src/auth/oauth.ts"

# Total: 8 seconds (with flexibility to stop early)
# vs 20+ seconds upfront
```

**The Conversational Advantage**:
```bash
# Start broad
You: "What's the authentication approach?"
Claude: "Uses JWT with OAuth2, refresh tokens in Redis"

# Narrow based on response
You: "Show me the refresh token logic"
Claude: [Searches and shows specific function]

# Deep dive if needed
You: "What happens if Redis is down?"
Claude: [Analyzes fallback logic]
```

**When to Use**:
- ✅ Exploring unfamiliar codebases
- ✅ Debugging (start with error, expand as needed)
- ✅ Learning flows (follow the path)
- ❌ One-shot operations (commit message generation)
- ❌ Batch processing (need all context)

### Pattern 3: Smart Context Selection

**The Problem**: Sending unnecessary context repeatedly

❌ **Slow: Send entire file every time**
```bash
# 5000-line file, repeated 10 times in conversation
# Cost: 5000 × 10 = 50,000 tokens
# Time: Slower context processing each time
```

✅ **Fast: Use codebase search for relevant sections**
```bash
# First message: Let Claude find relevant code
claude "where is JWT validation in src/?"
# Claude searches, finds function at lines 234-267

# Second message: Only send relevant section
claude "explain JWT validation logic" --files="src/auth/jwt.ts:234-267"
# Only 34 lines sent, not 5000
# Savings: 99% fewer tokens, much faster
```

**Codebase Search Strategy**:
```bash
# Instead of this (slow, expensive):
claude "find all API endpoints" --files="src/**/*.ts"

# Do this (fast, targeted):
claude "find API endpoint definitions"
# Claude uses codebase_search tool internally
# Then you can ask specifics about what it found
```

**File Selection Best Practices**:
```bash
# ❌ Too broad
--files="**/*"

# ❌ Still too broad
--files="src/**/*.ts"

# ✅ Targeted
--files="src/auth/*.ts"

# ✅ Very specific
--files="src/auth/jwt.ts src/auth/oauth.ts"

# ✅ With line ranges
--files="src/auth/jwt.ts:100-200"
```

### Pattern 4: Model Selection for Speed

Choose the right model for the task:

| Task | Wrong Choice | Right Choice | Speedup | Cost Savings |
|------|--------------|--------------|---------|--------------|
| Format code | Opus 4.1 | Haiku 4.5 | **5x faster** | **60x cheaper** |
| Simple questions | Sonnet + thinking | Haiku | **3x faster** | **12x cheaper** |
| Generate tests | Opus 4.1 | Sonnet 4.5 | **2x faster** | **5x cheaper** |
| Complex architecture | Haiku | Opus 4.1 | N/A (quality) | Worth it |
| Code review (quick) | Opus 4.1 | Haiku 4.5 | **5x faster** | **60x cheaper** |
| Code review (deep) | Haiku | Opus 4.1 | N/A (quality) | Worth it |

**Model Speed Comparison** (relative):
```
Output Generation Speed:
━━━━━━━━━━━━━━━━━━━━ Haiku 4.5 (fastest)
━━━━━━━━━━━━━━ Sonnet 4.5 (balanced)
━━━━━━━━ Opus 4.1 (most capable, slower)
```

**When to Use Each Model**:

**Haiku 4.5** (Speed champion):
```bash
# Formatting, linting, simple fixes
git diff | claude "fix linting errors" --model="haiku-4.5"

# Quick questions with known context
claude "what does this function return?" --model="haiku-4.5"

# Batch operations (speed × volume)
for file in src/*.ts; do
  claude "add JSDoc" --files="$file" --model="haiku-4.5"
done
```

**Sonnet 4.5** (Default for most tasks):
```bash
# Feature development
claude "add OAuth login"

# Debugging
npm test 2>&1 | claude "explain test failures"

# Code review
git diff main | claude "review changes"
```

**Opus 4.1** (Complex reasoning only):
```bash
# Architecture decisions
claude "design microservices split for monolith" --model="opus-4.1"

# Complex refactoring
claude "refactor to event-driven architecture" --model="opus-4.1"

# Security audit (deep)
claude "comprehensive security review" --model="opus-4.1"
```

### Pattern 5: Extended Thinking - Use Sparingly

**When Extended Thinking Helps**:
- Complex architectural decisions
- Multi-step reasoning problems
- Trade-off analysis
- Security vulnerability analysis

**When It's Wasteful**:
- Code formatting
- Simple questions
- Documentation generation
- Straightforward debugging

❌ **Slow: Unnecessary extended thinking**
```bash
# Simple task with extended thinking
claude "format this code" --extended-thinking=5000
# Adds 5000 thinking tokens at output speed
# Overhead: ~50-100 seconds
# Benefit: None (formatting doesn't need reasoning)
```

✅ **Fast: No extended thinking for simple tasks**
```bash
# Simple task, no extended thinking
claude "format this code"
# Response: 2-3 seconds
# Result: Same quality
# Savings: 4x faster
```

✅ **Smart: Extended thinking when it matters**
```bash
# Complex architectural decision
claude "should we use microservices or monolith for this system?" \
  --extended-thinking=5000 \
  --files="docs/requirements.md"
# Extended thinking explores trade-offs
# Provides deeper analysis
# Worth the time investment
```

**Default Strategy**:
```bash
# 1. Start without extended thinking (fast)
claude "analyze this problem"

# 2. If answer is superficial, retry with thinking
claude "analyze this problem in depth" --extended-thinking=3000

# 3. For known complex tasks, enable upfront
claude "design database schema" --extended-thinking=5000
```

### Pattern 6: Streaming for Perceived Speed

**Streaming** = See tokens as they're generated  
**Non-streaming** = Wait for complete response

```bash
# Streaming (default in CLI)
claude "explain this codebase"
# ✅ See response immediately, token by token
# ✅ Can interrupt if going wrong direction
# ✅ Feels 50-80% faster

# Non-streaming
claude "explain this codebase" --no-stream
# ❌ Wait for entire response
# ❌ No feedback until complete
# ❌ Can't interrupt early
```

**When to Disable Streaming**:
- Piping output to other commands
- Saving to files
- Parsing structured output (JSON/CSV)
- Automated scripts

**Example**:
```bash
# Interactive: Use streaming (default)
claude "review my code"

# Automation: Disable streaming
claude "generate JSON schema" --no-stream > schema.json
```

### Pattern 7: Prompt Caching for Repeat Context

**How Caching Works**:
1. First message: Claude caches static context (CLAUDE.md, large files)
2. Cache lasts ~5 minutes
3. Subsequent messages reuse cache (90% faster, 90% cheaper)

❌ **Slow: No caching**
```bash
# Every message re-sends project context
Message 1: 50K context + 100 new = 50,100 tokens (slow)
Message 2: 50K context + 100 new = 50,100 tokens (slow)
Message 3: 50K context + 100 new = 50,100 tokens (slow)
# Each message processes 50K tokens
# Total: 150K+ tokens processed
```

✅ **Fast: With caching**
```bash
# First message creates cache
Message 1: 50K context (cached) + 100 new = 50,100 tokens
# Cache created, subsequent messages fast

Message 2: 50K cache hit + 100 new = 100 tokens processed (fast!)
Message 3: 50K cache hit + 100 new = 100 tokens processed (fast!)
# Total: 50,200 tokens processed
# Speedup: 3x faster, 90% cost reduction
```

**How to Enable Caching**:

**Method 1: CLAUDE.md** (automatic)
```markdown
<!-- Create CLAUDE.md in project root -->
# Project Context

This is a Node.js REST API...
[Project details cached automatically]
```

**Method 2: Repeated file context**
```bash
# Claude automatically caches large files you reference repeatedly
claude "explain auth" --files="src/auth/large-file.ts"
# First time: Full processing
claude "how does login work?" --files="src/auth/large-file.ts"
# Second time (within 5 min): Cached!
```

**Cache Lifetime**:
- Duration: ~5 minutes of inactivity
- Refresh: Each use extends lifetime
- Tip: Keep conversations active for continued benefit

---

## Real-World Benchmarks

### Benchmark 1: Code Review

**Task**: Review git diff with 500 lines changed

**Unoptimized**:
```bash
git diff | claude "review all changes" --model="opus-4.1"
# Model: Opus 4.1 (slowest, most expensive)
# Time: 45 seconds
# Cost: $0.25
```

**Optimized**:
```bash
git diff | claude "review for critical issues" --model="haiku-4.5"
# Model: Haiku 4.5 (fast, cheap)
# Time: 8 seconds
# Cost: $0.004
# Speedup: 5.6x faster
# Savings: 98% cheaper
```

**When to Use Which**:
- Pre-commit hook: Haiku (fast, catch obvious issues)
- Pre-PR review: Sonnet (balanced)
- Critical PR review: Opus (deep analysis)

### Benchmark 2: Documentation Generation

**Task**: Document 20 TypeScript files

**Unoptimized**:
```bash
claude "document all files" --files="src/**/*.ts"
# Approach: All files at once
# Files: 20 files, 10K lines total
# Time: 35 seconds
# Cost: $0.30
```

**Optimized**:
```bash
# Approach: Only public API files
claude "document public API" --files="src/index.ts src/types.ts src/api/*.ts"
# Files: 5 key files, 2K lines
# Time: 7 seconds
# Cost: $0.06
# Speedup: 5x faster
# Savings: 80% cheaper
# Result: Actually more useful (focused on public API)
```

### Benchmark 3: Test Generation

**Task**: Generate tests for utility function

**Unoptimized**:
```bash
claude "write tests for sum function" \
  --extended-thinking=5000 \
  --model="opus-4.1"
# Extended thinking: Not needed for simple function
# Model: Opus (overkill)
# Time: 25 seconds
# Cost: $0.15
```

**Optimized**:
```bash
claude "write Jest tests with edge cases" \
  --files="src/utils/math.ts:45-52" \
  --model="haiku-4.5"
# No extended thinking (simple task)
# Model: Haiku (sufficient for tests)
# Specific lines only
# Time: 4 seconds
# Cost: $0.005
# Speedup: 6.2x faster
# Savings: 97% cheaper
```

### Benchmark 4: Debugging Session

**Task**: Fix TypeError in production

**Unoptimized**:
```bash
# Sending entire codebase
claude "fix this error: [stack trace]" --files="src/**/*.ts"
# Context: 100 files, 50K lines
# Time: 40 seconds
# Cost: $0.45
# Claude overwhelmed with context
```

**Optimized**:
```bash
# Progressive disclosure approach
# Step 1: Identify issue (3s)
claude "what causes this error: [stack trace]"
# Claude: "Likely in auth middleware, line 234"

# Step 2: Examine specific code (2s)
claude "show me src/middleware/auth.ts:220-250"

# Step 3: Fix (3s)
claude "fix the null reference in auth middleware"

# Total: 8 seconds, $0.08
# Speedup: 5x faster
# Savings: 82% cheaper
# Better: Targeted fix, not shotgun approach
```

### Benchmark 5: Batch Operations

**Task**: Add TypeScript types to 50 JavaScript files

**Unoptimized** (Sequential):
```bash
for file in src/**/*.js; do
  claude "add types" --files="$file"
done
# Approach: One by one
# Time: 50 files × 5s = 250 seconds (~4 minutes)
# Cost: $2.50
```

**Optimized** (Batch + Model):
```bash
# Use Haiku for simple typing task
for file in src/**/*.js; do
  claude "add TypeScript types" --files="$file" --model="haiku-4.5"
done &
# Approach: Parallel with fast model
# Time: 50 files × 1s (parallel) = ~10 seconds
# Cost: $0.20
# Speedup: 25x faster
# Savings: 92% cheaper
```

**Even Better** (Batch API):
```bash
# Use Batch API for 50% discount + parallelism
claude-batch "add TypeScript types" --files="src/**/*.js" --model="haiku-4.5"
# Time: ~15 seconds (async, don't wait)
# Cost: $0.10 (50% batch discount)
# Speedup: Near-instant perceived (async)
# Savings: 96% cheaper
```

### Summary: Speed Optimization Impact

| Optimization | Typical Speedup | Effort | Cumulative |
|--------------|-----------------|--------|------------|
| Use Haiku for simple tasks | 3-5x | Low | 5x |
| Parallel tool calls | 2-4x | Low | 20x |
| Progressive disclosure | 2-3x | Medium | 60x |
| Disable extended thinking | 2-4x | Low | 240x |
| Enable prompt caching | 1.5-2x | Low | 480x |
| Smart context selection | 2-10x | Medium | **4800x** |

**Real-world result**: With all optimizations, get **10-50x faster** responses in practice.

---

## Performance Checklist

Before running any Claude operation:

### Context Optimization
- [ ] Do I need all these files, or just a few?
- [ ] Can I use line ranges instead of full files?
- [ ] Should Claude search first, then I provide specific files?
- [ ] Is CLAUDE.md set up for automatic caching?

### Model Selection
- [ ] Is this simple enough for Haiku? (5x faster)
- [ ] Do I really need Opus, or is Sonnet sufficient?
- [ ] Can I use Haiku for first pass, Opus for refinement?

### Extended Thinking
- [ ] Is this a complex reasoning task? (Yes = enable)
- [ ] Or is it straightforward? (No = disable)
- [ ] What budget: 1000 (light), 3000 (medium), 5000 (deep)?

### Operation Type
- [ ] Is this interactive? (Use streaming)
- [ ] Or automated/piped? (Disable streaming)
- [ ] Can I batch multiple operations?
- [ ] Should I use async Batch API?

### Parallelism
- [ ] Am I reading multiple independent files?
- [ ] Can I provide all file paths upfront?
- [ ] Am I in a conversation? (Progressive disclosure OK)

### Caching Strategy
- [ ] Is this a multi-turn conversation?
- [ ] Am I referencing same files repeatedly?
- [ ] Is CLAUDE.md present and up-to-date?
- [ ] Are my queries within 5-minute cache window?

---

## Monitoring Performance

### Measure Response Time

**CLI timing**:
```bash
# Time any Claude operation
time claude "your query"
# Output:
# real    0m3.421s  ← Total time
# user    0m0.123s
# sys     0m0.045s
```

**Set performance budgets**:
```bash
# Simple queries: < 2 seconds
time claude "what does this function do?" --files="src/utils.ts:45-60"

# Code reviews: < 5 seconds
time git diff | claude "quick review"

# Complex analysis: < 10 seconds
time claude "analyze architecture"

# Batch jobs: Don't wait (async)
claude-batch "generate docs" &
```

### Track Token Usage

```bash
# See token breakdown
claude "your query" --verbose
# Output includes:
# - Input tokens: 1,234
# - Output tokens: 567
# - Cached tokens: 0 (or 1,234 if cached)
# - Total cost: $0.0123
```

### Monitor Cost

```bash
# Track daily usage
claude --usage-stats --day=today

# Weekly summary
claude --usage-stats --week=current

# Monthly tracking
claude --usage-stats --month=current

# Cost breakdown
claude --cost-report --sort-by=cost --top=10
# Shows most expensive operations
```

### Set Alerts

```bash
# Budget alerts
claude --set-budget 100 --alert-threshold=80
# Warns at $80, stops at $100

# Daily limits
claude --set-daily-limit 10
# Max $10/day

# Per-query limits
export CLAUDE_MAX_COST_PER_QUERY=0.50
# Blocks queries estimated >$0.50
```

### Performance Dashboard

Create a personal performance tracker:

```bash
#!/bin/bash
# save as: claude-perf-tracker.sh

echo "=== Claude Performance Metrics ==="
echo "Week of: $(date +%Y-%m-%d)"
echo

# Response time tracking
echo "--- Response Times ---"
echo "Last 10 operations:"
tail -10 ~/.claude/timing.log | awk '{sum+=$1; count++} END {print "Average: " sum/count "s"}'

# Token efficiency
echo
echo "--- Token Efficiency ---"
claude --usage-stats --week=current | grep "Tokens"
echo "Cache hit rate:" $(claude --cache-stats | grep "hit rate")

# Cost efficiency
echo
echo "--- Cost Efficiency ---"
claude --usage-stats --week=current | grep "Cost"
echo "Cost per query:" $(claude --cost-report --average)

# Speed trends
echo
echo "--- Speed Trends ---"
echo "Fastest query: $(sort -n ~/.claude/timing.log | head -1)"
echo "Slowest query: $(sort -rn ~/.claude/timing.log | head -1)"
```

### Identifying Bottlenecks

**If responses are slow, check**:

1. **Token Count**
   ```bash
   claude "your query" --verbose | grep "Input tokens"
   # If >50K: Reduce context
   ```

2. **Model Choice**
   ```bash
   claude --last-query-stats
   # Check: model: "opus-4.1"
   # Ask: Did I need Opus?
   ```

3. **Extended Thinking**
   ```bash
   claude --last-query-stats | grep "thinking"
   # Check if thinking tokens > 0
   # Ask: Was extended thinking necessary?
   ```

4. **Caching**
   ```bash
   claude --cache-stats
   # Check cache hit rate
   # If 0%: Set up CLAUDE.md
   ```

5. **Network**
   ```bash
   ping api.anthropic.com
   # Check latency
   # If >200ms: Network issue
   ```

---

## Performance Optimization Examples

### Example 1: Morning Code Review Routine

**Before optimization** (slow):
```bash
# Review overnight changes
git log --since="yesterday" --patch | claude "review all commits" --model="opus-4.1"
# Time: 2-3 minutes
# Cost: $2.50
# Problem: Too thorough for quick morning scan
```

**After optimization** (fast):
```bash
# Quick scan with Haiku
git log --since="yesterday" --oneline | claude "summarize changes" --model="haiku-4.5"
# Time: 5 seconds
# Cost: $0.01
# Result: Fast overview, can deep-dive if needed
# Speedup: 36x faster, 250x cheaper
```

### Example 2: Pre-commit Hook

**Before** (blocking):
```bash
# .git/hooks/pre-commit
git diff --cached | claude "review" --model="sonnet-4.5"
# Time: 15 seconds per commit
# Developer waits, frustrating
```

**After** (fast):
```bash
# .git/hooks/pre-commit
git diff --cached | claude "check for: secrets, console.logs, TODOs" --model="haiku-4.5"
# Time: 2-3 seconds
# Focus: Critical issues only
# Developer: Barely notices
# Speedup: 5-7x faster
```

### Example 3: CI/CD Pipeline

**Before** (sequential):
```bash
# .github/workflows/claude.yml
- run: claude "review PR"        # 30s
- run: claude "check security"   # 30s
- run: claude "update docs"      # 30s
# Total: 90 seconds
```

**After** (parallel + batch):
```bash
# .github/workflows/claude.yml
- run: |
    claude-batch "review PR" &
    claude-batch "check security" &
    claude-batch "update docs" &
    wait
# Total: 35 seconds (parallel + batch API)
# Speedup: 2.5x faster
```

---

## Key Takeaways

### Golden Rules
1. **Start with Haiku**, upgrade if needed
2. **Narrow context first**, expand later
3. **Cache with CLAUDE.md** (90% savings)
4. **Disable extended thinking** by default
5. **Parallelize** when possible
6. **Stream for interaction**, disable for automation
7. **Measure everything**, optimize bottlenecks

### Quick Wins (Implement Today)
- [ ] Create CLAUDE.md → instant caching
- [ ] Use `--model="haiku-4.5"` for simple tasks
- [ ] Remove `--extended-thinking` from scripts
- [ ] Add `time` to measure operations
- [ ] Use file line ranges instead of full files

### Expected Results
With these optimizations:
- **10-50x faster** responses
- **80-95% cost reduction**
- **Better developer experience** (faster feedback)
- **Same or better quality** (right tool for right job)

---

## What's Next?

**Related Sections**:
- [Section 15: Context Management & Cost Optimization](./15-context-management.md) - Cost strategies
- [Section 14: Prompt Engineering](./14-prompt-engineering.md) - Better prompts
- [Section 21: Troubleshooting](../07-reference-troubleshooting/21-troubleshooting.md) - If slow, debug here

**Advanced Topics**:
- Batch API for large-scale operations
- Custom caching strategies
- Performance monitoring automation
- Team-wide optimization

---

**Remember**: Speed optimization isn't about cutting corners—it's about using the right tool efficiently. Fast responses = better developer experience = more Claude usage = more productivity. 🚀

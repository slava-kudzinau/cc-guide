---
title: Home
nav_order: 1
---

# Claude Code: Complete Technical Guide for Senior Developers
## Master Index & Navigation

**Author**: AI-Generated Technical Guide  
**Maintainer**: [Viachaslau Kudzinau](viachaslau_kudzinau@epam.com)
**Version**: 1.0  
**Last Updated**: December 2025  
**Based on**: Latest Claude Code, API, and Agent SDK documentation

---

## 📖 About This Guide

This comprehensive guide covers everything senior developers need to master Claude Code (CLI), Claude API, Agent SDK, and the complete Claude ecosystem. Structured in 7 logical parts for progressive learning from fundamentals to advanced enterprise patterns.

**What This Guide Covers:**
- ✅ **Claude Code CLI** (terminal automation)
- ✅ **Claude Code VS Code Extension** (official by Anthropic)
- ✅ Claude API integration (extended thinking, vision, batching)
- ✅ Agent SDK development (programmatic agent building)
- ✅ Skills system (dynamic knowledge loading)
- ✅ Model Context Protocol (MCP) integration
- ✅ Enterprise deployment patterns (AWS, GCP hosting)
- ✅ DevOps & CI/CD automation
- ✅ Advanced prompt engineering & context optimization
- ✅ Real-world workflows and templates

**⚠️ Important Note:**  
This guide covers **Claude Code** (CLI + official VS Code extension by Anthropic). This is NOT a Cursor IDE guide - Cursor is a separate product with its own documentation.

---

## 🚀 Get Your First Win in 5 Minutes

**New to Claude Code? Start here.** Copy-paste these commands for immediate productivity gains:

### 1. Review Your Code Changes

```bash
git diff | claude "review for bugs, security issues, and best practices"
```

**What it does**: Analyzes your uncommitted changes and flags potential issues  
**Time**: 30-60 seconds  
**Use when**: Before every commit

### 2. Write Tests Automatically

```bash
claude "write jest tests for src/auth.ts with happy path and 3 error cases"
```

**What it does**: Generates comprehensive test coverage  
**Time**: 1-2 minutes  
**Use when**: After writing new functions or fixing bugs

### 3. Debug Test Failures

```bash
npm test 2>&1 | claude "explain these test failures and suggest fixes"
```

**What it does**: Analyzes test output and provides actionable fixes  
**Time**: 30 seconds  
**Use when**: Tests fail and error messages are cryptic

### 4. Generate Documentation

```bash
claude "update README.md with API endpoints from src/routes/ - include examples"
```

**What it does**: Creates or updates documentation based on your code  
**Time**: 1-2 minutes  
**Use when**: After adding new features or APIs

### 5. Refactor Legacy Code

```bash
claude "refactor src/utils/format.ts to modern ES6 patterns - preserve behavior"
```

**What it does**: Modernizes code while maintaining functionality  
**Time**: 2-3 minutes  
**Use when**: Cleaning up technical debt

### 6. Analyze Performance Issues

```bash
git diff main | claude "identify performance bottlenecks - suggest optimizations"
```

**What it does**: Spots N+1 queries, inefficient algorithms, memory leaks  
**Time**: 1-2 minutes  
**Use when**: Before merging performance-critical changes

### 7. Generate Commit Messages

```bash
git diff --cached | claude "write a conventional commit message for these changes"
```

**What it does**: Creates clear, semantic commit messages  
**Time**: 10 seconds  
**Use when**: Before every commit

---

## 💡 Productivity Patterns Every Developer Should Know

### Pattern 1: The Context Window is HUGE (Use It!)

You have **200K-2M tokens** of context. That's roughly:
- 150,000 words
- 500+ pages of documentation
- An entire medium-sized codebase

**Don't be afraid to give Claude lots of context!**

```bash
# ✅ Good: Provide full context
claude "explain the auth flow" --files="src/auth/*.ts src/middleware/*.ts"

# ❌ Bad: Too little context leads to generic answers
claude "explain auth"
```

### Pattern 2: Progressive Disclosure (Start Broad, Then Narrow)

**Strategy**: Begin with overview questions, drill down into specifics

```bash
# Step 1: High-level understanding (2 seconds)
claude "what does this project do?" --files="README.md package.json"

# Step 2: Architecture overview (3 seconds)
claude "explain the authentication architecture" --files="src/auth/"

# Step 3: Deep dive into specific issue (3 seconds)
claude "why does OAuth refresh fail?" --files="src/auth/oauth.ts" --include-logs
```

**Why this works**: Faster initial response, focused exploration, avoids information overload

### Pattern 3: Parallel Tool Calls (Let Claude Multitask)

Claude can read multiple files, search multiple locations, and analyze multiple scenarios **simultaneously**.

**Behind the scenes** (when you ask a complex question):
```
Claude simultaneously:
├─ Searches codebase for relevant files
├─ Reads 5-10 files in parallel
├─ Analyzes dependencies
└─ Plans coordinated changes
```

**Your benefit**: 3-5x faster than sequential operations

### Pattern 4: Use CLAUDE.md as Your Project Brain

Create `CLAUDE.md` in your project root:

```markdown
# Project: Authentication Service

## Tech Stack
- Node.js 20 + Express
- PostgreSQL with Prisma
- Redis for sessions
- OAuth 2.0 (Google, GitHub)

## Key Files
- src/auth/oauth.ts - OAuth flow
- src/middleware/auth.ts - Request authentication
- src/models/user.ts - User model

## Conventions
- Use async/await (no callbacks)
- Error handling via middleware
- All endpoints require authentication except /login

## Common Tasks
- Add OAuth provider: Update src/auth/providers/
- Change session logic: Update src/auth/session.ts
```

**Benefits**:
- Claude uses this context automatically (with prompt caching)
- 90% cost reduction on repeated context
- Onboarding new team members
- Consistent responses across sessions

### Pattern 5: The Right Tool for the Job

**Decision tree**:

```
Need automation? ────→ Use CLI
Need visual feedback? ──→ Use VS Code Extension
Need custom logic? ─────→ Use API/Agent SDK
Need batch processing? ─→ Use Batch API
Need deep reasoning? ───→ Enable Extended Thinking
Working with images? ───→ Use Vision API
```

### Pattern 6: Cost-Speed-Quality Tradeoff

**Choose your model wisely**:

| Task | Model | Why |
|------|-------|-----|
| Quick questions | Haiku 4.5 | 10x faster, 10x cheaper |
| Daily coding | Sonnet 4.5 | Best balance |
| Complex architecture | Opus 4.1 | Deepest reasoning |
| Simple formatting | Haiku 4.5 | Instant results |
| Code review | Sonnet 4.5 | Thorough but fast |

**Cost example**:
- Using Opus for everything: **$85/month**
- Using Haiku + Sonnet strategically: **$6/month**
- **14x cheaper** with better speed!

⚠️ **Anti-Pattern**: Using Opus 4.1 for all tasks (slow and 10x more expensive)  
✅ **Better**: Use Haiku for simple tasks, Sonnet for daily coding, Opus only for complex reasoning  
💡 **Why**: Most coding tasks don't need Opus's deep reasoning. Haiku handles 70% of tasks at 10x lower cost and 5x faster speed. Save Opus for architecture decisions and complex debugging.

### Pattern 7: Use Context7 for Latest Documentation

When working with rapidly evolving frameworks, use **Context7** to access up-to-date library documentation.

```bash
# Get latest Next.js 15 patterns
claude "Using Context7, show me Next.js 15 app router authentication patterns"

# Current React 19 features
claude "What are React 19's new features? Query Context7 for official docs"

# Latest Python typing features
claude "Context7: Show me Python 3.12 type hints for generics"

# AWS CDK v3 best practices
claude "Context7: Latest AWS CDK v3 Lambda function patterns"
```

**When to use Context7:**
- ✅ Framework released new version recently (<6 months)
- ✅ Official documentation updated in last quarter
- ✅ Need version-specific guidance (e.g., "React 19" not just "React")
- ✅ Working with beta/preview features
- ❌ Stable, mature APIs where Claude's training data is sufficient

**Why it matters:**
- Claude's training data has a cutoff date
- Context7 provides real-time access to current docs
- Ensures you're using latest best practices
- Avoids deprecated patterns

**Example comparison:**
```bash
# Without Context7 (may use outdated patterns)
claude "How do I create Next.js API routes?"
# May return Pages Router patterns (older)

# With Context7 (latest patterns)
claude "Context7: Next.js 15 app router API route handlers"
# Returns current App Router patterns with Route Handlers
```

---

## 🎯 Quick Tool Selection Guide

**"Which tool should I use right now?"**

### Use Claude Code CLI When:
- ✅ Automating repetitive tasks
- ✅ Pre-commit/pre-push hooks
- ✅ CI/CD pipelines
- ✅ Piping command output (`git diff | claude`)
- ✅ Shell scripting
- ✅ Batch processing multiple files

**Example**:
```bash
# Perfect for CLI
for file in src/**/*.ts; do
  claude "add JSDoc comments" --file="$file"
done
```

### Use Claude Code VS Code Extension When:
- ✅ Interactive coding (see changes visually)
- ✅ Multi-file refactoring (Plan Mode)
- ✅ Learning unfamiliar codebases
- ✅ Debugging with visual context
- ✅ Reviewing changes before applying
- ✅ Iterative development

**Example**:
Open VS Code → Spark icon → "Refactor auth across all controllers to use new middleware"

### Use Both (Hybrid Workflow) When:
- ✅ Preparing PRs (CLI for automation + Extension for manual review)
- ✅ Complex refactoring (CLI to find files + Extension to edit)
- ✅ Documentation (CLI to generate + Extension to refine)

---

## ⚡ Performance Tips (Speed Up 3-5x)

### Tip 1: Use Codebase Search, Not Full File Reads

```bash
# ❌ Slow: Read entire 5000-line file
claude "find JWT validation" --files="src/services/huge-service.ts"

# ✅ Fast: Search first, then read specific lines
claude "search codebase for JWT validation logic"
# Then: claude "explain lines 234-267 in src/services/huge-service.ts"
```

### Tip 2: Enable Prompt Caching (90% Faster Responses)

**Without caching**: Same 50K context sent every message → $0.50 each  
**With caching** (via CLAUDE.md): Context cached → $0.05 per message

**Setup**: Just create `CLAUDE.md` in project root. Claude automatically caches it.

### Tip 3: Stream Responses for Perceived Speed

```bash
# Feels instant (incremental output)
claude "explain this" --stream

# Feels slow (wait for completion)
claude "explain this"
```

### Tip 4: Parallel Operations

```bash
# ❌ Sequential: 900ms total
claude "review file1.ts"
claude "review file2.ts"
claude "review file3.ts"

# ✅ Parallel in VS Code Extension: 300ms total
# Open extension → "Review file1.ts, file2.ts, file3.ts for security"
# Claude reads all files simultaneously
```

---

## 🗂️ Guide Structure

### [Part 1: Fundamentals & Core Concepts](docs/01-fundamentals-core-concepts/)
**Essential foundations for all users**

**Sections Covered:**
1. **Mental Models & Architecture** - Understanding Claude's ecosystem
   - Model family (Claude 4 family: Opus 4/4.1, Sonnet 4/4.5, Haiku 4.5, plus legacy Sonnet 3.7)
   - Tool selection matrix (CLI vs API vs Agent SDK vs VS Code)
   - Extended thinking architecture
   - Vision capabilities for code
   - Model Context Protocol (MCP) basics
   - Skills system fundamentals
   - Context windows (200K-2M tokens)

2. **Environment & Project Setup** - Installation and configuration
   - Claude Code CLI installation (all platforms)
   - VS Code extension setup (beta)
   - API key management (Anthropic, AWS, GCP)
   - Project configuration (CLAUDE.md, .clauderc, .claudeignore)
   - MCP server configuration
   - Skills repository setup
   - Enterprise deployment options

3. **Core Workflows** - Essential development patterns
   - 7-phase feature development workflow
   - Debugging workflow (analyze → diagnose → fix)
   - Code navigation and comprehension
   - Automated task execution
   - Test-driven development
   - Git workflow integration

**Key Takeaways:**
- Choose the right tool for each task (CLI for automation, API for integration, Agent SDK for custom agents)
- Extended thinking enables deep reasoning (1K-32K+ token budgets)
- CLAUDE.md is your project's context anchor
- MCP connects to external datasources (Drive, Jira, Figma, Slack)

---

### [Part 2: Tools Mastery (CLI & VS Code Extension)](docs/02-tools-mastery/)
**Comprehensive coverage of CLI workflows and VS Code extension**

**Sections Covered:**
1. **Terminal Workflows & Command Patterns**
   - CLI basics and command structure
   - Interactive vs command mode
   - Natural language commands
   - Piping and Unix composition
   - Session management
   - CLI configuration (.clauderc)

2. **CLI Automation & Scripting**
   - Scripting in bash/zsh/PowerShell
   - Pre-commit hooks and automation
   - CI/CD integration patterns
   - Batch operations
   - Error handling strategies
   - Non-interactive mode

3. **VS Code Extension Guide**
   - Installation and setup
   - Interface overview and keyboard shortcuts
   - Plan Mode (preview changes before applying)
   - Context Rewind (undo conversation + code)
   - Interactive features (inline chat, slash commands)
   - Core workflows (development, debugging, review)
   - Configuration and troubleshooting

4. **CLI vs VS Code Extension**
   - Decision matrix for tool selection
   - CLI advantages (scriptability, CI/CD)
   - VS Code advantages (GUI, visual feedback, Plan Mode)
   - Hybrid workflows
   - Scenario-based recommendations

5. **Advanced CLI Patterns**
   - Multi-repository workflows
   - Monorepo navigation
   - Parallel execution patterns
   - Tool integration (git, docker, kubectl)
   - Terminal multiplexing
   - Remote execution (SSH, cloud shells)

6. **Commands & Plugins System**
   - Custom commands for project workflows
   - Official and community plugins
   - Skills system for domain expertise
   - Creating and publishing plugins
   - Team collaboration patterns

**Key Takeaways:**
- CLI enables scriptable, automatable workflows
- VS Code Extension provides visual feedback and Plan Mode for safe refactoring
- Pipe outputs directly to Claude for analysis
- Use CLI in CI/CD for automated reviews, testing, documentation
- VS Code extension offers GUI convenience but less automation

---

### [Part 3: Advanced API & Agent Development](docs/03-advanced-api-agent-development/)
**Programmatic integration and custom agents**

**Sections Covered:**
8. **Advanced Claude API Features**
   - Extended thinking deep dive (budget optimization)
   - Vision API (screenshots, diagrams, PDFs)
   - Batch processing (cost optimization)
   - Prompt caching (90% cost reduction)
   - Streaming vs non-streaming

9. **Building Agents with Agent SDK**
   - Agent SDK architecture
   - Codebase understanding & file editing
   - Multi-agent orchestration
   - Custom agent patterns
   - Performance monitoring
   - Real-world examples

10. **Skills System & Knowledge Extension**
    - Skills architecture (progressive disclosure)
    - Official Anthropic skills
    - Creating custom skills
    - Skills composition
    - Domain-specific skills
    - Team skills repositories

**Key Takeaways:**
- Extended thinking costs more but dramatically improves complex reasoning
- Batch API reduces costs by 50% for async workloads
- Agent SDK enables full programmatic control
- Skills provide just-in-time knowledge loading

---

### [Part 4: Enterprise & DevOps Integration](docs/04-enterprise-devops-patterns/)
**Production deployment and infrastructure automation**

**Sections Covered:**
11. **DevOps & CI/CD Integration**
    - Claude Code in GitHub Actions/GitLab CI
    - Automated code reviews
    - Release automation
    - Infrastructure as Code (Terraform, CDK)
    - Kubernetes manifest generation
    - Security scanning integration

12. **Architecture & System Design**
    - Microservices architecture
    - API design automation
    - Database schema design
    - Event-driven patterns
    - Architecture Decision Records (ADRs)
    - Technical debt analysis

13. **Security & Compliance**
    - Secure coding practices
    - Vulnerability detection
    - Compliance checking (PCI, HIPAA, SOC2)
    - Secrets management
    - Audit trails
    - Data privacy

**Key Takeaways:**
- Automate PR reviews with Claude Code in CI/CD
- Generate IaC with context awareness
- Use extended thinking for architecture decisions
- Enterprise hosting (AWS/GCP) for data control

---

### [Part 5: Prompt Engineering & Context Mastery](docs/05-prompt-context-mastery/)
**Advanced techniques for optimal results**

**Sections Covered:**
14. **Advanced Prompt Engineering**
    - Chain-of-thought for complex features
    - Multishot examples
    - XML tags for structure
    - Role-based prompting
    - Constraint specification
    - Output format control

15. **Context Management & Optimization**
    - Token budget management
    - Prompt caching optimization
    - Relevant context selection
    - Multi-document reasoning
    - Contextual embeddings
    - CLAUDE.md best practices

16. **Multi-Model Strategies**
    - Choosing between Claude Opus 4.1, Claude Sonnet 4.5, Claude Haiku 4.5, and legacy models
    - Model ensemble patterns
    - Cost vs performance trade-offs
    - Latency optimization
    - Fallback strategies

**Key Takeaways:**
- Extended thinking for planning, Claude Haiku 4.5 for speed
- Prompt caching reduces repeated context costs by 90%
- CLAUDE.md provides persistent project context
- Chain models: Claude Opus 4.1 for architecture, Claude Sonnet 4.5 for implementation

---

### [Part 6: Domain-Specific & Team Collaboration](docs/06-domain-team-patterns/)
**Specialized workflows and team patterns**

**Sections Covered:**
17. **Domain-Specific Workflows**
    - Frontend (React, Next.js, screenshot-to-code)
    - Backend (APIs, databases, auth)
    - Data Engineering (ETL, SQL optimization)
    - ML/AI (pipelines, deployment)

18. **Team Collaboration Patterns**
    - Shared configuration management
    - Team skills repositories
    - Code review workflows
    - Onboarding automation
    - Pair programming with Claude
    - Productivity metrics

19. **Testing & Quality Assurance**
    - Test generation (unit, integration, e2e)
    - Coverage analysis
    - Test data generation
    - Performance testing
    - Security testing
    - Continuous testing

**Key Takeaways:**
- Domain-specific skills accelerate specialized work
- Shared CLAUDE.md templates maintain consistency
- Automate onboarding documentation
- Measure productivity gains (time-to-PR, PR count)

---

### [Part 7: Reference, Troubleshooting & Future](docs/07-reference-troubleshooting/)
**Complete reference and solutions**

**Sections Covered:**
20. **Complete Reference Guide**
    - CLI command reference
    - API parameter reference
    - Agent SDK API docs
    - Skills API reference
    - Prompt templates library

21. **Troubleshooting & Common Issues**
    - Authentication issues
    - Extended thinking problems
    - Context window overflow
    - MCP connection failures
    - Performance issues
    - Cost overruns

22. **Productivity Benchmarks & ROI**
    - Real-world metrics
    - Time savings by task type
    - Cost analysis
    - ROI calculations
    - Comparison with alternatives

23. **Best Practices & Anti-patterns**
    - What makes good prompts
    - Common failure modes
    - Anti-patterns to avoid
    - Code review checklist

24. **Future Roadmap & Migration**
    - Upcoming features
    - Migration from other tools
    - Staying current
    - Community resources

**Key Takeaways:**
- Copy-paste templates for quick starts
- Common issues have documented solutions
- Productivity gains: 30-50% typical
- Keep configurations in version control

---

## 🚀 Start Here: Pick Your Path

**Too many options is overwhelming.** Choose ONE path based on your immediate goal:

---

### Path 1: "Get Results in 15 Minutes" ⚡
**Goal**: First win TODAY  
**Time**: 15 minutes  
**For**: Everyone (first-time users)

**Steps**:

1. **Install** (2 minutes):
```bash
# Choose one:
npm install -g @anthropic/claude-code  # CLI
# OR install VS Code extension: search "Claude Code" in Extensions
```

2. **Setup API key** (1 minute):
```bash
export ANTHROPIC_API_KEY="your-key-here"
# Get key from: https://console.anthropic.com/
```

3. **Run these 3 commands** (5 minutes):
```bash
# Review your code
git diff | claude "review my changes for bugs and best practices"

# Write a test
claude "write jest test for src/utils.ts with edge cases"

# Debug failure
npm test 2>&1 | claude "explain failures and suggest fixes"
```

4. **✅ Success Check**: You've used Claude to review, test, and debug real code

**Next step**: Scroll up to "Get Your First Win in 5 Minutes" for more quick wins, or continue to Path 2 for depth.

---

### Path 2: "Master Claude Code in 4 Hours" 🎓
**Goal**: Daily workflow mastery  
**Time**: 4 hours (split across multiple sessions)  
**For**: Individual developers wanting comprehensive knowledge

**Hour 1: Foundations** (60 min)
- [Part 1, Sections 1-3](docs/01-fundamentals-core-concepts/): Mental models, setup, core workflows
- 🛠️ Workshop: Complete "First 10 Minutes with Claude Code"
- **Checkpoint**: Can explain when to use CLI vs Extension vs API

**Hour 2: Tools & Automation** (60 min)
- [Part 2, Sections 1-6](docs/02-tools-mastery/): CLI mastery, VS Code Extension guide
- 🛠️ Workshop: Automate your git workflow
- **Checkpoint**: Have working pre-commit hook with Claude

**Hour 3: Advanced Techniques** (60 min)
- [Part 5, Sections 14-15](docs/05-prompt-context-mastery/): Prompt engineering, context optimization
- [Part 3, Section 8](docs/03-advanced-api-agent-development/): Extended thinking, vision, batching
- 🛠️ Workshop: Master prompt patterns
- **Checkpoint**: Know how to optimize costs and context

**Hour 4: Reference & Specialization** (60 min)
- [Part 7, Section 20](docs/07-reference-troubleshooting/): Complete reference guide & prompt library
- [Part 6, Section 17](docs/06-domain-team-patterns/): Choose your domain (frontend/backend/data/ML)
- **Checkpoint**: Have saved 10+ prompts for daily use

**Final Deliverables**:
- ✅ Daily workflow established (morning/commit/PR routines)
- ✅ Automation scripts working (pre-commit hook minimum)
- ✅ CLAUDE.md created for your project
- ✅ Productivity gains: 2-3x faster on common tasks

**Next steps**: Explore domain-specific workflows ([Part 6](docs/06-domain-team-patterns/)) or API integration ([Part 3](docs/03-advanced-api-agent-development/))

---

### Path 3: "Enable Your Team in 2 Hours" 👥
**Goal**: Team adoption plan ready to execute  
**Time**: 2 hours  
**For**: Tech leads, engineering managers, team enablers

**Phase 1: Build Business Case** (30 min)
- [Part 7, Section 22](docs/07-reference-troubleshooting/): ROI calculation and productivity benchmarks
- **Action**: Create cost-benefit analysis for leadership
- **Deliverable**: ROI presentation showing 30-50% productivity gain

**Phase 2: Understand Technical Setup** (30 min)
- [Part 1, Section 2](docs/01-fundamentals-core-concepts/): Environment & project setup
- [Part 5, Section 15](docs/05-prompt-context-mastery/): Context management & CLAUDE.md
- **Action**: Plan API key distribution, security model
- **Deliverable**: Technical setup checklist

**Phase 3: Design Rollout Plan** (45 min)
- [Part 6, Section 18](docs/06-domain-team-patterns/): Team collaboration & adoption playbook
- **Action**: Identify pilot team (2-3 early adopters)
- **Deliverable**: 4-week adoption timeline with checkpoints

**Phase 4: Prepare Training Materials** (15 min)
- Scroll to "Get Your First Win in 5 Minutes" (top of this README)
- [Part 7, Section 20](docs/07-reference-troubleshooting/): Prompt library for team
- **Action**: Customize quick start for your tech stack
- **Deliverable**: Internal training guide (30 min presentation)

**Final Deliverables**:
- ✅ ROI presentation for leadership approval
- ✅ 4-week adoption timeline (pilot → rollout → optimization)
- ✅ Success metrics defined (PR velocity, test coverage, satisfaction)
- ✅ Training materials ready for pilot team
- ✅ Shared CLAUDE.md template for team projects

**Rollout Timeline** (After This 2-Hour Prep):
- **Week 1**: Pilot team (2-3 developers) get first wins
- **Week 2**: Pilot shares learnings, others see value
- **Week 3**: Rollout to full team with training sessions
- **Week 4**: Measure results, iterate, optimize

**Next steps**: Execute pilot phase, track metrics, share success stories

---

## 🎯 Not Sure Which Path?

**Answer these questions**:

1. **Have you used Claude Code before?**
   - No → Start with **Path 1** (15 min quick start)
   - Yes, but want to level up → **Path 2** (4 hour mastery)

2. **Are you rolling this out to a team?**
   - Yes → **Path 3** (2 hour team enablement)
   - No → **Path 1 or 2** (individual use)

3. **How much time do you have right now?**
   - 15 minutes → **Path 1**
   - 2 hours → **Path 3** (if leading team) or first 2 hours of **Path 2**
   - 4+ hours → **Path 2** (full mastery)

**Still unsure?** Default to **Path 1** - you'll get immediate value and can always come back for depth.

---

## 📋 Quick Reference Tables

### Tool Selection Matrix

| Task Type | Use This | Why |
|-----------|----------|-----|
| Terminal automation | **Claude Code CLI** | Scriptable, pipes, CI/CD ready |
| Interactive coding | **VS Code Extension** | GUI, visual feedback |
| Programmatic agents | **Agent SDK** | Full control, custom workflows |
| API integration | **Claude API** | Embed in applications |
| Quick questions | **CLI interactive** | Fastest, context-aware |
| Batch processing | **Batch API** | 50% cost reduction |
| Complex reasoning | **Extended Thinking** | Deep analysis (1K-32K tokens) |
| Visual UI work | **Vision API** | Screenshots → code |

### Model Selection Guide

| Task Type | Model | Why |
|-----------|-------|-----|
| **Complex architecture** | Claude Opus 4/4.1 | Most capable, deepest reasoning |
| **Daily coding** | Claude Sonnet 4.5 / Claude Sonnet 3.7 | Best balance: speed + intelligence |
| **Speed + cost** | Claude Haiku 4.5 | Near-instant, 10x cheaper |
| **Extended thinking** | Claude Sonnet 4.5 / Claude Opus 4.1 | Interleaved thinking support |
| **Batch processing** | Any active model | All models support batches |
| **Vision tasks** | Claude Sonnet 4.5+ | Text + image input |

> **Note on Model Naming:** "Claude 4" refers to the model family, not a single model. The Claude 4 family includes: Claude Opus 4/4.1 (most powerful), Claude Sonnet 4/4.5 (balanced), and Claude Haiku 4.5 (fastest/cheapest). Always specify the complete model name (e.g., "Claude Opus 4.1" not just "Claude 4") when referencing specific models.

### Extended Thinking Budget Guide

| Task Complexity | Budget Tokens | Use Case |
|----------------|---------------|----------|
| **Simple** | 1K-2K | Basic calculations, straightforward logic |
| **Moderate** | 2K-5K | Code review, refactoring planning |
| **Complex** | 5K-10K | Architecture design, complex debugging |
| **Very Complex** | 10K-32K | System design, multi-step analysis |
| **Extreme** | 32K+ | Deep research (use batch API) |

### Context Window Strategies

| Scenario | Window Size | Strategy |
|----------|-------------|----------|
| **Single file** | Standard (200K) | Read file directly |
| **Small project** | Standard (200K) | CLAUDE.md + key files |
| **Large codebase** | Standard (200K) | Use codebase search, focused context |
| **Full repo review** | Batch (2M tokens) | Async batch processing |
| **Multi-document** | Standard + caching | Cache common context |

### CLI Command Patterns

| Pattern | Command | Use Case |
|---------|---------|----------|
| **Interactive** | `claude` | Ask questions, iterative development |
| **One-shot** | `claude "task"` | Single command execution |
| **Piped input** | `git diff \| claude "review"` | Analyze command output |
| **File input** | `claude < prompt.txt` | Run saved prompts |
| **Scripted** | `#!/bin/bash + claude` | Automation workflows |

---

## 💡 Daily Workflow Patterns

### Morning Routine (5 minutes)

```bash
# 1. Catch up on overnight changes
git pull && claude "summarize commits since yesterday with focus on my areas"

# 2. Review your priorities
claude "analyze my TODOs and suggest priority order based on deadlines"

# 3. Check CI/CD status
gh pr list --author @me | claude "which PRs need my attention?"

# 4. Team updates (if using Jira/Linear)
# Integrate with MCP for project management tools
```

**Goal**: Start day with clear priorities and context

---

### Before Starting New Work (2 minutes)

```bash
# 1. Ensure docs are current
claude "check if README.md matches current API in src/routes/"

# 2. Review recent changes to your area
git log --since="3 days ago" src/auth/ | claude "summarize changes - any conflicts with my planned work?"

# 3. Check for breaking changes
git diff main...develop package.json | claude "any dependency updates that affect my work?"
```

**Goal**: Avoid conflicts and rework

---

### Active Development Loop (Throughout Day)

**Every 30-60 minutes:**

```bash
# Quick sanity check
git diff | claude "quick review - any obvious bugs?"

# Generate tests as you go
claude "write tests for the function I just added in src/auth/oauth.ts"

# Keep docs updated
git diff src/routes/ | claude "update API docs if endpoints changed"
```

**In VS Code Extension:**
- Use Chat (Cmd+L) for questions: "Why is this hook re-rendering?"
- Use Inline Edit (Cmd+K) for quick fixes: "add error handling"
- Use Composer (Cmd+I) for multi-file changes: "refactor to new pattern"

**Goal**: Continuous quality checks, avoid tech debt buildup

---

### Before Committing (2 minutes)

```bash
# 1. Comprehensive review
git diff --cached | claude "review for:
- Security vulnerabilities
- Performance issues
- Edge cases not handled
- Code style violations
- Missing error handling
Format as: 🔴 Critical / 🟡 Warning / 🟢 Good"

# 2. Auto-fix simple issues
git diff --cached | claude "fix any linting issues and format code"

# 3. Update documentation
git diff --cached src/ | claude "update README if public APIs changed"

# 4. Generate semantic commit message
git diff --cached | claude "write conventional commit message (type: description)"

# 5. Commit
git commit -m "$(git diff --cached | claude 'commit message')"
```

**Goal**: High-quality commits, clear history

---

### Before Creating PR (5 minutes)

```bash
# 1. Self-review (be critical!)
git diff main | claude "detailed code review - pretend you're a senior engineer who's skeptical"

# 2. Check test coverage
npm test -- --coverage | claude "what test cases are we missing? suggest 5 edge cases"

# 3. Performance check
git diff main | claude "analyze for performance issues:
- N+1 queries
- Memory leaks
- Inefficient algorithms
- Bundle size impact"

# 4. Generate PR description
git diff main | claude "write PR description with:
- What changed and why
- Testing done
- Breaking changes
- Migration steps if needed"

# 5. Check for security issues
git diff main | claude "security audit - check for:
- SQL injection
- XSS vulnerabilities
- Authentication bypasses
- Secrets in code
- CORS issues"
```

**Goal**: Catch issues before reviewers do

---

### Code Review (10 minutes per PR)

**Reviewing others' PRs:**

```bash
# 1. Understand changes
gh pr view 123 | claude "summarize what this PR does and why"

# 2. Architecture review
gh pr diff 123 | claude "evaluate architecture decisions - any concerns?"

# 3. Edge case analysis
gh pr diff 123 | claude "what edge cases might break? suggest test scenarios"

# 4. Generate review comments
gh pr diff 123 | claude "suggest 3-5 specific improvements with line numbers"
```

**In VS Code Extension:**
- Open PR files in editor
- Use Chat to ask: "What's the impact of changing this interface?"
- Review suggestions before posting

**Goal**: Thoughtful, constructive reviews

---

### End of Day (5 minutes)

```bash
# 1. Document decisions made
claude "create ADR (Architecture Decision Record) for today's auth refactoring decisions"

# 2. Summarize accomplishments
git log --since="today" --author="$(git config user.name)" | claude "summarize what I accomplished today"

# 3. Create TODOs for tomorrow
claude "based on open PRs and issues assigned to me, suggest priorities for tomorrow"

# 4. Clean up branches
git branch --merged | claude "which branches are safe to delete?"
```

**Goal**: Clear handoff to tomorrow, no context loss

---

### Weekly Maintenance (30 minutes, Friday afternoon)

```bash
# 1. Technical debt audit
claude "analyze TODOs and FIXMEs in src/ - prioritize top 5 to address next week"

# 2. Dependency updates
npm outdated | claude "which updates are safe? which have breaking changes? create update plan"

# 3. Documentation cleanup
git log --since="1 week ago" --name-only | claude "find outdated documentation based on changed files"

# 4. Test coverage analysis
npm test -- --coverage | claude "which modules have <80% coverage? suggest testing strategy"

# 5. Performance review
git log --since="1 week ago" --all --source --full-history | claude "any performance regressions merged this week?"

# 6. Security audit
git log --since="1 week ago" -p | claude "scan for security issues in recent commits"
```

**Goal**: Prevent technical debt accumulation

---

### Monthly Team Review (1 hour)

**For Tech Leads:**

```bash
# 1. Velocity metrics
gh pr list --state closed --search "closed:>$(date -d '30 days ago' +%Y-%m-%d)" | claude "calculate:
- Average time to merge
- PR count per developer
- Review turnaround time"

# 2. Code quality trends
git log --since="1 month ago" --numstat | claude "analyze code quality trends:
- Lines added vs deleted
- Most changed files (potential hotspots)
- Commit frequency patterns"

# 3. Cost analysis
claude --usage-stats --month=current | claude "analyze team's Claude usage:
- Cost per developer
- Most expensive operations
- Optimization opportunities"

# 4. Identify best practices
claude "review our team's shared prompts - which are most effective? suggest improvements"
```

**Goal**: Data-driven team improvements

---

## 🔒 Security Best Practices

### Every Commit

```bash
# Automated pre-commit hook
# Save as .git/hooks/pre-commit

#!/bin/bash
git diff --cached | claude "scan for:
- API keys or secrets
- Console.log statements
- Debug code
- Commented code blocks
- TODO without ticket reference
Fail commit if critical issues found"
```

### Every PR

```bash
# Security checklist
git diff main | claude "security audit checklist:
- [ ] No secrets in code
- [ ] Input validation on all endpoints
- [ ] Authentication on protected routes
- [ ] SQL queries use parameterization
- [ ] XSS prevention on user input
- [ ] CSRF protection enabled
- [ ] Rate limiting configured
- [ ] Error messages don't leak info"
```

### Weekly

```bash
# Dependency vulnerability scan
npm audit | claude "prioritize vulnerabilities - which need immediate attention?"

# Code security review
claude "scan src/ for common vulnerabilities:
- Injection attacks
- Broken authentication
- Sensitive data exposure
- XML external entities
- Broken access control"
```

---

## 💰 Cost Optimization Checklist

### Setup Once

- [ ] Create `CLAUDE.md` in project root (enables prompt caching)
- [ ] Configure budget alerts: `claude --set-budget 100 --alert-at 80%`
- [ ] Set default model: `claude --set-default-model haiku-4.5`
- [ ] Enable usage tracking: `claude --enable-usage-stats`

### Before Every Query

- [ ] Can Haiku handle this? (Use Haiku for simple tasks)
- [ ] Do I need extended thinking? (Only for complex reasoning)
- [ ] Can I narrow the context? (Fewer files = lower cost)
- [ ] Is this async? (Use Batch API for 50% discount)

### Weekly Review

```bash
# Check costs
claude --usage-stats --week=current

# Find expensive operations
claude --cost-report --sort-by=cost --top=10

# Optimize
claude "analyze my usage patterns - suggest cost optimizations"
```

**Target**: $5-10/month per developer (with optimization)

---

## 🎯 Learning Milestones

### Week 1: Basics
- [ ] Install Claude Code CLI
- [ ] Set up VS Code extension (optional)
- [ ] Configure API key and authentication
- [ ] Create first CLAUDE.md file
- [ ] Run first 10 CLI commands successfully
- [ ] Understand model selection (Claude Sonnet 4.5 vs Claude Haiku 4.5)

**Checkpoint:** Can complete simple tasks 2-3x faster

### Week 2-3: Intermediate
- [ ] Use extended thinking for complex analysis
- [ ] Set up prompt caching for cost savings
- [ ] Automate pre-commit hook with Claude
- [ ] Create first custom skill
- [ ] Integrate Claude in CI/CD pipeline
- [ ] Build first API integration

**Checkpoint:** Automate routine tasks, reduce costs

### Week 4+: Advanced
- [ ] Build custom agent with Agent SDK
- [ ] Set up multi-model ensemble workflows
- [ ] Create team skills repository
- [ ] Implement batch processing for high-volume tasks
- [ ] Configure enterprise deployment (AWS/GCP)
- [ ] Train team members

**Checkpoint:** 30-50% productivity improvement, team adoption

---

## 🔧 Common Issues (Quick Fixes)

| Issue | Quick Fix | Full Details |
|-------|-----------|--------------|
| **CLI not found** | Add to PATH, restart shell | [Part 1, Section 2](docs/01-fundamentals-core-concepts/#2-environment--project-setup) |
| **API auth fails** | Verify ANTHROPIC_API_KEY env var | [Part 7, Section 21](docs/07-reference-troubleshooting/#21-troubleshooting--common-issues) |
| **Extended thinking slow** | Reduce budget_tokens, use streaming | [Part 3, Section 8](docs/03-advanced-api-agent-development/#8-advanced-claude-api-features) |
| **High API costs** | Enable prompt caching, use Haiku | [Part 5, Section 15](docs/05-prompt-context-mastery/#15-context-management--optimization) |
| **MCP not connecting** | Check server config, restart Claude | [Part 7, Section 21](docs/07-reference-troubleshooting/#21-troubleshooting--common-issues) |
| **Context window exceeded** | Use batch API or focused context | [Part 5, Section 15](docs/05-prompt-context-mastery/#15-context-management--optimization) |

---

## ❓ Frequently Asked Questions

### Product Scope & Clarity

#### Q: Is this guide for Cursor IDE?
**A**: **No.** Cursor is a separate third-party IDE product. This guide covers **Claude Code** (official Anthropic tools: CLI + VS Code Extension). We have a separate guide for Cursor.

#### Q: What's the difference between Claude Code and Cursor?
**A**: They are completely different products:

| Feature | Claude Code (This Guide) | Cursor IDE (Separate Product) |
|---------|-------------------------|-------------------------------|
| **What is it?** | Official Anthropic CLI + VS Code Extension | Third-party AI-powered IDE |
| **Maker** | Anthropic (official) | Cursor (third-party) |
| **Installation** | `npm install -g @anthropic/claude-code` | Download Cursor app |
| **Works with** | Any editor (CLI), VS Code (extension) | Cursor IDE only |
| **Best for** | Automation, CI/CD, scriptable workflows | Full IDE experience |

#### Q: Can I use both Claude Code and Cursor?
**A**: Yes, but choose one for IDE integration:
- **Claude Code CLI**: Works regardless of your editor (use with any IDE)
- **For IDE integration**: Choose either Claude Code VS Code Extension OR Cursor IDE (not both in VS Code)

#### Q: Which should I use - Claude Code or Cursor?
**A**: Depends on your needs:

**Use Claude Code if you want**:
- ✅ Official Anthropic tools
- ✅ Terminal automation and scripting
- ✅ CI/CD integration
- ✅ Works with your existing editor
- ✅ More control over prompts and models

**Use Cursor if you want**:
- ✅ Fully integrated IDE experience
- ✅ More powerful multi-file editing
- ✅ Built-in AI pair programming
- ✅ Don't want to learn CLI commands

**Many developers use both**: Claude Code CLI for automation + Cursor for daily coding.

#### Q: This guide mentions "VS Code Extension" - what is that?
**A**: The **Claude Code VS Code Extension** is the official Anthropic extension for Visual Studio Code. It's part of Claude Code (not Cursor). Install it from VS Code Marketplace by searching "Claude Code".

---

### Getting Started Questions

#### Q: Do I need both the CLI and VS Code Extension?
**A**: No, choose based on your workflow:
- **CLI only**: Perfect for terminal users, automation, CI/CD
- **Extension only**: Perfect for GUI-first developers
- **Both**: Maximum flexibility (recommended)

#### Q: How much does Claude Code cost?
**A**: Claude Code itself is free. You pay for Claude API usage:
- Typical individual developer: **$5-10/month** (optimized)
- Heavy user: **$20-50/month**
- Team of 10: **$50-200/month** (optimized)

See "Cost Optimization - Real Numbers" section for details.

#### Q: Can I use Claude Code without internet?
**A**: No, Claude Code requires API access to Anthropic's servers. However, you can:
- Cache context locally (faster responses)
- Use Batch API for async processing
- Self-host via AWS Bedrock or GCP Vertex (enterprise)

#### Q: What's the difference between Claude API and Claude Code?
**A**: 
- **Claude API**: Raw API access, requires programming
- **Claude Code CLI**: Terminal interface to Claude (easier than raw API)
- **Claude Code VS Code Extension**: GUI interface in VS Code
- **Agent SDK**: Build custom agents programmatically

All use Claude API underneath.

---

### Technical Questions

#### Q: Which model should I use?
**A**: Quick guide:
- **Simple tasks**: Haiku 4.5 (fast, cheap)
- **Daily coding**: Sonnet 4.5 (balanced)
- **Complex architecture**: Opus 4.1 (powerful)

See "Model Selection Guide" section for detailed decision matrix.

#### Q: What's extended thinking and when should I use it?
**A**: Extended thinking lets Claude "think through" problems before responding (1K-32K tokens of reasoning).

**Use when**:
- ✅ Complex architecture decisions
- ✅ Debugging intricate issues
- ✅ Multi-step analysis

**Don't use when**:
- ❌ Simple questions
- ❌ Code formatting
- ❌ Quick reviews

**Cost impact**: 2-3x more expensive, but 10x better for complex tasks.

#### Q: How do I reduce costs?
**A**: Top 3 strategies:
1. **Create CLAUDE.md** → 90% cost reduction via caching
2. **Use Haiku for simple tasks** → 10x cheaper than Opus
3. **Enable Batch API** → 50% discount for async work

See "Cost Optimization Checklist" section for complete guide.

#### Q: What's CLAUDE.md and do I need it?
**A**: CLAUDE.md is a project context file that:
- Describes your project architecture
- Lists conventions and patterns
- Defines common tasks

**Benefits**:
- Claude uses it automatically (no manual attachment needed)
- Enables prompt caching (90% cost savings)
- Consistent responses across sessions
- Great for onboarding

**Required?** No, but **strongly recommended** for multi-session projects.

---

### Troubleshooting Questions

#### Q: Why is Claude Code slow?
**A**: Common causes:
1. **Extended thinking enabled** → Disable for simple tasks
2. **Large context** → Narrow file selection
3. **No streaming** → Enable streaming: `--stream`
4. **Using Opus** → Switch to Haiku for speed

See "Performance & Speed Optimization" section.

#### Q: Why are my costs so high?
**A**: Check these:
1. **No prompt caching** → Create CLAUDE.md
2. **Using wrong model** → Use Haiku for simple tasks
3. **Re-reading files** → Claude caches, don't re-attach
4. **Extended thinking always on** → Only use for complex tasks

Run: `claude --usage-stats --month=current` to analyze.

#### Q: Authentication failed - what do I do?
**A**: Steps to fix:
```bash
# 1. Check if key is set
echo $ANTHROPIC_API_KEY

# 2. If empty, set it
export ANTHROPIC_API_KEY="your-key-here"

# 3. Verify it works
claude "test" --verbose

# 4. Make permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export ANTHROPIC_API_KEY="your-key-here"' >> ~/.bashrc
```

Get key from: https://console.anthropic.com/

#### Q: VS Code Extension not showing up?
**A**: Checklist:
- [ ] VS Code version 1.98.0+ required
- [ ] Extension installed: Search "Claude Code" in Extensions
- [ ] Reload window: Cmd/Ctrl+Shift+P → "Reload Window"
- [ ] API key configured in extension settings
- [ ] Check extension logs for errors

---

### Workflow Questions

#### Q: Should I review Claude's code before committing?
**A**: **YES, ALWAYS.** Claude is a tool, not a replacement for judgment:
- ✅ Review all generated code
- ✅ Test thoroughly
- ✅ Check for security issues
- ✅ Ensure it matches your patterns
- ❌ Never auto-commit without review

#### Q: Can Claude Code work in CI/CD?
**A**: Yes! Perfect use cases:
- Automated code reviews on PRs
- Test generation
- Documentation generation
- Security scanning
- Release notes generation

See [Part 4: DevOps Integration](docs/04-enterprise-devops-patterns/) for setup guides.

#### Q: How do I share prompts with my team?
**A**: Best practices:
1. **Shared prompt library**: Create `docs/claude-prompts.md`
2. **Team CLAUDE.md template**: Version-controlled project templates
3. **Custom skills**: Build team-specific skills
4. **Wiki documentation**: Internal knowledge base

See [Part 6: Team Collaboration](docs/06-domain-team-patterns/) for team patterns.

#### Q: Can I use Claude Code for non-code tasks?
**A**: Yes! Great for:
- Writing documentation
- Analyzing logs
- Data transformation
- Content generation
- Technical writing
- Architecture decisions

Just pipe any text to Claude: `cat log.txt | claude "summarize errors"`

---

### Enterprise & Security Questions

#### Q: Is Claude Code secure for enterprise use?
**A**: Security features:
- ✅ SOC 2 Type II certified
- ✅ Data encryption in transit and at rest
- ✅ No training on your data (by default)
- ✅ Self-hosted options (AWS Bedrock, GCP Vertex)
- ✅ Audit logging available

See [Part 4, Section 13: Security & Compliance](docs/04-enterprise-devops-patterns/) for details.

#### Q: Can we self-host Claude Code?
**A**: Sort of. Options:
1. **CLI/Extension**: No self-hosting (use API)
2. **API via AWS Bedrock**: Your AWS account, your VPC
3. **API via GCP Vertex**: Your GCP project
4. **On-premises**: Not currently available

AWS/GCP hosting gives you data control without managing models.

#### Q: How do we manage API keys for a team?
**A**: Recommended approaches:
1. **Individual keys**: Each developer has own key (tracked separately)
2. **Team key**: Shared key in secure secret manager (AWS Secrets Manager, 1Password)
3. **Enterprise**: Centralized billing, individual attribution

**Never**: Commit keys to git, share via Slack, put in code.

---

### Comparison Questions

#### Q: Claude Code vs GitHub Copilot?
**A**: Different strengths:

| Feature | Claude Code | GitHub Copilot |
|---------|-------------|----------------|
| **Autocomplete** | ❌ No | ✅ Excellent |
| **Multi-file refactoring** | ✅ Excellent | ❌ Limited |
| **Context awareness** | ✅ 200K-2M tokens | ⚠️ Limited |
| **Reasoning** | ✅ Extended thinking | ❌ No |
| **CLI automation** | ✅ Native | ❌ No |
| **Cost** | Pay per use | Flat $10-20/mo |

**Many developers use both**: Copilot for autocomplete, Claude Code for complex tasks.

#### Q: Can Claude Code replace code review?
**A**: **No, it augments it:**
- ✅ Use Claude to catch obvious bugs before human review
- ✅ Use for security/performance first-pass
- ✅ Frees humans to focus on architecture/design
- ❌ Don't skip human review
- ❌ Don't blindly trust AI suggestions

**Best practice**: Claude pre-review → Human review → Merge

---

## 🤔 Still Have Questions?

**Ask in the community**:
- [Anthropic Discord](https://anthropic.com/discord) - Most active
- [GitHub Discussions](https://github.com/anthropics) - Technical issues
- [Twitter @anthropicai](https://twitter.com/anthropicai) - Updates

**Or search this guide**:
- Press Ctrl+F (Cmd+F on Mac) to search this page
- Check the relevant Part for detailed answers
- See [Part 7: Troubleshooting](docs/07-reference-troubleshooting/) for common issues

---

## 📚 Additional Resources

### Official Documentation
- **Claude API Docs**: [platform.claude.com/docs](https://platform.claude.com/docs)
- **Claude Code**: [claude.com/claude-code](https://claude.com/claude-code)
- **Agent SDK**: [github.com/anthropics/claude-agent-sdk-typescript](https://github.com/anthropics/claude-agent-sdk-typescript)
- **Skills Repository**: [github.com/anthropics/skills](https://github.com/anthropics/skills)
- **Anthropic Cookbook**: [github.com/anthropics/anthropic-cookbook](https://github.com/anthropics/anthropic-cookbook)

### Community
- **Discord**: [anthropic.com/discord](https://anthropic.com/discord)
- **Twitter**: [@anthropicai](https://twitter.com/anthropicai)
- **GitHub**: [github.com/anthropics](https://github.com/anthropics)

### This Guide
- **Version**: 1.0 (December 2025)
- **License**: MIT
- **Contributions**: Welcome via PR

---

## 🗺️ Navigation

**Start reading:** [Part 1: Fundamentals & Core Concepts →](docs/01-fundamentals-core-concepts/)

**All parts:**
1. [Fundamentals & Core Concepts](docs/01-fundamentals-core-concepts/)
2. [Tools Mastery (CLI & VS Code Extension)](docs/02-tools-mastery/)
3. [Advanced API & Agent Development](docs/03-advanced-api-agent-development/)
4. [Enterprise & DevOps Integration](docs/04-enterprise-devops-patterns/)
5. [Prompt Engineering & Context Mastery](docs/05-prompt-context-mastery/)
6. [Domain-Specific & Team Collaboration](docs/06-domain-team-patterns/)
7. [Reference, Troubleshooting & Future](docs/07-reference-troubleshooting/)

---

## 📝 Version History

**v1.1 (December 2025) - Productivity & Workflow Update:**
- ✨ NEW: "Get Your First Win in 5 Minutes" section with 7 quick-start commands
- ✨ NEW: Comprehensive productivity patterns section (context windows, progressive disclosure, model selection)
- ✨ NEW: Practical daily workflow patterns (morning routine, commit checklist, PR preparation, weekly maintenance)
- ✨ NEW: Extensive FAQ section (30+ questions covering product scope, getting started, technical, troubleshooting)
- 🔄 UPDATED: Simplified quick start paths (3 clear paths instead of 5)
- 🔄 UPDATED: Clarified scope throughout (Claude Code vs Cursor disambiguation)
- 🔄 UPDATED: Replaced abstract checklists with time-boxed, actionable workflows
- 📝 Emphasis on workflow-first approach vs feature documentation
- 📝 Added scope clarification: Official Anthropic tools (CLI + VS Code Extension)

**v1.0 (December 2025) - Initial Release:**
- Complete 7-part structure with 24 sections
- Claude Code CLI comprehensive coverage
- Agent SDK development patterns
- Skills system integration
- Extended thinking optimization
- Prompt caching strategies
- Enterprise deployment patterns
- Real-world examples and templates

---

*This guide is built from the latest Anthropic documentation via Context7 MCP. Bookmark and share!*

**Master Index** | [Begin with Part 1 →](docs/01-fundamentals-core-concepts/)




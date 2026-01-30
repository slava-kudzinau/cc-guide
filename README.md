---
title: Home
nav_order: 1
---

# Claude Code: Complete Technical Guide for Senior Developers
## Master Index & Navigation

**Author**: AI-Generated Technical Guide  
**Maintainer**: [Viachaslau Kudzinau](mailto:viachaslau_kudzinau@epam.com)
**Version**: 2.0  
**Last Updated**: January 2026  
**Based on**: Latest Claude Code, API, and Agent SDK documentation

[![GitHub](https://img.shields.io/badge/GitHub-cc--guide-181717?logo=github)](https://github.com/slava-kudzinau/cc-guide)  
**📂 [View source & contribute on GitHub](https://github.com/slava-kudzinau/cc-guide)** — docs, examples, and full guide in one repo.

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

## 💡 Key Concepts to Master

**Context Windows**: Claude has 200K-2M token context windows - use them! Don't be afraid to attach multiple files for better understanding.

**CLAUDE.md**: Create this file in your project root for automatic context caching and 90% cost reduction. See [CLAUDE.md Guide](docs/01-fundamentals-core-concepts/03-claude-md-guide.md).

**Model Selection**: Use Haiku for speed, Sonnet for daily work, Opus for complex reasoning. See [Mental Models](docs/01-fundamentals-core-concepts/01-mental-models.md) for the complete decision matrix.

**Cost Optimization**: Enable prompt caching, choose the right model, and minimize context size. Full strategies in [Optimization Guide](docs/05-prompt-context-mastery/02-optimization-guide.md).

**Context7 for Latest Docs**: When working with rapidly evolving frameworks, use Context7 MCP to access current documentation. Especially useful for frameworks with recent releases.

---

## 🎯 Quick Navigation

**Tool Selection**: Use CLI for automation/CI/CD, VS Code Extension for interactive coding, or both for hybrid workflows. See [CLI vs VS Code](docs/02-tools-mastery/04-cli-vs-vscode.md) for detailed comparison.

**Performance**: Enable streaming, use prompt caching with CLAUDE.md, and leverage parallel operations. Full guide: [Performance Optimization](docs/05-prompt-context-mastery/02-optimization-guide.md).

**Workflows**: Morning routines, commit checklists, PR preparation, and more in [Day-in-the-Life Guide](docs/01-fundamentals-core-concepts/05-daily-workflows.md).

**Troubleshooting**: See [Troubleshooting Guide](docs/07-reference-troubleshooting/02-troubleshooting.md) for solutions to common issues.

**FAQ**: Questions about Claude Code vs Cursor, costs, security, and more in [FAQ](docs/07-reference-troubleshooting/06-faq.md).

---

## 🗂️ Guide Structure

### [Part 1: Fundamentals & Core Concepts](docs/01-fundamentals-core-concepts/)
**Essential foundations for all users**

**Sections Covered:**
1. **Mental Models & Architecture** - Understanding Claude's ecosystem
   - Model family (Claude 4 family: Opus 4.5, Sonnet 4/4.5, Haiku 4.5, plus legacy Sonnet 3.7)
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
   - Project configuration (CLAUDE.md, .claude/settings.json)
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
   - CLI configuration (settings.json)

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
    - Choosing between Claude Opus 4.5, Claude Sonnet 4.5, Claude Haiku 4.5, and legacy models
    - Model ensemble patterns
    - Cost vs performance trade-offs
    - Latency optimization
    - Fallback strategies

**Key Takeaways:**
- Extended thinking for planning, Claude Haiku 4.5 for speed
- Prompt caching significantly reduces repeated context costs
- CLAUDE.md provides persistent project context
- Chain models: Claude Opus 4.5 for architecture, Claude Sonnet 4.5 for implementation

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
   # macOS/Linux/WSL (Recommended)
   curl -fsSL https://claude.ai/install.sh | bash

   # Windows PowerShell
   irm https://claude.ai/install.ps1 | iex

   # Homebrew (macOS)
   brew install --cask claude-code

   # WinGet (Windows)
   winget install Anthropic.ClaudeCode

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

## 📋 Quick Reference Card

| Category | Quick Guide | See Also |
|----------|-------------|----------|
| **Tools** | CLI (automation) • VS Code (interactive) • API (integration) • Agent SDK (custom agents) | [Tool Selection](docs/01-fundamentals-core-concepts/01-mental-models.md) |
| **Models** | Haiku (speed) • Sonnet (daily work) • Opus (complex reasoning) | [Model Guide](docs/01-fundamentals-core-concepts/01-mental-models.md) |
| **Commands** | `claude` (interactive) • `claude "task"` (one-shot) • `git diff \| claude "review"` (piped) | [CLI Workflows](docs/02-tools-mastery/01-terminal-workflows.md) |
| **Cost Tips** | Create CLAUDE.md (90% savings) • Use Haiku for simple tasks • Batch API (50% off) | [Optimization Guide](docs/05-prompt-context-mastery/02-optimization-guide.md) |
| **Troubleshooting** | Check API key • Enable streaming • Narrow context • Use right model | [Troubleshooting](docs/07-reference-troubleshooting/02-troubleshooting.md) |


---

## ❓ Questions?

See the comprehensive [FAQ](docs/07-reference-troubleshooting/06-faq.md) covering:
- **Product Scope**: Claude Code vs Cursor, tool selection
- **Getting Started**: Installation, costs, requirements
- **Technical**: Model selection, extended thinking, CLAUDE.md
- **Troubleshooting**: Performance, costs, authentication
- **Workflows**: Best practices, CI/CD, team collaboration
- **Enterprise**: Security, self-hosting, key management
- **Comparisons**: Claude Code vs GitHub Copilot and other tools

**Need help?** Check [Troubleshooting Guide](docs/07-reference-troubleshooting/02-troubleshooting.md) or ask in the [Anthropic Discord](https://anthropic.com/discord)

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




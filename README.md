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
- Claude Code CLI mastery (terminal-first workflows)
- Claude API integration (extended thinking, vision, batching)
- Agent SDK development (programmatic agent building)
- Skills system (dynamic knowledge loading)
- Model Context Protocol (MCP) integration
- Enterprise deployment patterns (AWS, GCP hosting)
- DevOps & CI/CD automation
- Advanced prompt engineering & context optimization
- Real-world workflows and templates

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

### [Part 2: Claude Code CLI Mastery](docs/02-cli-mastery/)
**Comprehensive terminal workflows and automation**

**Sections Covered:**
4. **Terminal Workflows & Command Patterns**
   - CLI basics and command structure
   - Interactive vs command mode
   - Natural language commands
   - Piping and Unix composition
   - Session management
   - CLI configuration (.clauderc)

5. **CLI Automation & Scripting**
   - Scripting in bash/zsh/PowerShell
   - Pre-commit hooks and automation
   - CI/CD integration patterns
   - Batch operations
   - Error handling strategies
   - Non-interactive mode

6. **CLI vs VS Code Extension**
   - Decision matrix for tool selection
   - CLI advantages (scriptability, CI/CD)
   - VS Code advantages (GUI, visual feedback)
   - Hybrid workflows
   - Performance comparison

7. **Advanced CLI Patterns**
   - Multi-repository workflows
   - Monorepo navigation
   - Parallel execution patterns
   - Tool integration (git, docker, kubectl)
   - Terminal multiplexing
   - Remote execution (SSH, cloud shells)

**Key Takeaways:**
- CLI enables scriptable, automatable workflows
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

## 🚀 Quick Start Paths

### For New Users (Start Here!)
1. [Part 1: Fundamentals](docs/01-fundamentals-core-concepts/) - Sections 1-3
2. [Part 2: CLI Basics](docs/02-cli-mastery/) - Section 4
3. [Part 7: Reference](docs/07-reference-troubleshooting/) - Section 20

**Time investment:** 45-60 minutes  
**Outcome:** Install tools, understand basics, run first commands

### For Individual Contributors
1. [Part 1: Core Workflows](docs/01-fundamentals-core-concepts/) - Section 3
2. [Part 2: CLI Mastery](docs/02-cli-mastery/) - Sections 4-7
3. [Part 3: API Basics](docs/03-advanced-api-agent-development/) - Section 8
4. [Part 5: Prompting](docs/05-prompt-context-mastery/) - Sections 14-15

**Time investment:** 3-4 hours  
**Outcome:** Daily workflow mastery, automation, advanced prompts

### For DevOps/Platform Engineers
1. [Part 1: Fundamentals](docs/01-fundamentals-core-concepts/) - Sections 1-2
2. [Part 2: CLI Automation](docs/02-cli-mastery/) - Sections 5, 7
3. [Part 4: DevOps Integration](docs/04-enterprise-devops-patterns/) - Sections 11-13
4. [Part 7: Reference](docs/07-reference-troubleshooting/) - Section 20

**Time investment:** 3-4 hours  
**Outcome:** CI/CD automation, IaC generation, security scanning

### For Backend/API Developers
1. [Part 1: Fundamentals](docs/01-fundamentals-core-concepts/) - Sections 1-3
2. [Part 3: API & Agents](docs/03-advanced-api-agent-development/) - Sections 8-10
3. [Part 4: Architecture](docs/04-enterprise-devops-patterns/) - Section 12
4. [Part 6: Backend Workflows](docs/06-domain-team-patterns/) - Section 17

**Time investment:** 3-4 hours  
**Outcome:** API integration, agent development, system design automation

### For Team Leads
1. [Part 1: Setup](docs/01-fundamentals-core-concepts/) - Section 2
2. [Part 5: Context Management](docs/05-prompt-context-mastery/) - Section 15
3. [Part 6: Team Collaboration](docs/06-domain-team-patterns/) - Sections 18-19
4. [Part 7: Benchmarks](docs/07-reference-troubleshooting/) - Section 22

**Time investment:** 3-4 hours  
**Outcome:** Team setup, shared configs, ROI calculations, metrics

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

## 💡 Best Practices Summary

### Daily Workflow Checklist
- [ ] Use CLAUDE.md for project context
- [ ] Start with extended thinking for complex tasks
- [ ] Pipe command outputs to Claude for analysis
- [ ] Cache frequently used context (90% savings)
- [ ] Review generated code before accepting
- [ ] Track costs with budget monitoring

### Prompt Engineering Checklist
- [ ] Be specific about desired output format
- [ ] Provide relevant context (files, docs, examples)
- [ ] Use XML tags for structured prompts
- [ ] Specify constraints (what NOT to change)
- [ ] Include examples for consistent output
- [ ] Leverage extended thinking for reasoning

### Team Collaboration Checklist
- [ ] Maintain shared CLAUDE.md templates
- [ ] Create team-specific skills repository
- [ ] Document effective prompts in wiki
- [ ] Code review all AI-generated code
- [ ] Track velocity metrics (time-to-PR)
- [ ] Share automation scripts

### Security & Compliance Checklist
- [ ] Never commit API keys (.claudeignore)
- [ ] Use environment variables for secrets
- [ ] Enable audit logging for enterprise
- [ ] Review generated code for vulnerabilities
- [ ] Use compliance-specific skills
- [ ] Test on non-production data first

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
2. [Claude Code CLI Mastery](docs/02-cli-mastery/)
3. [Advanced API & Agent Development](docs/03-advanced-api-agent-development/)
4. [Enterprise & DevOps Integration](docs/04-enterprise-devops-patterns/)
5. [Prompt Engineering & Context Mastery](docs/05-prompt-context-mastery/)
6. [Domain-Specific & Team Collaboration](docs/06-domain-team-patterns/)
7. [Reference, Troubleshooting & Future](docs/07-reference-troubleshooting/)

---

## 📝 Version History

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




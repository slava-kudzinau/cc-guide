---
title: "Section 06: Frequently Asked Questions"
parent: "Part 7: Reference, Troubleshooting & Future"
nav_order: 6
---

# Frequently Asked Questions

**Quick answers to common questions about Claude Code.** For detailed guides, follow the links to relevant documentation sections.

---

## Product Scope & Clarity

### Q: Is this guide for Cursor IDE?
**A**: **No.** Cursor is a separate third-party IDE product. This guide covers **Claude Code** (official Anthropic tools: CLI + VS Code Extension). We have a separate guide for Cursor.

### Q: What's the difference between Claude Code and Cursor?
**A**: They are completely different products:

| Feature | Claude Code (This Guide) | Cursor IDE (Separate Product) |
|---------|-------------------------|-------------------------------|
| **What is it?** | Official Anthropic CLI + VS Code Extension | Third-party AI-powered IDE |
| **Maker** | Anthropic (official) | Cursor (third-party) |
| **Installation** | `curl https://claude.ai/install.sh \| bash` | Download Cursor app |
| **Works with** | Any editor (CLI), VS Code (extension) | Cursor IDE only |
| **Best for** | Automation, CI/CD, scriptable workflows | Full IDE experience |

### Q: Can I use both Claude Code and Cursor?
**A**: Yes, but choose one for IDE integration:
- **Claude Code CLI**: Works regardless of your editor (use with any IDE)
- **For IDE integration**: Choose either Claude Code VS Code Extension OR Cursor IDE (not both in VS Code)

### Q: Which should I use - Claude Code or Cursor?
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

### Q: This guide mentions "VS Code Extension" - what is that?
**A**: The **Claude Code VS Code Extension** is the official Anthropic extension for Visual Studio Code. It's part of Claude Code (not Cursor). Install it from VS Code Marketplace by searching "Claude Code".

---

## Getting Started Questions

### Q: Do I need both the CLI and VS Code Extension?
**A**: No, choose based on your workflow:
- **CLI only**: Perfect for terminal users, automation, CI/CD
- **Extension only**: Perfect for GUI-first developers
- **Both**: Maximum flexibility (recommended)

### Q: How much does Claude Code cost?
**A**: Claude Code itself is free. You pay for Claude API usage:
- Typical individual developer: **$5-10/month** (optimized)
- Heavy user: **$20-50/month**
- Team of 10: **$50-200/month** (optimized)

See [Cost Optimization Guide](../05-prompt-context-mastery/02-optimization-guide.md) for detailed strategies.

### Q: Can I use Claude Code without internet?
**A**: No, Claude Code requires API access to Anthropic's servers. However, you can:
- Cache context locally (faster responses)
- Use Batch API for async processing
- Self-host via AWS Bedrock or GCP Vertex (enterprise)

### Q: What's the difference between Claude API and Claude Code?
**A**: 
- **Claude API**: Raw API access, requires programming
- **Claude Code CLI**: Terminal interface to Claude (easier than raw API)
- **Claude Code VS Code Extension**: GUI interface in VS Code
- **Agent SDK**: Build custom agents programmatically

All use Claude API underneath.

---

## Technical Questions

### Q: Which model should I use?
**A**: Quick guide:
- **Simple tasks**: Haiku 4.5 (fast, cost-effective)
- **Daily coding**: Sonnet 4.5 (balanced)
- **Complex architecture**: Opus 4.5 (powerful)

See [Mental Models & Architecture](../01-fundamentals-core-concepts/01-mental-models.md) for detailed decision matrix.

### Q: What's extended thinking and when should I use it?
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

### Q: How do I reduce costs?
**A**: Top 3 strategies:
1. **Create CLAUDE.md** → 90% cost reduction via caching
2. **Use Haiku for simple tasks** → 10x cheaper than Opus
3. **Enable Batch API** → 50% discount for async work

See [Cost Optimization Guide](../05-prompt-context-mastery/02-optimization-guide.md) for complete strategies.

### Q: What's CLAUDE.md and do I need it?
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

See [CLAUDE.md Guide](../01-fundamentals-core-concepts/03-claude-md-guide.md) for templates and examples.

---

## Troubleshooting Questions

### Q: Why is Claude Code slow?
**A**: Common causes:
1. **Extended thinking enabled** → Disable for simple tasks
2. **Large context** → Narrow file selection
3. **No streaming** → Enable streaming: `--stream`
4. **Using Opus** → Switch to Haiku for speed

See [Performance Optimization](../05-prompt-context-mastery/02-optimization-guide.md#part-c-speed-optimization) for detailed solutions.

### Q: Why are my costs so high?
**A**: Check these:
1. **No prompt caching** → Create CLAUDE.md
2. **Using wrong model** → Use Haiku for simple tasks
3. **Re-reading files** → Claude caches, don't re-attach
4. **Extended thinking always on** → Only use for complex tasks

Run: `claude --usage-stats --month=current` to analyze.

See [Cost Optimization](../05-prompt-context-mastery/02-optimization-guide.md) for detailed strategies.

### Q: Authentication failed - what do I do?
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

### Q: VS Code Extension not showing up?
**A**: Checklist:
- [ ] VS Code version 1.98.0+ required
- [ ] Extension installed: Search "Claude Code" in Extensions
- [ ] Reload window: Cmd/Ctrl+Shift+P → "Reload Window"
- [ ] API key configured in extension settings
- [ ] Check extension logs for errors

See [Troubleshooting Guide](02-troubleshooting.md) for comprehensive solutions.

---

## Workflow Questions

### Q: Should I review Claude's code before committing?
**A**: **YES, ALWAYS.** Claude is a tool, not a replacement for judgment:
- ✅ Review all generated code
- ✅ Test thoroughly
- ✅ Check for security issues
- ✅ Ensure it matches your patterns
- ❌ Never auto-commit without review

See [PR Review Guide](05-pr-review-guide.md) for AI code review checklist.

### Q: Can Claude Code work in CI/CD?
**A**: Yes! Perfect use cases:
- Automated code reviews on PRs
- Test generation
- Documentation generation
- Security scanning
- Release notes generation

See [DevOps Integration](../04-enterprise-devops-patterns/01-devops-cicd.md) for setup guides.

### Q: How do I share prompts with my team?
**A**: Best practices:
1. **Shared prompt library**: Create `docs/claude-prompts.md`
2. **Team CLAUDE.md template**: Version-controlled project templates
3. **Custom skills**: Build team-specific skills
4. **Wiki documentation**: Internal knowledge base

See [Team Collaboration](../06-domain-team-patterns/03-team-adoption.md) for team patterns.

### Q: Can I use Claude Code for non-code tasks?
**A**: Yes! Great for:
- Writing documentation
- Analyzing logs
- Data transformation
- Content generation
- Technical writing
- Architecture decisions

Just pipe any text to Claude: `cat log.txt | claude "summarize errors"`

---

## Enterprise & Security Questions

### Q: Is Claude Code secure for enterprise use?
**A**: Security features:
- ✅ SOC 2 Type II certified
- ✅ Data encryption in transit and at rest
- ✅ No training on your data (by default)
- ✅ Self-hosted options (AWS Bedrock, GCP Vertex)
- ✅ Audit logging available

See [Security & Compliance](../04-enterprise-devops-patterns/03-security-compliance.md) for details.

### Q: Can we self-host Claude Code?
**A**: Sort of. Options:
1. **CLI/Extension**: No self-hosting (use API)
2. **API via AWS Bedrock**: Your AWS account, your VPC
3. **API via GCP Vertex**: Your GCP project
4. **On-premises**: Not currently available

AWS/GCP hosting gives you data control without managing models.

### Q: How do we manage API keys for a team?
**A**: Recommended approaches:
1. **Individual keys**: Each developer has own key (tracked separately)
2. **Team key**: Shared key in secure secret manager (AWS Secrets Manager, 1Password)
3. **Enterprise**: Centralized billing, individual attribution

**Never**: Commit keys to git, share via Slack, put in code.

---

## Comparison Questions

### Q: Claude Code vs GitHub Copilot?
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

### Q: Can Claude Code replace code review?
**A**: **No, it augments it:**
- ✅ Use Claude to catch obvious bugs before human review
- ✅ Use for security/performance first-pass
- ✅ Frees humans to focus on architecture/design
- ❌ Don't skip human review
- ❌ Don't blindly trust AI suggestions

**Best practice**: Claude pre-review → Human review → Merge

---

## Still Have Questions?

**Ask in the community**:
- [Anthropic Discord](https://anthropic.com/discord) - Most active
- [GitHub Discussions](https://github.com/anthropics) - Technical issues
- [Twitter @anthropicai](https://twitter.com/anthropicai) - Updates

**Or search this guide**:
- Check the relevant Part for detailed answers
- See [Troubleshooting Guide](02-troubleshooting.md) for common issues
- Review [Anti-Patterns](04-antipatterns.md) for common mistakes

---

[← Back: PR Review Guide](05-pr-review-guide.md) | [Up: Part 7 Index](README.md)

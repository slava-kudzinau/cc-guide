---
title: "Section 1: Mental Models & Architecture"
parent: "Part 1: Fundamentals & Core Concepts"
nav_order: 1
---

# Section 1: Mental Models & Architecture

## Understanding Claude's Ecosystem

Claude offers multiple tools and interfaces for different use cases. Understanding the architecture helps you choose the right tool for each task.

```mermaid
graph TD
    User[Developer] --> CLI[Claude Code CLI]
    User --> VSCode[VS Code Extension]
    User --> API[Claude API]
    User --> SDK[Agent SDK]
    
    CLI --> Models[Claude Models]
    VSCode --> Models
    API --> Models
    SDK --> Models
    
    Models --> Sonnet45[Claude Sonnet 4.5<br/>Balanced]
    Models --> Haiku45[Claude Haiku 4.5<br/>Fast]
    Models --> Opus45[Claude Opus 4.5<br/>Most Capable]
    
    CLI --> MCP[MCP Servers]
    VSCode --> MCP
    SDK --> MCP
    
    CLI --> Skills[Skills System]
    
    MCP --> External[External Data<br/>Drive, Jira, Figma]
```

---

## 1.1 Model Family Overview

### Active Models (December 2025)

> **Note:** "Claude 4" is the family name, not a specific model. Always specify the complete model name: Claude Opus 4.5, Claude Sonnet 4.5, or Claude Haiku 4.5.

| Model | Best For | Speed | Context Window |
|-------|----------|-------|----------------|
| **Claude Opus 4.5** | Complex reasoning, architecture | Moderate | 200K |
| **Claude Sonnet 4.5** | **Daily coding (recommended)** | Fast | 200K |
| **Claude Haiku 4.5** | Speed + cost optimization | Fastest | 200K |

In Claude Code, the `opus` alias maps to Opus 4.5 ([model configuration](https://code.claude.com/docs/en/model-config)).

**All models support:**
- ✅ Extended thinking
- ✅ Vision (text + image input)
- ✅ Tool use / function calling
- ✅ Batch processing (2M tokens)
- ✅ Prompt caching
- ✅ Multilingual capabilities

**API Model Identifiers:** Use the `opus` alias in Claude Code, or see [Model names (Claude API)](https://docs.claude.com/en/docs/about-claude/models/overview#model-names) / [Model configuration](https://code.claude.com/docs/en/model-config) for current Opus 4.5 model IDs.
- Claude Sonnet 4.5 → `claude-sonnet-4-5-20250929`
- Claude Haiku 4.5 → `claude-haiku-4-5-20250403`

> **Note:** Model identifiers may include date suffixes. Use the latest available version or the `opus` / `sonnet` / `haiku` aliases in Claude Code for the current flagship models.

### Model Selection Decision Tree

```mermaid
graph TD
    Start{What's your<br/>primary need?}
    
    Start -->|Speed + Cost| Haiku[Claude Haiku 4.5<br/>Cost-effective]
    Start -->|Balanced| Sonnet[Claude Sonnet 4.5<br/>Recommended]
    Start -->|Max Intelligence| Opus[Claude Opus 4.5<br/>Most Capable]
    
    Start -->|Complex Reasoning| Extended{Need extended<br/>thinking?}
    Extended -->|Yes| SonnetExt[Claude Sonnet 4.5<br/>with 5K-10K budget]
    Extended -->|Very Complex| OpusExt[Claude Opus 4.5<br/>with 10K-32K budget]
    
    Start -->|High Volume| Batch[Any Model<br/>with Batch API<br/>Cost optimized]
```

### When to Use Each Model

**Claude Haiku 4.5** - Speed & Cost Priority
- Quick code completions
- Simple refactoring
- Documentation generation
- High-volume API calls
- Real-time chat interactions
- **Trade-off:** Significantly more cost-effective than Opus

**Claude Sonnet 4.5** - Daily Workhorse (Recommended)
- Feature development
- Code review
- Bug fixes and debugging
- Test generation
- API design
- **Sweet spot:** Faster than Opus, nearly as capable

**Claude Opus 4.5** - Complex Tasks
- System architecture design
- Complex algorithm implementation
- Security analysis
- Multi-step reasoning
- Research and analysis
- **Use strategically:** Most capable for complex reasoning

---

## 1.2 Tool Selection Matrix

### Claude Code CLI vs API vs Agent SDK vs VS Code

| Feature | CLI | API | Agent SDK | VS Code Ext |
|---------|-----|-----|-----------|-------------|
| **Interactive use** | ✅ Excellent | ❌ No | ❌ No | ✅ Excellent |
| **Automation** | ✅ Scriptable | ✅ Programmatic | ✅ Full control | ⚠️ Limited |
| **CI/CD integration** | ✅ Perfect | ✅ Perfect | ✅ Perfect | ❌ No |
| **Visual feedback** | ⚠️ Terminal only | ❌ No | ❌ No | ✅ Rich UI |
| **Custom agents** | ❌ No | ⚠️ Limited | ✅ Full control | ❌ No |
| **Piping/composition** | ✅ Unix style | ❌ No | ⚠️ Programmatic | ❌ No |
| **Learning curve** | Low | Medium | High | Lowest |
| **Flexibility** | Medium | High | Highest | Low |

### Decision Matrix: Which Tool to Use?

**Use Claude Code CLI when:**
- ✅ Working in terminal primarily
- ✅ Need to pipe command outputs
- ✅ Automating workflows (scripts, hooks)
- ✅ CI/CD integration
- ✅ Quick interactive questions
- ✅ Team uses terminal-based workflows

**Use Claude API when:**
- ✅ Building applications with AI features
- ✅ Need programmatic control
- ✅ Integrating into existing systems
- ✅ Custom UI requirements
- ✅ High-volume processing (batches)
- ✅ Need fine-grained control over requests

**Use Agent SDK when:**
- ✅ Building custom autonomous agents
- ✅ Need multi-agent orchestration
- ✅ Require custom tool integration
- ✅ Complex workflow automation
- ✅ Advanced permission control
- ✅ Subagent patterns

**Use VS Code Extension when:**
- ✅ Prefer GUI over terminal
- ✅ Visual coding feedback needed
- ✅ Not comfortable with CLI
- ✅ Occasional AI assistance
- ✅ Beginner-friendly interface

---

## 1.3 Extended Thinking Architecture

Extended thinking allows Claude to "think through" complex problems before responding, dramatically improving quality for reasoning-heavy tasks.

**Status:** Extended thinking is **enabled by default** with a budget of up to 31,999 tokens.

### How Extended Thinking Works

1. **Claude automatically uses thinking** when beneficial (up to 31,999 tokens)
2. **Claude reasons internally** (transparent in response)
3. **Thinking process visible** in thinking blocks
4. **Final answer generated** based on reasoning

### Controlling Extended Thinking

**Toggle in CLI:**
```bash
# Toggle with keyboard shortcut
Option+T (Mac) or Alt+T (Windows/Linux)
```

**Configure globally:**
```bash
# Within Claude session
/config
# Set extended thinking preferences
```

**Environment variable:**
```bash
# Set maximum thinking tokens
export MAX_THINKING_TOKENS=10000
```

**In settings.json:**
```json
{
  "thinking": {
    "enabled": true,
    "maxTokens": 31999
  }
}
```

### Budget Token Guide

| Budget | Use Case | Example Tasks |
|--------|----------|---------------|
| **1K-2K** | Simple reasoning | Basic calculations, straightforward logic |
| **2K-5K** | Moderate complexity | Code review, refactoring planning |
| **5K-10K** | Complex analysis | Architecture design, complex debugging |
| **10K-32K** | Deep reasoning | System design, multi-step analysis |
| **32K+** | Research-level | Use Batch API (can timeout on standard) |

### Extended Thinking Example (API)

```typescript
import Anthropic from "@anthropic-ai/sdk";

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

// Extended thinking is enabled by default
// Optionally customize with thinking parameter
const message = await client.messages.create({
  model: "claude-sonnet-4-5-20250929",
  max_tokens: 16000,
  thinking: {
    type: "enabled",      // Optional: already enabled by default
    budget_tokens: 10000, // Optional: customize budget (default: 31999)
  },
  messages: [
    {
      role: "user",
      content: "Design a scalable microservices architecture for an e-commerce platform",
    },
  ],
});

// Response includes thinking blocks + final answer
console.log(message.content);
```

**Disable extended thinking (when not needed):**
```typescript
const message = await client.messages.create({
  model: "claude-sonnet-4-5-20250929",
  max_tokens: 1024,
  thinking: {
    type: "disabled"  // Disable for simple tasks
  },
  messages: [{ role: "user", content: "Format this code" }]
});
```

### When Extended Thinking Helps Most

✅ **Extended thinking excels at:**
- Architecture and system design decisions
- Complex algorithmic problems
- Multi-step reasoning tasks
- Security analysis and threat modeling
- Code refactoring strategies
- Research and analysis

✅ **Can disable for:**
- Simple code completions
- Quick documentation
- Straightforward refactors
- High-volume batch operations (to reduce cost)
- Real-time chat (to reduce latency)

> **Note:** Extended thinking is automatic and intelligent. Claude uses thinking when beneficial and skips it for simple tasks.

### Cost Impact

Extended thinking uses **output tokens** for the thinking process:
- Thinking tokens billed as output tokens
- Default budget: up to 31,999 tokens
- Automatically scaled based on task complexity
- **Tip:** Use `MAX_THINKING_TOKENS` env var to limit if needed

---

## 1.4 Vision Capabilities

All current Claude models support vision (text + image input), enabling powerful code generation from visual inputs.

### Vision Use Cases for Developers

1. **Screenshot to Code**
   - UI mockups → React/Vue components
   - Wireframes → HTML/CSS
   - Design files → implementation

2. **Diagram Analysis**
   - Architecture diagrams → implementation guidance
   - Flow charts → code logic
   - Database schemas → migrations

3. **Form Understanding**
   - PDF forms → data extraction
   - Document layouts → parsing logic
   - UI screenshots → test automation

### Vision API Example

```python
import anthropic
import base64

client = anthropic.Anthropic()

# Read image file
with open("mockup.png", "rb") as image_file:
    image_data = base64.standard_b64encode(image_file.read()).decode("utf-8")

message = client.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=4096,
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/png",
                        "data": image_data,
                    },
                },
                {
                    "type": "text",
                    "text": "Convert this UI mockup to React components with Tailwind CSS"
                }
            ],
        }
    ],
)

print(message.content)
```

---

## 1.5 Model Context Protocol (MCP)

MCP enables Claude to connect to external datasources and tools, dramatically expanding its capabilities beyond just code analysis.

### MCP Architecture

```mermaid
graph LR
    Claude[Claude Code] --> MCP[MCP Client]
    MCP --> GoogleDrive[Google Drive<br/>Design Docs]
    MCP --> Jira[Jira<br/>Tickets]
    MCP --> Figma[Figma<br/>Designs]
    MCP --> Slack[Slack<br/>Conversations]
    MCP --> Custom[Custom Tools<br/>Internal APIs]
```

### Common MCP Integrations

| MCP Server | Use Case | Benefit |
|------------|----------|---------|
| **Google Drive** | Access design docs, specs | Real-time context from docs |
| **Jira** | Create/update tickets | Automated issue tracking |
| **Figma** | Read design files | Design-to-code workflows |
| **Slack** | Search conversations | Team knowledge access |
| **GitHub** | Repo analysis | Deep codebase understanding |
| **Custom** | Internal tools | Extend capabilities |

### MCP Configuration Example

**User MCP servers** are configured in `~/.claude.json`:

```json
{
  "mcpServers": {
    "gdrive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GOOGLE_OAUTH_TOKEN": "${GDRIVE_TOKEN}"
      }
    }
  }
}
```

**Project MCP servers** are configured in `.mcp.json` (project root):

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-jira"],
      "env": {
        "JIRA_URL": "https://company.atlassian.net",
        "JIRA_API_TOKEN": "${JIRA_TOKEN}"
      }
    }
  }
}
```

---

## 1.6 Skills System

The Skills system provides just-in-time knowledge loading, enabling Claude to access specialized domain knowledge without bloating the context window.

### Skills Architecture

**Progressive Disclosure Model:**
1. **Metadata** - Lightweight discoverability
2. **SKILL.md** - Core instructions loaded on-demand
3. **Resources** - Scripts, references, assets loaded if needed

### Skills vs. Regular Prompts

| Aspect | Regular Prompt | Skill |
|--------|---------------|-------|
| **Reusability** | One-time use | Reusable across projects |
| **Context efficiency** | Always in context | Loaded on-demand |
| **Distribution** | Copy-paste | Git repository / local files |
| **Versioning** | Manual | Git-based |
| **Team sharing** | Manual | Shared via `.claude/skills/` |

### Example: Security Review Skill

```markdown
---
name: security-review
description: Comprehensive security vulnerability analysis
allowed-tools: Read, Grep
model: sonnet
---

# Security Review Skill

Perform comprehensive security review checking for:

**Common Vulnerabilities:**
- SQL injection risks
- Cross-site scripting (XSS)
- Authentication/authorization issues
- Insecure data handling
- Hardcoded secrets

**For each issue:**
1. File and line number
2. Severity (Critical/High/Medium/Low)
3. Description
4. Recommended fix

Prioritize by severity.
```

**Usage:**
```bash
claude "/security-review"
```

---

## 1.7 Context Windows & Token Management

Understanding context windows helps you optimize costs and performance.

### Context Window Sizes

| Mode | Size | Use Case |
|------|------|----------|
| **Standard** | 200K tokens | Most development tasks |
| **Batch** | 2M tokens | Full codebase analysis |

**Token Usage Guide:**
- Average code file: 500-2000 tokens
- Large file (1000 lines): ~3000-5000 tokens
- CLAUDE.md (recommended): <5000 tokens

### Prompt Caching (Cost Optimization)

**Save 90% on repeated context:**
- Cache common context (CLAUDE.md, dependencies)
- First call: Full price
- Cached calls: 10% price

```typescript
const message = await client.messages.create({
  model: "claude-sonnet-4-5",
  max_tokens: 1024,
  system: [
    {
      type: "text",
      text: "Project context...", // This gets cached
      cache_control: { type: "ephemeral" }
    }
  ],
  messages: [{ role: "user", content: "Question..." }],
});
```

---

## 1.8 Mental Model Summary

### The Claude Ecosystem in One Picture

```mermaid
graph TB
    subgraph Users
        Dev[Developers]
    end
    
    subgraph Interfaces
        CLI[CLI<br/>Terminal First]
        VSCode[VS Code<br/>GUI]
        API[API<br/>Programmatic]
        SDK[Agent SDK<br/>Custom Agents]
    end
    
    subgraph Intelligence
        Haiku[Claude Haiku 4.5<br/>Fast/Cheap]
        Sonnet[Claude Sonnet 4.5<br/>Balanced]
        Opus[Claude Opus 4.5<br/>Max Intelligence]
        Extended[Extended Thinking<br/>Deep Reasoning]
    end
    
    subgraph Extensions
        MCP[MCP<br/>External Data]
        Skills[Skills<br/>Domain Knowledge]
        Vision[Vision<br/>Images→Code]
    end
    
    Dev --> CLI
    Dev --> VSCode
    Dev --> API
    Dev --> SDK
    
    CLI --> Sonnet
    VSCode --> Sonnet
    API --> Haiku
    API --> Sonnet
    API --> Opus
    SDK --> Sonnet
    SDK --> Extended
    
    Sonnet --> MCP
    Sonnet --> Skills
    Sonnet --> Vision
```

### Key Principles

1. **Choose the right tool:** CLI for automation, API for integration, SDK for agents
2. **Choose the right model:** Claude Haiku 4.5 for speed, Claude Sonnet 4.5 for balance, Claude Opus 4.5 for complexity
3. **Use extended thinking:** For complex reasoning (5K-10K budget typical)
4. **Leverage prompt caching:** Save 90% on repeated context
5. **Use MCP:** Connect to external data and tools
6. **Create skills:** Reusable domain knowledge
7. **Vision for UI:** Screenshots → code

---

## Quick Reference: Common Scenarios

| Scenario | Tool | Model | Features |
|----------|------|-------|----------|
| Daily feature development | CLI | Claude Sonnet 4.5 | Standard context |
| Architecture design | CLI/API | Claude Opus 4.5 | Extended thinking 10K |
| High-volume API calls | API | Claude Haiku 4.5 | Batch processing |
| Screenshot to code | CLI/API | Claude Sonnet 4.5 | Vision |
| Custom automation | Agent SDK | Claude Sonnet 4.5 | Custom tools |
| CI/CD integration | CLI | Claude Haiku 4.5 | Non-interactive |
| Complex debugging | CLI | Claude Sonnet 4.5 | Extended thinking 5K |
| Full repo analysis | API | Claude Sonnet 4.5 | Batch (2M context) |

---

[← Back to Part 1 Index](README.md) | [Next: Environment & Project Setup →](02-environment-setup.md)




---
title: "Section 1: Terminal Workflows & Command Patterns"
parent: "Part 2: Tools Mastery (CLI & VS Code Extension)"
nav_order: 1
---

# Section 1: Terminal Workflows & Command Patterns

## CLI Basics

### Interactive Mode
```bash
# Start interactive session
claude

# In session:
> How does authentication work in this project?
> Fix the linting errors in src/
> Generate tests for the UserService
```

### Command Mode (One-shot)
```bash
# Single command
claude "Explain the database schema"

# With file context
claude "@src/models/User.js explain this model"

# Extended thinking
claude --thinking=5000 "Design microservices architecture"
```

**Anti-Pattern**: Using extended thinking for simple tasks (formatting, quick questions)  
**Better**: Reserve `--thinking` for complex reasoning tasks. Use default mode for simple queries.  
**Why**: Extended thinking adds 2-4x latency and cost. Simple tasks like "fix linting" or "format code" don't benefit from deep reasoning.

### Piping (Unix Composition)
```bash
# Pipe command output
git diff | claude "Review these changes"
npm run lint 2>&1 | claude "Fix these lint errors"
cat error.log | claude "Analyze this error"

# Chain operations
git log --oneline -10 | claude "Summarize these commits" > summary.txt
```

**Anti-Pattern**: Not using piping - copying/pasting command output manually  
**Better**: Pipe directly to Claude: `git diff | claude "review"`  
**Why**: Piping is faster, preserves formatting, and enables automation in scripts.

## Command Patterns

### Code Analysis
```bash
claude "Analyze code quality in @src/services/"
claude "Find security vulnerabilities in @src/"
claude "List all TODO comments with context"
```

### Code Generation
```bash
claude "Generate API endpoint for user CRUD operations"
claude "Create React component for user profile"
claude "Write database migration to add email_verified column"
```

**Anti-Pattern**: Vague prompts like "fix my code" or "improve this"  
**Better**: Specific requests with context: "Fix authentication timeout - 401 after OAuth refresh. Error: [paste]"  
**Why**: Vague prompts get generic advice. Specific prompts with error messages, file context, and desired outcome get targeted fixes.

### Refactoring
```bash
claude "Refactor @src/legacy.js to use async/await"
claude "Extract reusable functions from @src/utils.js"
claude "Convert class component to hooks in @components/UserList.jsx"
```

## Session Management

### Context Persistence
- Session maintains conversation history
- Files referenced stay in context
- Can reference previous responses

### Multi-turn Conversations
```bash
claude
> Add user authentication to the API
# Claude generates auth code
> Now add rate limiting to those endpoints
# Claude adds rate limiting, aware of previous auth code
> Generate tests for both features
# Claude generates tests for auth + rate limiting
```

**Anti-Pattern**: Starting new session for each question instead of continuing conversation  
**Better**: Use multi-turn conversations for related tasks - context accumulates and responses improve  
**Why**: Each new session loses context. Multi-turn conversations let Claude build on previous understanding, saving tokens (via caching).

## CLI Configuration

Claude Code uses JSON-based settings files at multiple scopes:

### User Settings (~/.claude/settings.json)
```json
{
  "model": "claude-sonnet-4-5-20250929",
  "thinking": {
    "enabled": false,
    "budgetTokens": 5000
  },
  "output": {
    "color": true,
    "verbose": false
  }
}
```

### Project Settings (.claude/settings.json)
```json
{
  "model": "claude-sonnet-4-5-20250929",
  "contextFiles": [
    "CLAUDE.md",
    "README.md",
    "package.json"
  ]
}
```

### User Preferences & MCP (~/.claude.json)
```json
{
  "mcpServers": {
    "google-drive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"]
    }
  }
}
```

[← Back to Part 2 Index](README.md) | [Next: CLI Automation →](02-cli-automation.md)


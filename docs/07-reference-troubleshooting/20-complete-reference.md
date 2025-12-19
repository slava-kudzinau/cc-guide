# Section 20: Complete Reference Guide

## CLI Command Reference

### Basic Commands
```bash
# Interactive mode
claude

# One-shot command
claude "your question"

# With file context
claude "@src/file.js explain this"

# Extended thinking
claude --thinking=5000 "complex task"

# Specific model
claude --model claude-opus-4-0 "task"

# Output to file
claude "generate code" > output.js
```

### Advanced CLI Options
```bash
--api-key KEY          # Override API key
--model MODEL          # Specify model
--thinking BUDGET      # Extended thinking budget
--max-tokens N         # Max output tokens
--platform PLATFORM    # anthropic|bedrock|vertex
--debug                # Debug mode
--version              # Show version
--help                 # Show help
```

## API Parameter Reference

### Messages API
```typescript
{
  model: "claude-sonnet-4-5",
  max_tokens: 4096,
  thinking: {
    type: "enabled",
    budget_tokens: 5000
  },
  system: "You are a helpful assistant",
  messages: [
    { role: "user", content: "Hello" }
  ],
  temperature: 1.0,
  top_p: 0.9
}
```

## Prompt Templates Library

### Feature Development
```
I need to implement [FEATURE_NAME].

Context: @CLAUDE.md @relevant-files

Requirements:
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

Questions before proceeding:
- What questions do you have?
- What edge cases should we consider?
- What are the architectural implications?
```

### Bug Fix
```
Bug: [DESCRIPTION]

Error: [ERROR_MESSAGE/STACK_TRACE]

Affected files: @file1 @file2

Steps to reproduce:
1. [Step 1]
2. [Step 2]

Expected behavior: [EXPECTED]
Actual behavior: [ACTUAL]

Please:
1. Identify root cause
2. Propose fix
3. Generate test to prevent regression
```

### Code Review
```
Review these changes:

$(git diff)

Focus on:
- Security vulnerabilities
- Performance issues
- Code quality and maintainability
- Breaking changes
- Missing error handling
- Test coverage gaps

Provide specific file:line references.
```

[← Back to Part 7 Index](README) | [Next: Troubleshooting →](21-troubleshooting)




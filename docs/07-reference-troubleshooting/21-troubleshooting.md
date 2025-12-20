---
title: "Section 21: Troubleshooting & Common Issues"
parent: "Part 7: Reference, Troubleshooting & Future"
nav_order: 2
---

# Section 21: Troubleshooting & Common Issues

## Authentication Issues

### API Key Not Recognized
```bash
# Check environment variable
echo $ANTHROPIC_API_KEY

# If empty, set it
export ANTHROPIC_API_KEY="sk-ant-your-key"

# Test
claude "test"
```

### MCP Server Authentication Fails
```bash
# Check MCP config
cat .claude/mcp_config.json

# Verify environment variables
env | grep GOOGLE
env | grep JIRA

# Test MCP server directly
npx @anthropics/mcp-server-gdrive --test
```

## Extended Thinking Issues

### Timeout on Large Budgets
**Problem:** Requests with 32K+ thinking budget timeout

**Solution:**
- Use Batch API for >32K budgets
- Start with 10K, increase if needed
- Break complex tasks into steps

### Unexpected Costs
**Problem:** Extended thinking more expensive than expected

**Solution:**
- Start with 2K budget
- Monitor token usage
- Use thinking only for complex tasks
- Consider Haiku for simple tasks

## Context Window Overflow

### Too Many Files
**Problem:** "Context window exceeded" error

**Solution:**
```bash
# Use focused context
claude "@specific-file" instead of "@entire-directory"

# Use .claudeignore
echo "node_modules/" >> .claudeignore
echo "dist/" >> .claudeignore

# Use Batch API for full codebase analysis
```

## Performance Issues

### Slow Responses
**Problem:** Claude takes too long to respond

**Solutions:**
1. Use faster model (Haiku 4.5)
2. Reduce context (fewer files)
3. Disable extended thinking for simple tasks
4. Use streaming for immediate feedback

### High API Costs
**Problem:** Unexpected high bills

**Solutions:**
1. Enable prompt caching (90% savings)
2. Use Haiku for simple tasks
3. Set monthly budget limits
4. Monitor usage dashboard

## CLI Installation Issues

### Command Not Found
```bash
# Add to PATH
export PATH="$HOME/.claude/bin:$PATH"

# Or reinstall
curl -fsSL https://claude.ai/install.sh | sh
```

### Permission Denied
```bash
# Fix permissions
chmod +x ~/.claude/bin/claude

# Or use sudo (if necessary)
sudo npm install -g @anthropic-ai/claude-code
```

[← Back: Reference Guide](20-complete-reference) | [Next: Productivity Benchmarks →](22-productivity-benchmarks)




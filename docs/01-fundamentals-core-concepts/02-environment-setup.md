---
title: "Section 2: Environment & Project Setup"
parent: "Part 1: Fundamentals & Core Concepts"
nav_order: 2
---

# Section 2: Environment & Project Setup

Complete installation and configuration guide for Claude Code CLI, VS Code extension, API authentication, and project setup.

---

## 2.1 Claude Code CLI Installation

### macOS / Linux / WSL

**Option 1: curl/bash (Recommended)**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Option 2: Homebrew (macOS)**
```bash
brew install --cask claude-code
```

### Windows

**Option 1: PowerShell (Recommended)**
```powershell
irm https://claude.ai/install.ps1 | iex
```

**Option 2: WinGet**
```powershell
winget install Anthropic.ClaudeCode
```

### Verification

```bash
# Check installation
claude --version

# Should output: claude-code v2.x.x
```

---

## 2.2 Authentication

Claude Code supports two authentication methods:

### Method 1: Claude Subscription (Recommended)

For Claude Pro, Team, Max, or Enterprise subscriptions:

1. **Login via command:**
```bash
claude /login
```

2. **Follow the prompts:**
   - Opens browser for authentication
   - Login with your Claude account
   - Authorizes Claude Code CLI

3. **Verify:**
```bash
claude "Hello, are you working?"
```

Auth problems? [Troubleshooting – Authentication](../07-reference-troubleshooting/02-troubleshooting#authentication-issues).

**Benefits:**
- ✅ No API key management needed
- ✅ Seamless authentication
- ✅ Automatic token refresh
- ✅ Works with team/enterprise accounts

### Method 2: API Key (Console Users)

For users with Claude API Console access:

1. **Get your API key:**
   - Go to [console.anthropic.com](https://console.anthropic.com/)
   - Navigate to API Keys
   - Create new key

2. **Set environment variable:**

**macOS / Linux (bash/zsh):**
```bash
# Add to ~/.bashrc or ~/.zshrc
export ANTHROPIC_API_KEY="sk-ant-api03-..."

# Reload shell
source ~/.bashrc  # or ~/.zshrc
```

**Windows (PowerShell):**
```powershell
# Temporary (current session)
$env:ANTHROPIC_API_KEY = "sk-ant-api03-..."

# Permanent (user environment)
[System.Environment]::SetEnvironmentVariable(
    'ANTHROPIC_API_KEY',
    'sk-ant-api03-...',
    'User'
)
```

3. **Verify:**
```bash
claude "Hello, are you working?"
```

### AWS Bedrock Authentication

**Prerequisites:**
- AWS account with Bedrock access
- AWS CLI configured

**Setup:**
```bash
# Configure AWS credentials
aws configure

# Set AWS region
export AWS_REGION=us-east-1

# Test with Claude
claude --platform bedrock "test message"
```

**Configuration file (.claude/config.json):**
```json
{
  "platform": "bedrock",
  "aws_region": "us-east-1",
  "aws_profile": "default"
}
```

### Google Vertex AI Authentication

**Prerequisites:**
- GCP project with Vertex AI enabled
- Service account with AI Platform permissions

**Setup:**
```bash
# Set credentials
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
export GOOGLE_CLOUD_PROJECT="your-project-id"

# Test
claude --platform vertex "test message"
```

### Microsoft Azure AI Foundry

**Setup via VS Code settings:**
```json
{
  "claude.platform": "azure",
  "claude.azure.endpoint": "https://your-endpoint.openai.azure.com/",
  "claude.azure.apiKey": "${AZURE_API_KEY}"
}
```

---

## 2.3 Claude Code Configuration

### Settings Files

Claude Code uses JSON-based configuration files at multiple scopes:

**Configuration Hierarchy:**
- User settings: `~/.claude/settings.json` (global defaults)
- Project settings: `.claude/settings.json` (project-specific)
- Local settings: `.claude/settings.local.json` (personal overrides, gitignored)
- User preferences: `~/.claude.json` (user-level preferences and MCP servers)

**Example `settings.json`:**
```json
{
  "model": "claude-sonnet-4-5-20250929",
  "thinking": {
    "enabled": false,
    "budgetTokens": 5000
  },
  "output": {
    "verbose": false,
    "color": true,
    "stream": true
  },
  "tools": {
    "bash": {
      "allowed": true,
      "allowedCommands": [
        "git*",
        "npm*",
        "docker*"
      ],
      "deniedCommands": [
        "rm -rf /*",
        "sudo*"
      ]
    }
  },
  "budget": {
    "monthlyLimit": 100.00,
    "warnThreshold": 80.00
  }
}
```

### Project Context: `CLAUDE.md`

The `CLAUDE.md` file provides persistent project context to Claude. This is the **most important configuration file** for effective Claude usage.

**Example `CLAUDE.md`:**

````markdown
---
project: E-Commerce Platform API
tech_stack:
  - Node.js 20
  - TypeScript 5.3
  - Express 4.18
  - PostgreSQL 15
  - Redis 7
  - Jest (testing)
---

# Project Context

## Overview
RESTful API for e-commerce platform with microservices architecture.

## Architecture
- **API Gateway:** Express + rate limiting
- **Auth Service:** JWT + refresh tokens
- **Product Service:** CRUD + search (Elasticsearch)
- **Order Service:** Order processing + payment integration
- **Notification Service:** Email/SMS via queues

## Coding Standards
- TypeScript strict mode enabled
- ESLint + Prettier configured
- 80% test coverage minimum
- All APIs must have OpenAPI docs
- Use async/await (no callbacks)
- Error handling: centralized middleware

## Database Conventions
- Snake_case for columns
- Migrations in `migrations/` folder
- Use transactions for multi-table operations
- Soft deletes (deleted_at column)

## Testing Requirements
- Unit tests: `*.spec.ts`
- Integration tests: `*.integration.ts`
- E2E tests: `*.e2e.ts`
- Mock external services
- Use test database

## Common Commands
```bash
npm run dev          # Start dev server
npm test            # Run all tests
npm run db:migrate  # Run migrations
npm run lint        # Lint code
```

## Important Files
- `src/routes/` - API route definitions
- `src/services/` - Business logic
- `src/models/` - Database models
- `src/middleware/` - Express middleware
- `config/` - Configuration files

## External Dependencies
- Stripe API (payments)
- SendGrid (emails)
- Twilio (SMS)
- AWS S3 (file storage)
````

### Ignore Patterns

Configure which files Claude should ignore using `.gitignore`-style patterns in `settings.json`:

**Example ignore configuration in `settings.json`:**
```json
{
  "ignore": [
    "node_modules/",
    "vendor/",
    "dist/",
    "build/",
    "out/",
    ".env*",
    "*.log",
    "coverage/",
    ".DS_Store"
  ]
}
```

**Alternative: `.claudeignore` (legacy, still supported)**

You can also create a `.claudeignore` file using `.gitignore` syntax:

```gitignore
# Dependencies
node_modules/
vendor/

# Build outputs
dist/
build/

# Environment files
.env
.env.local
*.key

# Logs
*.log
logs/

# Test coverage
coverage/
```

---

## 2.4 MCP Server Configuration

MCP (Model Context Protocol) servers enable Claude to access external data sources like Google Drive, Jira, GitHub, Figma, Slack, and custom APIs. This dramatically expands Claude's capabilities beyond local file analysis.

### Quick Start

Add your first MCP server using the CLI:

```bash
# Add HTTP server (cloud services - recommended)
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Add stdio server (local processes)
claude mcp add --transport stdio gdrive \
  --env GOOGLE_TOKEN="${GDRIVE_TOKEN}" \
  -- npx -y @modelcontextprotocol/server-gdrive

# Test connection
claude mcp test github
```

### MCP CLI Commands

The `claude mcp` command provides full server management capabilities.

#### Adding Servers

**HTTP Transport (Recommended for Cloud Services):**

```bash
# Basic HTTP server
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# With authentication
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp \
  --header "Authorization: Bearer ${SENTRY_TOKEN}"

# With custom headers
claude mcp add --transport http notion https://mcp.notion.com/mcp \
  --header "Notion-Version: 2022-06-28" \
  --header "Authorization: Bearer ${NOTION_TOKEN}"
```

**Stdio Transport (Local Processes):**

```bash
# Node.js MCP server via npx
claude mcp add --transport stdio jira \
  --env JIRA_TOKEN="${JIRA_TOKEN}" \
  --env JIRA_URL="https://company.atlassian.net" \
  -- npx -y @modelcontextprotocol/server-jira

# Python MCP server
claude mcp add --transport stdio database \
  --env DB_URL="postgresql://localhost/mydb" \
  -- python -m mcp_server_database

# With working directory
claude mcp add --transport stdio custom \
  --cwd /path/to/server \
  -- node server.js
```

**Windows-Specific Stdio Requirement:**

Windows requires the `cmd /c` wrapper for stdio servers:

```powershell
# Windows: Use cmd /c before npx
claude mcp add --transport stdio gdrive \
  -- cmd /c npx -y @modelcontextprotocol/server-gdrive
```

**SSE Transport (Deprecated):**

```bash
# Server-Sent Events (legacy support only)
claude mcp add --transport sse asana https://mcp.asana.com/sse \
  --header "X-API-Key: ${ASANA_KEY}"
```

#### Managing Servers

```bash
# List all configured servers
claude mcp list

# Get details for a specific server
claude mcp get github

# Remove a server
claude mcp remove github

# Reset project approval choices
claude mcp reset-project-choices

# Import servers from Claude Desktop
claude mcp add-from-claude-desktop

# Add server from JSON configuration
claude mcp add-json weather '{"type":"http","url":"https://api.weather.com/mcp"}'
```

#### Testing Servers

```bash
# Test specific server connection
claude mcp test github

# Test with verbose output
claude mcp test github --verbose

# Within Claude session - check all MCP servers
/mcp

# Test server functionality
/mcp test github
```

### Transport Types Explained

MCP supports three transport types for connecting to servers.

#### HTTP Transport (Recommended)

**Use for:** Cloud-based MCP servers, production deployments, services with HTTP APIs

**Characteristics:**
- Stateless request/response model
- Uses standard HTTP/HTTPS protocols
- Authentication via headers or URL parameters
- Built-in retry and timeout handling
- Best for remote services

**Example Configuration:**
```json
{
  "type": "http",
  "url": "https://mcp.example.com/api",
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

**Pros:**
- Simple, widely supported protocol
- Works through firewalls and proxies
- Easy to debug with curl/Postman
- Scalable for production use

**Cons:**
- Requires internet connectivity
- Additional network latency

#### Stdio Transport (Local Processes)

**Use for:** Local MCP servers, development/testing, Node.js/Python scripts via npx/pip

**Characteristics:**
- Spawns subprocess and communicates via stdin/stdout
- No network required
- Process lifecycle managed by Claude
- Full access to local environment

**Example Configuration:**
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-gdrive"],
  "env": {
    "GOOGLE_TOKEN": "${GDRIVE_TOKEN}"
  }
}
```

**Pros:**
- Fast (no network overhead)
- Works offline
- Full local system access
- Great for development

**Cons:**
- Windows requires `cmd /c` wrapper
- Process management complexity
- Platform-specific paths

#### SSE Transport (Deprecated)

**Use for:** Legacy systems only (not recommended for new deployments)

**Characteristics:**
- Server-Sent Events protocol
- Unidirectional server→client streaming
- Deprecated in favor of HTTP

**Note:** SSE is maintained for backward compatibility only. Use HTTP transport for new servers.

### Scope Management

MCP servers can be configured at different scopes, creating a hierarchy for availability and precedence.

#### Scope Hierarchy

| Scope | Location | Priority | Use Case |
|-------|----------|----------|----------|
| **Local** | `~/.claude.json` in project directory | Highest | Personal, project-specific overrides |
| **Project** | `.mcp.json` in project root | High | Team-shared, committed to git |
| **User** | `~/.claude.json` in home directory | Medium | Personal tools, all projects |
| **Managed** | System-wide paths | Lowest | IT administrator, organization-wide |

**Managed scope locations:**
- macOS: `/Library/Application Support/ClaudeCode/managed-mcp.json`
- Linux/WSL: `/etc/claude-code/managed-mcp.json`
- Windows: `C:\Program Files\ClaudeCode\managed-mcp.json`

#### Selecting Scope with CLI

```bash
# Local scope (default - personal, this project only)
claude mcp add --scope local custom https://api.company.com/mcp

# Project scope (team-shared, in .mcp.json)
claude mcp add --scope project jira \
  -- npx -y @modelcontextprotocol/server-jira

# User scope (personal, all projects)
claude mcp add --scope user gdrive \
  -- npx -y @modelcontextprotocol/server-gdrive
```

#### Best Practices by Scope

**Local Scope:**
- Experimental servers
- Personal API keys
- Project-specific overrides
- Temporary testing

**Project Scope:**
- Team-shared services (Jira, GitHub)
- Project-required integrations
- Commit `.mcp.json` to version control
- Document in project README

**User Scope:**
- Personal productivity tools
- Cross-project utilities
- Development tools
- Personal API credentials

**Managed Scope:**
- Organization-wide policies
- Enterprise integrations
- Compliance requirements
- Requires admin privileges to configure

### Understanding Configuration Files

While the CLI is recommended for most use cases, understanding the JSON structure is useful for debugging and advanced scenarios.

#### User Configuration (`~/.claude.json`)

Located in your home directory for user-wide and local-scoped servers:

```json
{
  "mcpServers": {
    "google-drive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GOOGLE_OAUTH_TOKEN": "${GDRIVE_TOKEN}"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_TOKEN}"
      }
    }
  }
}
```

#### Project Configuration (`.mcp.json`)

Located in project root for team-shared servers:

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-jira"],
      "env": {
        "JIRA_URL": "https://company.atlassian.net",
        "JIRA_EMAIL": "${JIRA_EMAIL}",
        "JIRA_API_TOKEN": "${JIRA_TOKEN}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}",
        "GITHUB_REPO": "owner/repo"
      }
    }
  }
}
```

#### Environment Variable Expansion

MCP supports environment variable expansion in configuration:

**Syntax:**
- `${VAR}` - Required variable (fails if not set)
- `${VAR:-default}` - Optional variable with default value

**Example:**
```json
{
  "env": {
    "API_KEY": "${MY_API_KEY}",
    "TIMEOUT": "${REQUEST_TIMEOUT:-5000}",
    "ENDPOINT": "${API_ENDPOINT:-https://api.example.com}"
  }
}
```

**When to manually edit JSON:**
- Complex environment variable logic
- Debugging MCP server configuration
- Copying configuration between machines
- Understanding what CLI commands generate

### Common Patterns

#### 1. Google Drive for Design Docs

Access design documents, specifications, and team files:

```bash
# Add Google Drive MCP server
claude mcp add --scope user --transport stdio gdrive \
  --env GOOGLE_OAUTH_TOKEN="${GDRIVE_TOKEN}" \
  -- npx -y @modelcontextprotocol/server-gdrive

# Usage
claude "List all files in my 'Product Specs' folder"
claude "Show me the latest design doc about authentication"
```

#### 2. Jira for Issue Tracking

Create, update, and query Jira tickets:

```bash
# Add Jira MCP server (project scope for team)
claude mcp add --scope project --transport stdio jira \
  --env JIRA_URL="https://company.atlassian.net" \
  --env JIRA_EMAIL="${JIRA_EMAIL}" \
  --env JIRA_API_TOKEN="${JIRA_TOKEN}" \
  -- npx -y @modelcontextprotocol/server-jira

# Usage
claude "Create a bug ticket for the login timeout issue in auth.ts"
claude "Show me all open tickets in the AUTH project"
claude "Update ticket AUTH-123 to in-progress"
```

#### 3. GitHub Organization Access

Access organization repositories, PRs, and issues:

```bash
# Add GitHub MCP server
claude mcp add --scope project --transport http github \
  https://api.githubcopilot.com/mcp/ \
  --env GITHUB_TOKEN="${GITHUB_TOKEN}"

# Usage
claude "List recent PRs in our org repositories"
claude "Show me issues labeled 'security' across all repos"
claude "Get the file tree for company/backend-api"
```

#### 4. Figma Design Integration

Access design files and components:

```bash
# Add Figma MCP server
claude mcp add --scope user --transport stdio figma \
  --env FIGMA_TOKEN="${FIGMA_TOKEN}" \
  -- npx -y @modelcontextprotocol/server-figma

# Usage
claude "Show me all components in the Design System file"
claude "Get the latest mockups for the dashboard feature"
```

#### 5. Slack Knowledge Base

Search conversations and find tribal knowledge:

```bash
# Add Slack MCP server
claude mcp add --scope user --transport stdio slack \
  --env SLACK_BOT_TOKEN="${SLACK_TOKEN}" \
  --env SLACK_TEAM_ID="${SLACK_TEAM}" \
  -- npx -y @modelcontextprotocol/server-slack

# Usage
claude "Search Slack for discussions about API authentication"
claude "Find messages about the deployment process in #engineering"
```

#### 6. Custom Internal API

Connect to company-specific APIs:

```bash
# Add custom HTTP MCP server with authentication
claude mcp add --scope project --transport http internal \
  https://internal-api.company.com/mcp \
  --header "Authorization: Bearer ${INTERNAL_API_KEY}" \
  --header "X-Company-ID: ${COMPANY_ID}"

# Usage
claude "Query our internal knowledge base about the auth service"
claude "Get the latest deployment status from our CI/CD API"
```

#### 7. PostgreSQL Database Access

Query databases for analysis and reporting:

```bash
# Add database MCP server
claude mcp add --scope local --transport stdio postgres \
  --env DATABASE_URL="postgresql://user:pass@localhost:5432/mydb" \
  -- npx -y @modelcontextprotocol/server-postgres

# Usage
claude "Show me the schema for the users table"
claude "How many active users do we have this month?"
claude "Query for users who signed up in the last 7 days"
```

### Management Commands Reference

```bash
# List servers with status and scope
claude mcp list
# Output shows: Name | Transport | Scope | Status

# Get full configuration for a server
claude mcp get github
# Shows: command, args, env, transport, scope

# Test server connection
claude mcp test github
# Returns: Connection status, available tools, any errors

# Test with verbose output
claude mcp test github --verbose
# Shows: Full request/response details, timing, debug info

# Remove a server
claude mcp remove github
# Removes from appropriate config file based on scope

# Reset project MCP approvals
claude mcp reset-project-choices
# Clears saved approval decisions for .mcp.json servers

# Import from Claude Desktop
claude mcp add-from-claude-desktop
# Migrates MCP servers from Claude Desktop config

# Add from JSON string
claude mcp add-json myserver '{"type":"http","url":"https://example.com"}'
# Directly add server from JSON config
```

### Best Practices

1. **Use appropriate scopes**
   - Project scope for team-shared services
   - User scope for personal productivity tools
   - Local scope for experiments and overrides

2. **Secure credentials properly**
   - Always use environment variables for secrets
   - Never commit credentials to `.mcp.json`
   - Use `${VAR}` syntax in configuration files
   - Add `.env` files to `.gitignore`

3. **Test connections early**
   - Run `claude mcp test <server>` after adding
   - Verify environment variables are set
   - Check server logs for errors

4. **Prefer HTTP for production**
   - More stable and scalable
   - Easier to debug and monitor
   - Works through corporate proxies
   - Better error handling

5. **Document team servers**
   - Add setup instructions to project README
   - Document required environment variables
   - Include example `.env.template` file
   - List server dependencies

6. **Monitor connection health**
   - Regularly test server connections
   - Check for API rate limits
   - Monitor server logs
   - Set up alerts for failures

7. **Use descriptive server names**
   - Name servers by purpose: `company-jira`, `prod-database`
   - Avoid generic names: `server1`, `api`
   - Include environment if needed: `staging-api`, `prod-api`

8. **Version pin production servers**
   - Use specific package versions for stdio: `npx -y package@1.2.3`
   - Document version requirements
   - Test upgrades in development first

### Windows-Specific Considerations

Windows has unique requirements for MCP server configuration.

#### Stdio Server Wrapper

Windows requires the `cmd /c` wrapper for all stdio servers:

```powershell
# Windows: Correct (with cmd /c)
claude mcp add --transport stdio gdrive \
  -- cmd /c npx -y @modelcontextprotocol/server-gdrive

# This will fail on Windows:
claude mcp add --transport stdio gdrive \
  -- npx -y @modelcontextprotocol/server-gdrive
```

#### PowerShell Environment Variables

```powershell
# Set environment variable (temporary)
$env:GITHUB_TOKEN = "ghp_xxxx"

# Set environment variable (permanent - user level)
[System.Environment]::SetEnvironmentVariable(
    'GITHUB_TOKEN',
    'ghp_xxxx',
    'User'
)

# Verify variable is set
echo $env:GITHUB_TOKEN
```

#### Path Separators

Use forward slashes in URLs even on Windows:

```powershell
# Correct
claude mcp add --transport http api https://example.com/mcp/endpoint

# Works on Windows too
--cwd C:/Users/name/project  # Forward slashes OK
```

#### Common Windows Issues

**Issue: "npx not found"**
```powershell
# Solution: Verify Node.js is in PATH
where.exe npx

# Add to PATH if missing, then use cmd /c wrapper
claude mcp add --transport stdio server -- cmd /c npx -y package
```

**Issue: Permission denied**
```powershell
# Solution: Run PowerShell as Administrator
# Right-click PowerShell → "Run as Administrator"
```

### Security Considerations

#### Credential Management

**Never commit credentials:**
```bash
# Bad: Hardcoded in .mcp.json
{
  "env": {
    "API_KEY": "sk-secret-key-here"  // Never do this!
  }
}

# Good: Environment variable reference
{
  "env": {
    "API_KEY": "${MY_API_KEY}"  // Reference only
  }
}
```

**Use environment variable files:**
```bash
# Create .env file (add to .gitignore)
GITHUB_TOKEN=ghp_xxxx
JIRA_TOKEN=xxx

# Load in shell
source .env  # Linux/macOS
# Or use direnv, dotenv, etc.
```

#### Scope Security Implications

- **Local scope:** Most secure (not shared, not committed)
- **Project scope:** Shared with team (commit `.mcp.json`, not credentials)
- **User scope:** Personal but accessible to all projects
- **Managed scope:** Organization-wide (requires admin approval)

#### Transport Security

```bash
# Always use HTTPS for HTTP transport
claude mcp add --transport http api https://api.example.com  # Good
claude mcp add --transport http api http://api.example.com   # Bad (unencrypted!)

# Validate server certificates
# MCP validates HTTPS certificates by default
```

#### Access Control

**Principle of least privilege:**
- Grant servers minimal required permissions
- Use read-only tokens when possible
- Scope API keys to specific resources
- Regularly rotate credentials

**Audit server access:**
```bash
# Review configured servers
claude mcp list

# Check what each server can access
claude mcp get <server-name>

# Remove unused servers
claude mcp remove <server-name>
```

#### Secret Storage Best Practices

1. Use system keychain/credential manager
2. Consider secret management tools (1Password, Vault)
3. Rotate credentials regularly
4. Use separate keys per environment (dev/staging/prod)
5. Monitor for credential exposure in logs

### Complete Example: Team Setup

Here's a complete end-to-end example of setting up MCP servers for a development team.

#### Step 1: User-Level Personal Tools

```bash
# Personal Google Drive access (user scope)
export GDRIVE_TOKEN="your-token"
claude mcp add --scope user --transport stdio gdrive \
  --env GOOGLE_TOKEN="${GDRIVE_TOKEN}" \
  -- npx -y @modelcontextprotocol/server-gdrive

# Personal Slack access (user scope)
export SLACK_TOKEN="xoxb-your-token"
claude mcp add --scope user --transport stdio slack \
  --env SLACK_BOT_TOKEN="${SLACK_TOKEN}" \
  -- npx -y @modelcontextprotocol/server-slack
```

#### Step 2: Project-Level Team Services

```bash
# Navigate to project
cd /path/to/project

# Add Jira (project scope - team shared)
claude mcp add --scope project --transport stdio jira \
  --env JIRA_URL="https://company.atlassian.net" \
  --env JIRA_EMAIL="${JIRA_EMAIL}" \
  --env JIRA_API_TOKEN="${JIRA_TOKEN}" \
  -- npx -y @modelcontextprotocol/server-jira

# Add GitHub (project scope - team shared)
claude mcp add --scope project --transport http github \
  https://api.githubcopilot.com/mcp/ \
  --env GITHUB_TOKEN="${GITHUB_TOKEN}"

# Commit .mcp.json to version control
git add .mcp.json
git commit -m "Add team MCP servers for Jira and GitHub"
```

#### Step 3: Create .env.template for Team

```bash
# Create .env.template (commit this)
cat > .env.template << 'EOF'
# Required for MCP servers
JIRA_EMAIL=your.email@company.com
JIRA_TOKEN=your-jira-api-token
GITHUB_TOKEN=ghp_your_github_token
EOF

# Add .env to .gitignore (don't commit actual credentials)
echo ".env" >> .gitignore
```

#### Step 4: Document in README

```markdown
# Add to project README.md

## MCP Server Setup

This project uses MCP servers for Jira and GitHub integration.

### Prerequisites
- Node.js 18+ installed
- Jira API token (get from https://id.atlassian.com/manage/api-tokens)
- GitHub personal access token (get from https://github.com/settings/tokens)

### Setup
1. Copy environment template:
   ```bash
   cp .env.template .env
   ```

2. Fill in your credentials in `.env`

3. Load environment:
   ```bash
   source .env  # macOS/Linux
   ```

4. Test MCP connections:
   ```bash
   claude mcp test jira
   claude mcp test github
   ```

### Usage
```bash
# Create Jira ticket
claude "Create a bug ticket for the login issue"

# Check GitHub PRs
claude "List open PRs for this repo"
```
```

#### Step 5: Verify Setup

```bash
# List all configured servers
claude mcp list

# Test each server
claude mcp test jira
claude mcp test github
claude mcp test gdrive
claude mcp test slack

# Verify with actual usage
claude "List my open Jira tickets"
claude "Show recent GitHub commits in this repo"
```

**Result:** Team members can clone the repo, set up their personal credentials, and immediately access shared MCP servers.

---

## 2.5 Skills System

Skills are reusable knowledge modules stored as `SKILL.md` files that give Claude specialized capabilities.

### Skills Directory Structure

**User skills:** `~/.claude/skills/` (available across all projects)
**Project skills:** `.claude/skills/` (project-specific)

```
.claude/skills/
├── typescript-api/
│   └── SKILL.md
├── security-review/
│   └── SKILL.md
└── test-generator/
    ├── SKILL.md
    ├── templates/
    │   └── test.template.ts
    └── examples/
        └── sample-test.ts
```

### Listing Skills

Skills are automatically discovered from the `.claude/skills/` and `~/.claude/skills/` directories.

```bash
# Within Claude session - list available skills
/agents list
# Shows all skills loaded from user and project directories
```

### Creating Custom Skills

**1. Create skill directory:**
```bash
mkdir -p .claude/skills/typescript-api
```

**2. Create SKILL.md:**

Create `.claude/skills/typescript-api/SKILL.md` with frontmatter:

**Example Custom Skill (`typescript-api/SKILL.md`):**

````markdown
---
name: typescript-api
description: Generate TypeScript Express API endpoints with validation
allowed-tools: Read, Write, Bash
---

# TypeScript API Generator Skill

Generate production-ready TypeScript Express API endpoints.

## Endpoint Generation Checklist

1. **Route handler** (`src/routes/`)
   - Input validation (Zod schemas)
   - Error handling middleware
   - OpenAPI documentation comments

2. **Service layer** (`src/services/`)
   - Business logic separation
   - Database operations
   - External API calls

3. **Tests** (`src/routes/*.spec.ts`)
   - Unit tests for service
   - Integration tests for route
   - Mock external dependencies

4. **Types** (`src/types/`)
   - Request/Response types
   - Database model types

## Example Template

```typescript
// src/routes/users.ts
import { Router } from 'express';
import { z } from 'zod';
import { validate } from '../middleware/validate';

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
});

export const usersRouter = Router();

/**
 * @openapi
 * /api/users:
 *   post:
 *     summary: Create a new user
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email: {type: string}
 *               name: {type: string}
 */
usersRouter.post(
  '/',
  validate(createUserSchema),
  async (req, res, next) => {
    try {
      const user = await UserService.create(req.body);
      res.status(201).json(user);
    } catch (error) {
      next(error);
    }
  }
);
```
````

### Skill Frontmatter Options

- `name`: Unique identifier (required)
- `description`: What the skill does (required)  
- `disable-model-invocation`: Disable automatic use (optional)
- `allowed-tools`: Tool restrictions (optional)
- `context`: Keywords for matching (optional)

### Using Skills

Skills are automatically discovered and invoked:

```bash
claude "Create a new API endpoint for user registration"
# Claude automatically uses relevant skills based on query context
```

### Best Practices

- Focus on single responsibility per skill
- Include clear step-by-step instructions
- Add context keywords for better matching
- Store user skills in `~/.claude/skills/`
- Store project skills in `.claude/skills/`

---

## 2.6 Hooks System

Hooks allow you to run custom scripts at specific points in Claude's workflow for automation and customization.

### Available Hook Types

**PreToolUse** - Runs before Claude uses a tool
**PostToolUse** - Runs after Claude uses a tool  
**SessionStart** - Runs when starting a new session

### Configuring Hooks

Add hooks configuration to `settings.json`:

**Example `.claude/settings.json`:**
```json
{
  "hooks": {
    "PreToolUse": {
      "Write": {
        "command": "bash",
        "args": ["-c", "echo 'About to write file'"]
      }
    },
    "PostToolUse": {
      "Write": {
        "command": "npm",
        "args": ["run", "format"],
        "description": "Auto-format after file edits"
      },
      "StrReplace": {
        "command": "eslint",
        "args": ["--fix", "${file}"],
        "description": "Auto-lint after replacements"
      }
    },
    "SessionStart": {
      "command": "bash",
      "args": ["-c", "git pull && npm install"],
      "description": "Update dependencies on session start"
    }
  }
}
```

### Hook Configuration Options

```json
{
  "command": "executable",       // Required: Command to run
  "args": ["arg1", "arg2"],      // Optional: Arguments
  "description": "What it does", // Optional: Description
  "cwd": "/path/to/dir",         // Optional: Working directory
  "env": {                       // Optional: Environment variables
    "VAR": "value"
  },
  "timeout": 5000                // Optional: Timeout in ms
}
```

### Variables in Hooks

Use these variables in `args` and `env`:

- `${file}` - File being operated on
- `${tool}` - Tool being used
- `${cwd}` - Current working directory
- `${project}` - Project root directory

### Common Hook Patterns

**1. Auto-format After Edits**
```json
{
  "hooks": {
    "PostToolUse": {
      "Write": {
        "command": "prettier",
        "args": ["--write", "${file}"]
      },
      "StrReplace": {
        "command": "prettier",
        "args": ["--write", "${file}"]
      }
    }
  }
}
```

**2. Run Tests After Code Changes**
```json
{
  "hooks": {
    "PostToolUse": {
      "Write": {
        "command": "npm",
        "args": ["test", "--", "${file}.test.ts"],
        "description": "Run tests for modified files"
      }
    }
  }
}
```

**3. Git Auto-commit**
```json
{
  "hooks": {
    "PostToolUse": {
      "Write": {
        "command": "bash",
        "args": ["-c", "git add ${file} && git commit -m 'Auto: Updated ${file}'"],
        "description": "Auto-commit changes"
      }
    }
  }
}
```

**4. Validation Hooks**
```json
{
  "hooks": {
    "PostToolUse": {
      "Write": {
        "command": "eslint",
        "args": ["${file}"],
        "description": "Validate code after write"
      }
    }
  }
}
```

**5. Notification Hooks**
```json
{
  "hooks": {
    "SessionStart": {
      "command": "notify-send",
      "args": ["Claude", "Session started"],
      "description": "Desktop notification"
    }
  }
}
```

### Managing Hooks

**List configured hooks:**
```bash
# Within Claude session
/hooks list
```

**Test a hook:**
```bash
/hooks test PostToolUse.Write
```

**Disable hooks temporarily:**
```json
{
  "hooks": {
    "enabled": false  // Disables all hooks
  }
}
```

### Hook Best Practices

**1. Keep Hooks Fast**
- Hooks should complete in <1 second
- Use async operations for slow tasks
- Set appropriate timeouts

**2. Handle Failures Gracefully**
- Hooks shouldn't break Claude's workflow
- Log errors for debugging
- Use try-catch in scripts

**3. Be Selective**
- Only hook what you need
- Too many hooks slow down Claude
- Consider impact on every operation

**4. Use for Automation**
- Format code automatically
- Run linters/validators
- Sync with external tools
- Update documentation

**5. Test Thoroughly**
```bash
# Test hook execution
/hooks test PostToolUse.Write

# Check hook logs
cat ~/.claude/logs/hooks.log
```

### Security Considerations

- Hooks run with your user permissions
- Review hook commands carefully
- Don't use untrusted hook configurations
- Avoid hooks that execute arbitrary code from files

### Example: Complete Format/Lint/Test Hook

```json
{
  "hooks": {
    "PostToolUse": {
      "Write": {
        "command": "bash",
        "args": [
          "-c",
          "prettier --write ${file} && eslint --fix ${file} && npm test -- ${file}"
        ],
        "description": "Format, lint, and test after writing files",
        "timeout": 10000
      }
    }
  }
}
```

---

## 2.7 Plugins System

Plugins are pre-packaged bundles that can include skills, agents, hooks, and MCP servers for specific use cases.

### What Are Plugins?

Plugins bundle multiple Claude Code features:
- ✅ Skills (domain knowledge)
- ✅ Agents (specialized assistants)
- ✅ Hooks (automation)
- ✅ MCP servers (external integrations)
- ✅ Configuration (settings)

**Benefits:**
- One-command installation
- Curated, tested combinations
- Community-maintained
- Easy sharing across teams

### Plugin Marketplace

Browse and install plugins from the official marketplace:

```bash
# Within Claude session
/plugin marketplace

# Search plugins
/plugin search "react"
/plugin search "security"
```

**Categories:**
- Frontend frameworks (React, Vue, Angular)
- Backend frameworks (Express, FastAPI, Spring)
- Testing tools (Jest, Pytest, Cypress)
- Security (OWASP, penetration testing)
- DevOps (Docker, Kubernetes, Terraform)
- Data science (Pandas, NumPy, Jupyter)

### Installing Plugins

**From marketplace:**
```bash
/plugin install typescript-fullstack
/plugin install security-audit
/plugin install react-development
```

**From URL:**
```bash
/plugin install https://github.com/user/custom-plugin
```

**From local file:**
```bash
/plugin install ./my-plugin.zip
```

### Managing Plugins

**List installed plugins:**
```bash
/plugin list
```

**Example output:**
```
Installed Plugins:
✓ typescript-fullstack (v1.2.0)
  - Skills: api-generator, test-generator
  - Agents: security-reviewer
  - Hooks: auto-format, auto-lint

✓ react-development (v2.0.1)
  - Skills: component-generator, state-management
  - Agents: performance-optimizer
```

**Update plugins:**
```bash
/plugin update typescript-fullstack
/plugin update --all
```

**Remove plugins:**
```bash
/plugin remove typescript-fullstack
```

**Plugin info:**
```bash
/plugin info typescript-fullstack
# Shows:
# - Description
# - Version
# - Author
# - What's included
# - Dependencies
```

### Enabling/Disabling Plugins

Configure in `settings.json`:

```json
{
  "enabledPlugins": [
    "typescript-fullstack",
    "react-development",
    "security-audit"
  ],
  "disabledPlugins": [
    "deprecated-plugin"
  ]
}
```

**Toggle plugin:**
```bash
/plugin disable typescript-fullstack
/plugin enable typescript-fullstack
```

### Creating Custom Plugins

**Plugin structure:**
```
my-plugin/
├── plugin.json           # Plugin metadata
├── skills/              # Skills
│   ├── skill1/
│   │   └── SKILL.md
│   └── skill2/
│       └── SKILL.md
├── agents/              # Agents
│   └── agent1/
│       └── AGENT.md
├── hooks/               # Hook configurations
│   └── hooks.json
├── mcp/                 # MCP server configs
│   └── servers.json
├── settings.json        # Default settings
└── README.md            # Documentation
```

**Example `plugin.json`:**
```json
{
  "name": "typescript-fullstack",
  "version": "1.2.0",
  "description": "Complete TypeScript full-stack development toolkit",
  "author": "Your Name",
  "license": "MIT",
  "homepage": "https://github.com/user/plugin",
  "keywords": ["typescript", "node", "react"],
  "requires": {
    "claude-code": ">=2.0.0"
  },
  "provides": {
    "skills": ["api-generator", "test-generator", "component-generator"],
    "agents": ["security-reviewer", "performance-optimizer"],
    "hooks": ["auto-format", "auto-lint"],
    "mcp": ["github-integration"]
  }
}
```

### Publishing Plugins

**1. Package plugin:**
```bash
cd my-plugin/
zip -r my-plugin-1.0.0.zip .
```

**2. Test locally:**
```bash
claude
/plugin install ./my-plugin-1.0.0.zip
/plugin test my-plugin
```

**3. Submit to marketplace:**
```bash
/plugin submit my-plugin-1.0.0.zip
# Follow prompts for marketplace submission
```

### Popular Plugins (Examples)

**TypeScript Full-Stack:**
```bash
/plugin install typescript-fullstack
```
Includes:
- API endpoint generator
- Component scaffolder
- Test generator
- Auto-formatting hooks

**Security Audit:**
```bash
/plugin install security-audit
```
Includes:
- Security review agent
- OWASP checker skill
- Vulnerability scanner

**React Development:**
```bash
/plugin install react-development
```
Includes:
- Component generator
- State management patterns
- Performance optimizer agent
- Hooks for linting

**Python Data Science:**
```bash
/plugin install python-data-science
```
Includes:
- Pandas helper skills
- Visualization generator
- Jupyter notebook agent

### Plugin Best Practices

**1. Install only what you need**
- Too many plugins = slower performance
- Review plugin contents before installing

**2. Keep plugins updated**
```bash
/plugin update --all
```

**3. Team consistency**
- Document required plugins in project README
- Include plugin list in `.claude/settings.json`
- Version control plugin configuration

**4. Create plugins for teams**
- Bundle your team's standards
- Share across projects
- Maintain internally

**5. Review permissions**
- Check what tools plugins can access
- Review hook commands
- Verify MCP server configurations

### Plugin Configuration

**Project-level plugin settings in `.claude/settings.json`:**
```json
{
  "enabledPlugins": [
    "typescript-fullstack",
    "security-audit"
  ],
  "pluginSettings": {
    "typescript-fullstack": {
      "apiStyle": "express",
      "testFramework": "jest",
      "formatting": "prettier"
    },
    "security-audit": {
      "severity": "high",
      "autoFix": false
    }
  }
}
```

### Discovering Plugins

**Browse marketplace:**
```bash
/plugin marketplace
```

**Search by keyword:**
```bash
/plugin search "testing"
/plugin search "react"
/plugin search "security"
```

**Filter by category:**
```bash
/plugin marketplace --category frontend
/plugin marketplace --category devops
```

**Check trending:**
```bash
/plugin trending
```

---

## 2.8 VS Code Extension Setup (Beta)

### Installation

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X / Cmd+Shift+X)
3. Search for "Claude Code"
4. Click Install

### Configuration

**Settings (settings.json):**
```json
{
  "claude.apiKey": "${env:ANTHROPIC_API_KEY}",
  "claude.defaultModel": "claude-sonnet-4-5",
  "claude.autoSuggest": true,
  "claude.inlineCompletion": true,
  "claude.extendedThinking": {
    "enabled": false,
    "defaultBudget": 5000
  },
  "claude.contextFiles": [
    "CLAUDE.md",
    "README.md",
    "package.json"
  ]
}
```

### Usage

- **Sidebar:** Click Claude icon (left sidebar)
- **Inline:** Type naturally, Claude suggests
- **Command Palette:** Ctrl+Shift+P → "Claude: Ask Question"
- **Right-click:** "Ask Claude" in context menu

---

## 2.9 Enterprise Deployment

### AWS Deployment

**Option 1: ECS Fargate**
```yaml
# docker-compose.yml
version: '3.8'
services:
  claude-code:
    image: anthropic/claude-code:latest
    environment:
      - ANTHROPIC_API_KEY=${API_KEY}
      - AWS_REGION=us-east-1
    volumes:
      - ./config:/app/.claude
    command: ["server", "--port", "8080"]
```

**Option 2: Lambda Function**
```typescript
// lambda-handler.ts
import { Claude } from '@anthropic-ai/sdk';

export const handler = async (event: any) => {
  const claude = new Claude({
    apiKey: process.env.ANTHROPIC_API_KEY,
  });

  const response = await claude.messages.create({
    model: 'claude-sonnet-4-5',
    max_tokens: 1024,
    messages: [{ role: 'user', content: event.prompt }],
  });

  return {
    statusCode: 200,
    body: JSON.stringify(response),
  };
};
```

### Google Cloud Deployment

**Cloud Run:**
```bash
# Build container
gcloud builds submit --tag gcr.io/PROJECT/claude-code

# Deploy
gcloud run deploy claude-code \
  --image gcr.io/PROJECT/claude-code \
  --platform managed \
  --region us-central1 \
  --set-env-vars ANTHROPIC_API_KEY=sk-ant-...
```

---

## 2.10 Setup Verification Checklist

✅ **Installation:**
- [ ] Claude CLI installed and in PATH
- [ ] `claude --version` works
- [ ] VS Code extension installed (optional)

✅ **Authentication:**
- [ ] ANTHROPIC_API_KEY environment variable set
- [ ] `claude "test"` returns a response
- [ ] AWS/GCP auth configured (if using)

✅ **Project Configuration:**
- [ ] `CLAUDE.md` created in project root
- [ ] `.claude/settings.json` configured (optional)
- [ ] Ignore patterns configured in settings.json (optional)

✅ **MCP Integration (Optional):**
- [ ] `~/.claude.json` configured for user MCP servers
- [ ] `.mcp.json` configured for project MCP servers (optional)
- [ ] MCP connections tested

✅ **Skills (Optional):**
- [ ] `.claude/skills/` directory created for custom skills
- [ ] Relevant skills installed
- [ ] Custom skills created (if needed)

---

## 2.11 Troubleshooting Setup Issues

### Issue: CLI not found after installation

**Solution:**
```bash
# Check if installed
which claude

# If not found, add to PATH manually
# macOS/Linux (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.claude/bin:$PATH"

# Windows (add to system PATH via Environment Variables)
```

### Issue: API key not recognized

**Solution:**
```bash
# Verify environment variable
echo $ANTHROPIC_API_KEY  # macOS/Linux
echo $env:ANTHROPIC_API_KEY  # Windows PowerShell

# If empty, re-export
export ANTHROPIC_API_KEY="sk-ant-..."

# Test directly
claude --api-key "sk-ant-..." "test"
```

### Issue: MCP servers not connecting

**Solution:**
```bash
# Check MCP server logs
claude --debug --list-mcp-servers

# Verify environment variables
env | grep -i google  # Check Google Drive vars
env | grep -i jira    # Check Jira vars

# Test MCP server directly
npx @anthropics/mcp-server-gdrive --test
```

### Issue: Permission denied errors

**Solution:**
```bash
# macOS/Linux: Fix permissions
chmod +x ~/.claude/bin/claude

# Windows: Run PowerShell as Administrator
```

---

## Quick Start Checklist (5 Minutes)

```bash
# 1. Install CLI
curl -fsSL https://claude.ai/install.sh | sh

# 2. Set API key
export ANTHROPIC_API_KEY="sk-ant-your-key"

# 3. Create CLAUDE.md
cat > CLAUDE.md << 'EOF'
---
project: My Project
tech_stack: [Node.js, TypeScript]
---
# Project Context
Brief description of your project...
EOF

# 4. Claude respects .gitignore by default
# Optionally configure additional ignore patterns in .claude/settings.json

# 5. Test
claude "Hello! List the files in this project"
```

**You're now ready to use Claude Code!** 🎉

---

[← Back: Mental Models](01-mental-models) | [Next: CLAUDE.md Guide →](03-claude-md-guide)




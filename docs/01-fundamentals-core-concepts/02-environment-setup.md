# Section 2: Environment & Project Setup

Complete installation and configuration guide for Claude Code CLI, VS Code extension, API authentication, and project setup.

---

## 2.1 Claude Code CLI Installation

### macOS / Linux

**Option 1: curl (Recommended)**
```bash
curl -fsSL https://claude.ai/install.sh | sh
```

**Option 2: Homebrew (macOS)**
```bash
brew install claude-code
```

**Option 3: npm (Node.js 18+)**
```bash
npm install -g @anthropic-ai/claude-code
```

### Windows

**PowerShell (Run as Administrator)**
```powershell
iwr -useb https://claude.ai/install.ps1 | iex
```

**Or via npm:**
```powershell
npm install -g @anthropic-ai/claude-code
```

### Verification

```bash
# Check installation
claude --version

# Should output: claude-code v2.x.x
```

---

## 2.2 API Key Setup

### Anthropic API Key (Primary Method)

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

###AWS Bedrock Authentication

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

## 2.3 Claude Code CLI Configuration

### Configuration File: `.clauderc`

**Location:**
- Global: `~/.clauderc`
- Project: `./.clauderc`

**Example `.clauderc`:**
```yaml
# Default model
model: claude-sonnet-4-5

# Extended thinking defaults
thinking:
  enabled: false
  budget_tokens: 5000

# Output preferences
output:
  verbose: false
  color: true
  stream: true

# Tool permissions
tools:
  bash:
    allowed: true
    patterns:
      - git:*
      - npm:*
      - docker:*
    deny_patterns:
      - rm -rf /*
      - sudo *

# Cost tracking
budget:
  monthly_limit: 100.00
  warn_threshold: 80.00
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

### Ignore Patterns: `.claudeignore`

Prevent Claude from accessing unnecessary files (improves performance and reduces costs).

**Example `.claudeignore`:**
```gitignore
# Dependencies
node_modules/
vendor/
.pnp/

# Build outputs
dist/
build/
out/
.next/
target/

# Environment files
.env
.env.local
*.key
*.pem

# Logs
*.log
logs/

# Test coverage
coverage/
.nyc_output/

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
Thumbs.db

# Large data files
*.sql
*.dump
data/

# Lock files (large and not useful)
package-lock.json
yarn.lock
pnpm-lock.yaml
```

---

## 2.4 MCP Server Configuration

MCP servers enable Claude to access external datasources.

### MCP Configuration File

**Location:** `.claude/mcp_config.json`

```json
{
  "mcpServers": {
    "google-drive": {
      "command": "npx",
      "args": ["-y", "@anthropics/mcp-server-gdrive"],
      "env": {
        "GOOGLE_OAUTH_TOKEN": "${GDRIVE_TOKEN}",
        "GOOGLE_CLIENT_ID": "${GDRIVE_CLIENT_ID}",
        "GOOGLE_CLIENT_SECRET": "${GDRIVE_SECRET}"
      }
    },
    "jira": {
      "command": "npx",
      "args": ["-y", "@anthropics/mcp-server-jira"],
      "env": {
        "JIRA_URL": "https://company.atlassian.net",
        "JIRA_EMAIL": "${JIRA_EMAIL}",
        "JIRA_API_TOKEN": "${JIRA_TOKEN}"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@anthropics/mcp-server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_TOKEN}",
        "SLACK_TEAM_ID": "${SLACK_TEAM}"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropics/mcp-server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}",
        "GITHUB_REPO": "owner/repo"
      }
    }
  }
}
```

### Installing MCP Servers

```bash
# Install MCP servers globally
npm install -g @anthropics/mcp-server-gdrive
npm install -g @anthropics/mcp-server-jira
npm install -g @anthropics/mcp-server-slack
npm install -g @anthropics/mcp-server-github

# Verify installation
claude --list-mcp-servers
```

### Testing MCP Connection

```bash
# Test Google Drive access
claude "List files in my Drive folder 'Design Docs'"

# Test Jira access
claude "Show me open tickets in project ABC"

# Test Slack access
claude "Search Slack for discussions about authentication"
```

---

## 2.5 Skills Setup

### Installing Official Skills

```bash
# Add Anthropic skills marketplace
claude /plugin marketplace add anthropics/skills

# List available skills
claude /skills list

# Install a skill
claude /skills install security-review
claude /skills install pdf-extractor
claude /skills install test-generator
```

### Creating Custom Skills

**Structure:**
```
my-custom-skill/
├── SKILL.md          # Required: Core instructions
├── scripts/          # Optional: Executable scripts
├── references/       # Optional: Reference docs
└── assets/           # Optional: Templates, examples
```

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

**Install custom skill:**
```bash
# Package skill
cd my-custom-skill/
zip -r ../typescript-api.zip .

# Install
claude /skills install ../typescript-api.zip
```

---

## 2.6 VS Code Extension Setup (Beta)

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

## 2.7 Enterprise Deployment

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

## 2.8 Setup Verification Checklist

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
- [ ] `.claudeignore` created
- [ ] `.clauderc` configured (optional)

✅ **MCP Integration (Optional):**
- [ ] MCP servers installed
- [ ] `.claude/mcp_config.json` created
- [ ] MCP connections tested

✅ **Skills (Optional):**
- [ ] Anthropic marketplace added
- [ ] Relevant skills installed
- [ ] Custom skills created (if needed)

---

## 2.9 Troubleshooting Setup Issues

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

# 4. Create .claudeignore
cat > .claudeignore << 'EOF'
node_modules/
dist/
.env
EOF

# 5. Test
claude "Hello! List the files in this project"
```

**You're now ready to use Claude Code!** 🎉

---

[← Back: Mental Models](01-mental-models) | [Next: Core Workflows →](03-core-workflows)




---
title: "Section 2: Building Agents with Agent SDK"
parent: "Part 3: Advanced API & Agent Development"
nav_order: 2
---

# Section 2: Building Agents with Agent SDK

## Agent Architecture

```typescript
import { Agent } from '@anthropic-ai/claude-agent-sdk';

const agent = new Agent({
  apiKey: process.env.ANTHROPIC_API_KEY,
  model: 'claude-sonnet-4-5',
  systemPrompt: 'You are a code review assistant',
  allowedTools: ['Read', 'Grep', 'Write'],
});

// Run agent
const result = await agent.run({
  message: 'Review all TypeScript files for security issues'
});
```

## Custom Tools (MCP)

```typescript
import { createSdkMcpServer, tool } from '@anthropic-ai/claude-agent-sdk';
import { z } from 'zod';

const customTools = createSdkMcpServer({
  name: 'dev-tools',
  version: '1.0.0',
  tools: [
    tool({
      name: 'run_tests',
      description: 'Run test suite',
      parameters: z.object({
        pattern: z.string().describe('Test file pattern')
      }),
      execute: async ({ pattern }) => {
        const result = await exec(`npm test -- ${pattern}`);
        return { output: result.stdout };
      }
    })
  ]
});

const agent = new Agent({
  apiKey: process.env.ANTHROPIC_API_KEY,
  mcpServers: [customTools]
});
```

## Multi-Agent Orchestration

```typescript
// Specialized agents
const architectAgent = new Agent({
  systemPrompt: 'You design system architecture',
  model: 'claude-opus-4-0'
});

const codeAgent = new Agent({
  systemPrompt: 'You write production code',
  model: 'claude-sonnet-4-5'
});

const reviewAgent = new Agent({
  systemPrompt: 'You review code for quality',
  model: 'claude-sonnet-4-5'
});

// Orchestrate workflow
const design = await architectAgent.run({ message: 'Design payment system' });
const code = await codeAgent.run({ message: `Implement: ${design}` });
const review = await reviewAgent.run({ message: `Review: ${code}` });
```

## Real-World Example: Code Review Agent

```typescript
import { Agent } from '@anthropic-ai/claude-agent-sdk';
import { Octokit } from '@octokit/rest';

class PRReviewAgent {
  private agent: Agent;
  private github: Octokit;

  constructor() {
    this.agent = new Agent({
      apiKey: process.env.ANTHROPIC_API_KEY,
      model: 'claude-sonnet-4-5',
      systemPrompt: `You are a senior code reviewer.
      Focus on: security, performance, maintainability.
      Provide specific, actionable feedback.`
    });

    this.github = new Octokit({ auth: process.env.GITHUB_TOKEN });
  }

  async reviewPR(owner: string, repo: string, prNumber: number) {
    // Get PR diff
    const { data: pr } = await this.github.pulls.get({
      owner, repo, pull_number: prNumber
    });

    // Run agent review
    const review = await this.agent.run({
      message: `Review this PR:\n\n${pr.body}\n\nDiff:\n${pr.diff_url}`
    });

    // Post review
    await this.github.pulls.createReview({
      owner, repo, pull_number: prNumber,
      body: review.output,
      event: 'COMMENT'
    });
  }
}

// Usage
const agent = new PRReviewAgent();
await agent.reviewPR('owner', 'repo', 123);
```

[← Back: Advanced API](01-advanced-api-features) | [Next: Skills System →](03-skills-system)


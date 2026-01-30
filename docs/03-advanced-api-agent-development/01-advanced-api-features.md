---
title: "Section 1: Advanced Claude API Features"
parent: "Part 3: Advanced API & Agent Development"
nav_order: 1
---

# Section 1: Advanced Claude API Features

## Extended Thinking Optimization

### Budget Allocation Strategy
```typescript
// Simple task: 2K tokens
const simpleAnalysis = await client.messages.create({
  model: "claude-sonnet-4-5",
  max_tokens: 4096,
  thinking: { type: "enabled", budget_tokens: 2000 },
  messages: [{ role: "user", content: "Review this function for bugs" }]
});

// Complex task: 10K tokens
const architectureDesign = await client.messages.create({
  model: "claude-sonnet-4-5",
  max_tokens: 16000,
  thinking: { type: "enabled", budget_tokens: 10000 },
  messages: [{ role: "user", content: "Design microservices architecture" }]
});
```

⚠️ **Anti-Pattern**: Using extended thinking for simple tasks (code formatting, basic questions)  
✅ **Better**: Reserve extended thinking for complex reasoning tasks only  
💡 **Why**: Extended thinking adds 5-20 seconds latency and doubles costs. Simple tasks don't benefit from deep reasoning. Use Haiku without thinking for formatting/simple tasks. More: [Anti-Patterns](../07-reference-troubleshooting/04-antipatterns).

## Vision API

### Screenshot to Code
```python
import anthropic, base64

client = anthropic.Anthropic()

with open("mockup.png", "rb") as f:
    image_data = base64.b64encode(f.read()).decode()

message = client.messages.create(
    model="claude-sonnet-4-5",
    max_tokens=4096,
    messages=[{
        "role": "user",
        "content": [
            {"type": "image", "source": {
                "type": "base64",
                "media_type": "image/png",
                "data": image_data
            }},
            {"type": "text", "text": "Convert to React + Tailwind CSS"}
        ]
    }]
)
```

## Batch Processing

### High-Volume Cost Optimization
```python
import anthropic

client = anthropic.Anthropic()

# Create batch of requests
batch = client.messages.batches.create(
    requests=[
        {
            "custom_id": f"req-{i}",
            "params": {
                "model": "claude-sonnet-4-5",
                "max_tokens": 1024,
                "messages": [{"role": "user", "content": f"Analyze file {i}"}]
            }
        }
        for i in range(1000)  # 1000 requests
    ]
)

# Poll for completion (up to 24 hours)
while batch.processing_status != "ended":
    time.sleep(60)
    batch = client.messages.batches.retrieve(batch.id)

# Retrieve results
results = client.messages.batches.results(batch.id)
```

**Benefits:**
- 50% cost reduction
- 2M token context window
- Process up to 100K requests

⚠️ **Anti-Pattern**: Using synchronous API for batch jobs (slow and expensive)  
✅ **Better**: Use Batch API for non-urgent jobs (overnight processing, bulk analysis)  
💡 **Why**: Batch API gives 50% cost reduction and handles large volumes efficiently. Perfect for processing 1000+ requests that don't need immediate results.

## Prompt Caching

### 90% Cost Reduction
```typescript
const cachedPrompt = await client.messages.create({
  model: "claude-sonnet-4-5",
  max_tokens: 1024,
  system: [
    {
      type: "text",
      text: largeProjectContext,  // This gets cached
      cache_control: { type: "ephemeral" }
    }
  ],
  messages: [{ role: "user", content: "Quick question..." }]
});

// Subsequent calls with same context: 90% cheaper!
```

⚠️ **Anti-Pattern**: Not using prompt caching for repeated context (costs 10x more)  
✅ **Better**: Cache large context (docs, code) that repeats across requests  
💡 **Why**: Without caching, sending 50K tokens 10 times costs $1.50. With caching: $0.18 (first request) + $0.14 (9 cached requests) = $0.32 total. That's 79% savings!

Problems? [Troubleshooting](../07-reference-troubleshooting/02-troubleshooting) (extended thinking, context overflow).

## Streaming Responses

### Real-Time Output
```typescript
const stream = client.messages.stream({
  model: "claude-sonnet-4-5",
  max_tokens: 1024,
  messages: [{ role: "user", content: "Explain async/await" }]
});

for await (const event of stream) {
  if (event.type === "content_block_delta") {
    process.stdout.write(event.delta.text);
  }
}
```

⚠️ **Anti-Pattern**: Not using streaming for user-facing applications (poor UX)  
✅ **Better**: Always stream responses in interactive applications - show progress as tokens arrive  
💡 **Why**: Non-streaming makes users wait 5-20 seconds staring at a blank screen. Streaming shows immediate progress, feels 50-80% faster, and allows early termination if output goes off-track.

[← Back to Part 3 Index](README) | [Next: Agent SDK →](02-agent-sdk)


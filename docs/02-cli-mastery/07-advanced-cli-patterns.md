# Section 7: Advanced CLI Patterns

## Multi-Repository Workflows

### Cross-Repo Analysis
```bash
#!/bin/bash
# analyze-microservices.sh

REPOS=("auth-service" "user-service" "payment-service")

for repo in "${REPOS[@]}"; do
    cd "$repo"
    claude "Analyze API consistency: 
    - Error handling patterns
    - Response formats
    - Authentication methods
    Compare with other services" > "../analysis/$repo.md"
    cd ..
done
```

### Monorepo Navigation
```bash
# Context-aware commands in monorepo
cd packages/frontend
claude "@../../CLAUDE.md @src/ Review component architecture"

cd ../../packages/backend
claude "@../../CLAUDE.md @src/ Review API design"
```

## Tool Integration

### Git Integration
```bash
# Custom git commands
git config --global alias.ai-review \
  '!git diff | claude "Review changes for quality and security"'

# Usage
git ai-review
```

### Docker Integration
```bash
# Analyze Dockerfile
claude "@Dockerfile Optimize for size and security"

# Debug container
docker logs my-container 2>&1 | \
  claude "Analyze errors and suggest fixes"
```

### Kubernetes Integration
```bash
# Analyze manifest
claude "@k8s/deployment.yaml Review for best practices"

# Debug pod
kubectl logs pod-name | claude "Diagnose this crash"

# Generate manifest
claude "Generate Kubernetes deployment for Node.js app:
- 3 replicas
- Health checks
- Resource limits
- ConfigMap for env vars"
```

## Parallel Execution

### GNU Parallel
```bash
# Review multiple files in parallel
find src/ -name "*.js" | \
  parallel -j 4 claude "Security review of {}"
```

### Background Jobs
```bash
# Start multiple reviews
for dir in src/*; do
    (claude "Analyze $dir" > "$dir.analysis") &
done
wait # Wait for all to complete
```

## Terminal Multiplexing (tmux)

### tmux Integration
```bash
# .tmux.conf
bind-key C command-prompt -p "Ask Claude:" \
  "run-shell 'tmux display-message \"$(claude %%)\""

# Usage: Ctrl+b, C, then type question
```

## Remote Execution

### SSH Workflows
```bash
# Review remote codebase
ssh server "cd /app && cat src/api.js" | \
  claude "Review this remote API code"
```

### Cloud Shell Integration
```bash
# Google Cloud Shell
gcloud compute ssh instance --command \
  "cat /var/log/app.log" | claude "Analyze errors"
```

## Advanced Piping Patterns

### Multi-Stage Pipelines
```bash
# Complex analysis pipeline
git log --since="1 week ago" --pretty=format:"%h %s" | \
  claude "Categorize commits: features, fixes, refactors" | \
  claude "Generate weekly report for stakeholders" | \
  pandoc -f markdown -t html > report.html
```

### Error Stream Processing
```bash
# Capture and analyze stderr
npm run build 2>&1 >/dev/null | \
  claude "Fix these build errors" | \
  tee build-fixes.md
```

[← Back: CLI vs VS Code](06-cli-vs-vscode) | [Part 2 Complete! → Part 3: API & Agents](../../docs/03-advanced-api-agent-development)




# Section 11: DevOps & CI/CD Integration

## GitHub Actions Integration

### Automated PR Review
```yaml
name: Claude Code Review
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Install Claude CLI
        run: curl -fsSL https://claude.ai/install.sh | sh
      
      - name: Review PR
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          git diff origin/${{ github.base_ref }}... | \
          claude "Review for:
          - Security vulnerabilities
          - Performance issues
          - Code quality concerns
          - Breaking changes
          Provide specific file:line references" > review.md
      
      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: review
            });
```

### Release Automation
```yaml
name: Release
on:
  push:
    tags: ['v*']

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Generate Release Notes
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          git log $(git describe --tags --abbrev=0 HEAD^)..HEAD --oneline | \
          claude "Generate release notes:
          ## New Features
          ## Bug Fixes
          ## Breaking Changes
          ## Improvements
          Use conventional commit format" > RELEASE_NOTES.md
      
      - name: Create Release
        uses: actions/create-release@v1
        with:
          tag_name: ${{ github.ref }}
          body_path: RELEASE_NOTES.md
```

## Infrastructure as Code

### Terraform Generation
```bash
# Generate Terraform for AWS ECS
claude "Generate Terraform for:
- ECS Fargate cluster
- Load balancer (ALB)
- Auto-scaling (2-10 tasks)
- CloudWatch logging
- IAM roles with least privilege
Output: main.tf, variables.tf, outputs.tf"
```

### Kubernetes Manifests
```bash
# Generate K8s deployment
claude "Generate Kubernetes manifests for Node.js API:
- Deployment (3 replicas)
- Service (ClusterIP)
- HorizontalPodAutoscaler
- ConfigMap for env vars
- Secret for API keys
- Ingress with TLS
Follow best practices for: security, resources, probes"
```

## Docker Optimization

### Multi-Stage Build
```bash
# Optimize Dockerfile
claude "@Dockerfile Optimize for:
- Smaller image size (use multi-stage)
- Faster builds (layer caching)
- Security (non-root user, minimal base)
- Best practices (COPY vs ADD, etc.)"
```

[← Back to Part 4 Index](README) | [Next: Architecture Design →](12-architecture-design)




---
title: "Section 01: Domain-Specific Workflows"
parent: "Part 6: Domain-Specific & Team Collaboration"
nav_order: 1
---

# Section 01: Domain-Specific Workflows

Specialized patterns and workflows optimized for different development domains. Each domain has unique patterns where Claude Code excels with Context7 integration.

**What You'll Learn:**
- Frontend development workflows (React, Next.js, Vue)
- Backend API development patterns
- Data engineering and SQL optimization
- DevOps and infrastructure as code
- When to use Context7 for each domain

---

## Table of Contents

1. [Frontend Development](#frontend-development)
2. [Backend Development](#backend-development)
3. [Data Engineering](#data-engineering)
4. [DevOps & Infrastructure](#devops--infrastructure)
5. [Mobile Development](#mobile-development)
6. [Context7 Usage Guide](#context7-usage-guide)

---

## Frontend Development

### React & Next.js Workflows

#### Using Context7 for Latest Patterns

**Always check for latest patterns** when working with rapidly evolving frameworks:

```bash
# Get latest framework patterns first
claude "Context7: Next.js 15 app router authentication with server actions"
claude "Context7: React 19 useOptimistic hook examples"
claude "Context7: Zustand v5 TypeScript best practices"
```

#### Component Development Pattern

```bash
# Step 1: Learn current patterns
claude "Context7: React 19 component patterns for form handling"

# Step 2: Create component using latest patterns
claude "Using Context7 React 19 patterns, create UserRegistrationForm:
- Email, password, confirm password fields
- Client-side validation
- Server action submission
- Loading states and error handling
Files: src/components/UserRegistrationForm.tsx"

# Step 3: Generate tests
claude "Generate tests for UserRegistrationForm" \
  --files="src/components/UserRegistrationForm.tsx"

# Step 4: Create Storybook story (optional)
claude "Create Storybook story with all states" \
  --files="src/components/UserRegistrationForm.tsx"
```

#### Next.js Feature Development

```bash
# Full feature: User profile with latest Next.js 15
claude "Context7: Next.js 15 app router authenticated pages patterns"

# Build complete feature
claude "Using Context7 Next.js 15 patterns, create user profile feature:
- app/profile/page.tsx (server component)
- app/profile/edit/page.tsx (server actions)
- components/ProfileCard.tsx (client component)
- lib/actions/profile.ts (server actions)
With: Server auth, Suspense, optimistic updates, error boundaries"
```

#### Screenshot to Code

```bash
# Convert design mockups to code
claude "Convert screenshot to Next.js component using Context7 latest patterns" \
  --files="design.png"

# Refine with framework-specific optimizations
claude "Context7: Next.js 15 Image component best practices - apply to code"
```

### Vue & Svelte Workflows

```bash
# Vue 3 Composition API
claude "Context7: Vue 3.4 defineModel and reactivity patterns"
claude "Using Context7 Vue 3.4, create reactive form with defineModel"

# Svelte 5 Runes
claude "Context7: Svelte 5 runes API - $state, $derived, $effect"
claude "Context7: Svelte 5 migration - convert this Svelte 4 component" \
  --files="src/lib/UserCard.svelte"
```

### Styling with Modern CSS/Tailwind

```bash
# Tailwind CSS latest features
claude "Context7: Tailwind CSS v4 container queries and modern grid"
claude "Using Context7 Tailwind v4, style Dashboard component with:
- Container queries
- Modern grid layout
- Dark mode support" \
  --files="src/components/Dashboard.tsx"
```

---

## Backend Development

### API Development Pattern

#### Node.js & Express

```bash
# Latest Node.js patterns
claude "Context7: Node.js 22 native TypeScript support setup"

# Modern Express API
claude "Using Context7 Express.js 5, create RESTful API:
- /api/users CRUD endpoints
- JWT authentication middleware
- Request validation (Zod)
- Error handling
- OpenAPI/Swagger docs"
```

#### NestJS

```bash
# Latest NestJS patterns
claude "Context7: NestJS 10 standalone applications and microservices"

# Build feature module
claude "Using Context7 NestJS 10, create authentication module:
- JWT strategy
- Guards and decorators
- Swagger integration
- Testing setup"
```

#### Fastify (High Performance)

```bash
# High-performance patterns
claude "Context7: Fastify v4 async hooks and plugin system"
claude "Context7: Fastify v4 - create API with schema validation" \
  --files="src/routes/users.ts"
```

### Database Workflows

#### Prisma ORM

```bash
# Latest Prisma features
claude "Context7: Prisma 5 client extensions - custom methods"

# Schema design
claude "Using Context7 Prisma 5, create schema for:
- Users, posts, comments (relations)
- Soft deletes (client extensions)
- Full-text search
- Optimistic concurrency control"

# Migration generation
claude "Generate Prisma migration for adding user roles" \
  --files="prisma/schema.prisma"
```

#### Drizzle ORM (Modern Alternative)

```bash
# Type-safe ORM
claude "Context7: Drizzle ORM query syntax and relations"
claude "Using Context7 Drizzle, create schema and queries for blog system"
```

### Authentication

```bash
# Modern auth patterns
claude "Context7: Next.js 15 authentication with Auth.js (NextAuth v5)"

# Implement full auth
claude "Using Context7 Auth.js v5, implement:
- Google & GitHub OAuth
- Email/password credentials
- Session management
- Protected routes middleware"
```

---

## Data Engineering

### SQL Optimization

#### PostgreSQL

```bash
# Latest PostgreSQL features
claude "Context7: PostgreSQL 16 JSON improvements and performance"

# Query optimization
claude "Using Context7 PostgreSQL 16, optimize this query" \
  --files="queries/user-analytics.sql"
```

#### DuckDB for Analytics

```bash
# Modern analytics database
claude "Context7: DuckDB SQL dialect and performance patterns"
claude "Using Context7 DuckDB, create queries for:
- User engagement metrics
- Cohort analysis
- Time-series aggregations"
```

### ETL Workflows

```bash
# Modern data pipelines
claude "Context7: Apache Airflow 2.8 TaskFlow API"

# Build ETL pipeline
claude "Using Context7 Airflow 2.8 TaskFlow, create pipeline:
- Extract from API
- Transform with pandas
- Load to PostgreSQL
- Error handling and retries"
```

### Data Validation

```bash
# Type-safe validation
claude "Context7: Zod latest patterns for complex schemas"
claude "Using Context7 Zod, create validation for:
- User input sanitization
- API response validation
- Config file validation
With TypeScript type inference"
```

---

## DevOps & Infrastructure

### Infrastructure as Code

#### AWS CDK

```bash
# Latest CDK patterns
claude "Context7: AWS CDK v3 latest constructs and patterns"

# Build infrastructure
claude "Using Context7 AWS CDK v3, create:
- Lambda functions (TypeScript)
- API Gateway REST API
- DynamoDB tables
- S3 buckets with policies
- IAM roles (least privilege)"
```

#### Terraform

```bash
# Modern Terraform
claude "Context7: Terraform 1.7 removed blocks and state management"

# Infrastructure setup
claude "Using Context7 Terraform 1.7, create:
- AWS ECS cluster with Fargate
- Application Load Balancer
- RDS PostgreSQL with replicas
- VPC networking (subnets, security groups)
With proper state management and modules"
```

#### Docker & Kubernetes

```bash
# Latest Docker features
claude "Context7: Docker Compose v2.24 watch mode and profiles"

# Containerization
claude "Using Context7 Docker, create:
- Multi-stage Dockerfile (Node.js app)
- docker-compose.yml with profiles (dev/prod)
- Health checks and volume mounts
- Watch mode for development"

# Kubernetes patterns
claude "Context7: Kubernetes 1.29 deployment patterns"
claude "Create K8s manifests: Deployment, Service, Ingress, ConfigMap"
```

### CI/CD Workflows

#### GitHub Actions

```bash
# Latest Actions features
claude "Context7: GitHub Actions latest workflow syntax"

# CI/CD pipeline
claude "Using Context7 GitHub Actions, create workflow:
- Test on multiple Node versions (matrix)
- Build and push Docker image
- Deploy to AWS ECS
- Security scanning (Snyk/Trivy)
- Slack notifications"
```

#### GitLab CI

```bash
# GitLab CI patterns
claude "Context7: GitLab CI latest pipeline syntax"
claude "Context7: GitLab CI - create pipeline with:
- Test, Build, Deploy stages
- Cache and artifacts patterns
- Environment-specific deployments"
```

---

## Mobile Development

### React Native

```bash
# Latest React Native patterns
claude "Context7: React Native navigation (React Navigation v7)"

# Build mobile feature
claude "Using Context7 React Native, create:
- Bottom tab navigation
- Stack navigator for auth flow
- Deep linking setup
- Push notifications (Expo)"
```

### Expo

```bash
# Modern Expo development
claude "Context7: Expo SDK latest features and EAS updates"
claude "Context7: Expo - setup app with:
- TypeScript and Expo Router
- Authentication flow
- EAS Build/Submit config"
```

---

## Context7 Usage Guide

### When to Use Context7 by Domain

#### Frontend (High Usage - Always Check)
- ✅ **Always use** for React, Next.js, Vue, Svelte
- ✅ Frameworks update frequently (monthly/quarterly)
- ✅ Breaking changes common
- ✅ Best practices evolve rapidly

```bash
# Start every frontend feature with Context7
claude "Context7: [framework] [version] latest best practices"
```

#### Backend (Moderate Usage - Selective)
- ✅ Use for newer frameworks (NestJS, Fastify)
- ✅ Use for ORMs (Prisma, Drizzle - frequent updates)
- ⚠️ Express, traditional patterns less critical

```bash
# Use Context7 for modern tools
claude "Context7: [modern-backend-tool] latest patterns"
```

#### Data Engineering (Selective Usage)
- ✅ Use for newer tools (DuckDB, Polars)
- ⚠️ SQL, pandas relatively stable
- ✅ Use for cloud services (always evolving)

```bash
# Use for cutting-edge data tools
claude "Context7: [new-data-tool] latest features"
```

#### DevOps (Moderate Usage)
- ✅ Use for Kubernetes, cloud services
- ✅ Use for CI/CD platforms (frequent updates)
- ⚠️ Docker basics stable
- ✅ IaC tools update frequently

```bash
# Check for latest cloud/IaC patterns
claude "Context7: [cloud-service] latest best practices"
```

### Context7 Pattern Template

**General workflow:**
```bash
# 1. Learn latest patterns
claude "Context7: [Tool] [Version] [specific feature/pattern]"

# 2. Apply to your code
claude "Using Context7 [Tool] patterns, [task description]
[specific requirements]
Files: [relevant files]"

# 3. Refine with domain knowledge
claude "Review this implementation using Context7 [Tool] best practices" \
  --files="[implementation files]"
```

### Combining Domain Expertise with Context7

**Pattern: Your expertise + latest tools**

```bash
# Your knowledge + Context7 current patterns
claude "As an experienced [domain] developer, review this [component/system].
Use Context7 [Tool] [Version] to suggest modern improvements" \
  --files="[files]"

# Result: Best of both worlds
# - Your domain expertise and architectural knowledge
# - Context7's up-to-date tool-specific patterns
```

---

## Quick Reference: Context7 by Technology

### Frontend
```bash
"Context7: React 19 [feature]"
"Context7: Next.js 15 [pattern]"
"Context7: Vue 3.4 [feature]"
"Context7: Tailwind CSS v4 [feature]"
```

### Backend
```bash
"Context7: NestJS 10 [feature]"
"Context7: Fastify v4 [pattern]"
"Context7: Prisma 5 [feature]"
"Context7: PostgreSQL 16 [feature]"
```

### DevOps
```bash
"Context7: AWS CDK v3 [construct]"
"Context7: Terraform 1.7 [feature]"
"Context7: Kubernetes 1.29 [concept]"
"Context7: Docker Compose v2.24 [feature]"
```

### Data
```bash
"Context7: DuckDB [feature]"
"Context7: Airflow 2.8 [pattern]"
"Context7: Zod [validation pattern]"
```

---

## Summary

**Key Takeaways:**

1. **Context7 is essential for frontend** - frameworks change rapidly
2. **Use selectively for backend** - focus on newer tools and ORMs
3. **Combine with domain expertise** - Context7 + your knowledge = best results
4. **Always specify versions** - "Next.js 15" not just "Next.js"
5. **Check before major work** - verify latest patterns

**Domain-Specific Habits:**

- **Frontend devs**: Start every feature with Context7 check
- **Backend devs**: Use Context7 for ORMs and new frameworks
- **Data engineers**: Use Context7 for newer tools (DuckDB, Polars)
- **DevOps engineers**: Use Context7 for cloud services and K8s

**Expected Results:**
- Build with latest patterns (not outdated tutorials)
- Avoid deprecated features
- Leverage newest framework capabilities
- Stay current without reading all documentation

**Pattern Summary:**
```bash
# 1. Learn (Context7)
claude "Context7: [Tool] [Version] [feature]"

# 2. Apply (with Context7 knowledge)
claude "Using Context7 [Tool] patterns, [task]"

# 3. Review (validate with Context7)
claude "Review using Context7 [Tool] best practices" --files="..."
```

---

[← Back to Part 6](README.md) | [Next: Debugging Patterns →](02-debugging-patterns.md)

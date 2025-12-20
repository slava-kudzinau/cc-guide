---
title: "Section 17: Domain-Specific Workflows"
parent: "Part 6: Domain-Specific & Team Collaboration"
nav_order: 1
---

# Section 17: Domain-Specific Workflows

Specialized patterns and workflows optimized for different development domains. Each domain has unique patterns, tools, and best practices where Claude Code excels.

**What You'll Learn:**
- Frontend development workflows (React, Next.js, Vue, Svelte)
- Backend API development patterns
- Data engineering and SQL optimization
- DevOps and infrastructure as code
- Domain-specific Context7 usage

---

## Table of Contents

1. [Frontend Development](#frontend-development)
2. [Backend Development](#backend-development)
3. [Data Engineering](#data-engineering)
4. [DevOps & Infrastructure](#devops--infrastructure)
5. [Mobile Development](#mobile-development)

---

## Frontend Development

### React & Next.js Workflows

#### Using Context7 for Latest Framework Patterns

**Always check for latest patterns** when working with rapidly evolving frontend frameworks:

```bash
# Get latest Next.js patterns
claude "Context7: Next.js 15 app router authentication with server actions"

# React 19 new features
claude "Context7: React 19 useOptimistic hook - shopping cart example"

# Latest state management
claude "Context7: Zustand v5 best practices for TypeScript"
```

#### Component Development Workflow

```bash
# Step 1: Get current framework patterns
claude "Context7: React 19 component patterns for form handling"

# Step 2: Create component with latest patterns
claude "Using Context7 React 19 patterns, create UserRegistrationForm component:
- Email, password, confirm password fields
- Client-side validation
- Server action submission
- Loading states
- Error handling
Files: src/components/UserRegistrationForm.tsx"

# Step 3: Generate tests
claude "Generate tests for UserRegistrationForm using Testing Library" \
  --files="src/components/UserRegistrationForm.tsx"

# Step 4: Create Storybook story
claude "Create Storybook story with all states: empty, loading, error, success" \
  --files="src/components/UserRegistrationForm.tsx"
```

#### Next.js Feature Development

```bash
# Full feature: User profile with latest Next.js 15
claude "Context7: Next.js 15 app router patterns for authenticated pages"

# Then build feature
claude "Using Context7 Next.js 15 patterns, create user profile feature:

Structure:
- app/profile/page.tsx (server component)
- app/profile/edit/page.tsx (form with server actions)
- components/ProfileCard.tsx (client component)
- lib/actions/profile.ts (server actions)

Requirements:
- Server-side auth check
- Data fetching with React Suspense
- Optimistic updates for edits
- Error boundaries
- Loading states"
```

#### Screenshot to Code Workflow

```bash
# Convert design to code
claude "Convert this screenshot to Next.js 15 component using Context7 latest patterns" \
  --files="design.png"

# Refine with framework-specific patterns
claude "Context7: Next.js 15 Image component best practices - apply to generated code"
```

### Vue & Svelte Workflows

#### Vue 3 with Context7

```bash
# Get latest Composition API patterns
claude "Context7: Vue 3.4 defineModel macro and reactivity patterns"

# Build component with latest features
claude "Using Context7 Vue 3.4 patterns, create reactive form component:
- defineModel for v-model
- Composition API
- TypeScript support"
```

#### Svelte 5 with Runes

```bash
# Learn new Svelte 5 syntax
claude "Context7: Svelte 5 runes API - $state, $derived, $effect"

# Migrate from Svelte 4
claude "Context7: Svelte 5 migration guide - convert this Svelte 4 component" \
  --files="src/lib/UserCard.svelte"
```

### Styling Workflows

```bash
# Tailwind CSS latest features
claude "Context7: Tailwind CSS v4 features - container queries"

# Style component with modern Tailwind
claude "Using Context7 Tailwind v4 patterns, style this component with:
- Container queries
- Modern grid
- Dark mode support" \
  --files="src/components/Dashboard.tsx"
```

---

## Backend Development

### API Development with Context7

#### Node.js & Express

```bash
# Latest Node.js features
claude "Context7: Node.js 22 native TypeScript support - setup guide"

# Modern Express patterns
claude "Using Context7 Express.js 5 features, create RESTful API:
- /api/users CRUD endpoints
- JWT authentication middleware
- Request validation
- Error handling
- OpenAPI/Swagger docs"
```

#### NestJS

```bash
# Latest NestJS patterns
claude "Context7: NestJS 10 standalone applications and microservices"

# Build feature with current patterns
claude "Using Context7 NestJS 10 patterns, create user authentication module:
- JWT strategy
- Guards
- Decorators
- Swagger integration"
```

#### Fastify

```bash
# High-performance API patterns
claude "Context7: Fastify v4 async hooks and plugin system"

# Build with latest patterns
claude "Context7: Fastify v4 - create optimized API with schema validation" \
  --files="src/routes/users.ts"
```

### Database Workflows

#### Prisma ORM

```bash
# Latest Prisma features
claude "Context7: Prisma 5 client extensions - custom methods"

# Schema design with current patterns
claude "Using Context7 Prisma 5 patterns, create schema for:
- Users, posts, comments (relations)
- Soft deletes using client extensions
- Full-text search
- Optimistic concurrency control"

# Migration generation
claude "Generate Prisma migration for adding user roles" \
  --files="prisma/schema.prisma"
```

#### TypeORM

```bash
# Latest TypeORM patterns
claude "Context7: TypeORM 0.3 DataSource and migration patterns"

# Entity creation
claude "Context7: TypeORM 0.3 - create User entity with:
- Relations
- Indexes
- Listeners
- Custom repository"
```

#### Drizzle ORM

```bash
# Modern type-safe ORM
claude "Context7: Drizzle ORM latest query syntax and relations"

# Schema with latest patterns
claude "Using Context7 Drizzle patterns, create schema and queries for blog system"
```

### Authentication Workflows

```bash
# Modern auth patterns
claude "Context7: Next.js 15 authentication with Auth.js (NextAuth v5)"

# Implement full auth system
claude "Using Context7 Auth.js v5 patterns, implement:
- Google OAuth
- GitHub OAuth
- Email/password
- Session management
- Protected routes"
```

---

## Data Engineering

### SQL Optimization with Context7

#### Modern SQL Patterns

```bash
# Latest PostgreSQL features
claude "Context7: PostgreSQL 16 new features - JSON improvements"

# Optimize queries with latest patterns
claude "Using Context7 PostgreSQL 16 features, optimize this query" \
  --files="queries/user-analytics.sql"
```

#### DuckDB for Analytics

```bash
# Modern analytics database
claude "Context7: DuckDB latest SQL dialect and performance tips"

# Create analytics queries
claude "Using Context7 DuckDB patterns, create queries for:
- User engagement metrics
- Cohort analysis
- Time-series aggregations"
```

### ETL Workflows

```bash
# Modern data pipeline patterns
claude "Context7: Apache Airflow 2.8 latest features - TaskFlow API"

# Build pipeline with current patterns
claude "Using Context7 Airflow 2.8 TaskFlow patterns, create ETL pipeline:
- Extract from API
- Transform with pandas
- Load to PostgreSQL
- Error handling & retries"
```

### Data Validation

```bash
# Modern validation with Zod
claude "Context7: Zod latest patterns for complex schemas"

# Create validation schemas
claude "Using Context7 Zod patterns, create validation for:
- User input
- API responses
- Configuration files
With TypeScript inference"
```

---

## DevOps & Infrastructure

### Infrastructure as Code with Context7

#### AWS CDK

```bash
# Latest CDK patterns
claude "Context7: AWS CDK v3 latest constructs and patterns"

# Build infrastructure with current patterns
claude "Using Context7 AWS CDK v3 patterns, create:
- Lambda functions
- API Gateway
- DynamoDB tables
- S3 buckets
- IAM roles
With TypeScript"
```

#### Terraform

```bash
# Modern Terraform
claude "Context7: Terraform 1.7 removed blocks and state management"

# Infrastructure with latest features
claude "Using Context7 Terraform 1.7 patterns, create:
- AWS ECS cluster
- Application Load Balancer
- RDS PostgreSQL
- Networking (VPC, subnets)
With proper state management"
```

#### Docker & Kubernetes

```bash
# Latest Docker features
claude "Context7: Docker Compose v2.24 watch mode and profiles"

# Modern containerization
claude "Using Context7 Docker patterns, create:
- Multi-stage Dockerfile for Node.js app
- docker-compose.yml with profiles (dev, prod)
- Health checks
- Watch mode for development"

# Kubernetes patterns
claude "Context7: Kubernetes 1.29 latest deployment patterns"
```

### CI/CD Workflows

#### GitHub Actions

```bash
# Latest Actions features
claude "Context7: GitHub Actions latest workflow syntax and features"

# Modern CI/CD pipeline
claude "Using Context7 GitHub Actions patterns, create workflow:
- Test on multiple Node versions
- Build Docker image
- Deploy to AWS ECS
- Notify on Slack
- Security scanning"
```

#### GitLab CI

```bash
# Current GitLab CI patterns
claude "Context7: GitLab CI latest pipeline syntax"

# Create pipeline
claude "Context7: GitLab CI - create pipeline with stages:
- Test, Build, Deploy
- Using latest cache and artifacts patterns"
```

---

## Mobile Development

### React Native with Context7

```bash
# Latest React Native patterns
claude "Context7: React Native latest navigation patterns (React Navigation v7)"

# Build feature with current patterns
claude "Using Context7 React Native patterns, create:
- Bottom tab navigation
- Stack navigator for auth flow
- Deep linking
- Push notifications setup"
```

### Expo

```bash
# Modern Expo development
claude "Context7: Expo SDK latest features and EAS updates"

# Create app with latest patterns
claude "Context7: Expo - setup new app with:
- TypeScript
- Expo Router
- Authentication
- EAS Build/Submit configuration"
```

---

## Domain-Specific Best Practices

### When to Use Context7 by Domain

#### Frontend (High Context7 Usage)
- ✅ **Always use** for React, Next.js, Vue, Svelte
- ✅ Frameworks update frequently (monthly/quarterly)
- ✅ Breaking changes common
- ✅ Best practices evolve rapidly

```bash
# Check before starting any frontend work
claude "Context7: [framework] [version] latest best practices"
```

#### Backend (Moderate Context7 Usage)
- ✅ Use for newer frameworks (NestJS, Fastify)
- ✅ Use for ORMs (Prisma, Drizzle frequent updates)
- ⚠️ Express, traditional patterns less critical

```bash
# Use Context7 for newer tools
claude "Context7: [modern-tool] latest patterns"
```

#### Data Engineering (Selective Context7 Usage)
- ✅ Use for newer tools (DuckDB, Polars)
- ⚠️ SQL, pandas relatively stable
- ✅ Use for cloud services (always evolving)

```bash
# Use for cutting-edge tools
claude "Context7: [new-data-tool] latest features"
```

#### DevOps (Moderate Context7 Usage)
- ✅ Use for Kubernetes, cloud services
- ✅ Use for CI/CD platforms (frequent updates)
- ⚠️ Docker basics stable
- ✅ IaC tools update frequently

```bash
# Check for latest cloud patterns
claude "Context7: [cloud-service] latest best practices"
```

### Combining Domain Knowledge with Context7

**Pattern: Domain expertise + latest tools**

```bash
# Your domain knowledge + Context7 current patterns

claude "As an experienced backend developer, review this API design.
Use Context7 Fastify v4 patterns to suggest modern improvements" \
  --files="src/routes/api.ts"

# Your expertise: API design principles
# Context7: Latest Fastify patterns
# Result: Best of both worlds
```

---

## Quick Reference: Context7 by Technology

### Frontend

```bash
# React ecosystem
"Context7: React 19 [feature]"
"Context7: Next.js 15 [pattern]"
"Context7: Remix v2 [concept]"

# Vue ecosystem
"Context7: Vue 3.4 [feature]"
"Context7: Nuxt 4 [pattern]"

# Styling
"Context7: Tailwind CSS v4 [feature]"
"Context7: CSS Container Queries"
```

### Backend

```bash
# Frameworks
"Context7: NestJS 10 [feature]"
"Context7: Fastify v4 [pattern]"
"Context7: tRPC v11 [concept]"

# Databases
"Context7: Prisma 5 [feature]"
"Context7: PostgreSQL 16 [feature]"
"Context7: Redis 7 [pattern]"
```

### DevOps

```bash
# IaC
"Context7: AWS CDK v3 [construct]"
"Context7: Terraform 1.7 [feature]"
"Context7: Pulumi [language] [pattern]"

# Containers
"Context7: Docker Compose v2.24 [feature]"
"Context7: Kubernetes 1.29 [concept]"
```

### Data

```bash
# Analytics
"Context7: DuckDB [feature]"
"Context7: ClickHouse [pattern]"

# Orchestration
"Context7: Airflow 2.8 [feature]"
"Context7: Dagster [pattern]"
```

---

## Summary

**Key Takeaways:**

1. **Context7 is essential for frontend** - frameworks change rapidly
2. **Use selectively for backend** - focus on newer tools
3. **Combine with domain expertise** - Context7 + your knowledge
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
- Stay current without reading all docs

---

[← Back to Part 6](README.md) | [Next: Team Collaboration →](18-team-collaboration.md)


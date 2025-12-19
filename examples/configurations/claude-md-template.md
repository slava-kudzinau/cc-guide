# CLAUDE.md Template

This file provides persistent context to Claude about your project.

## Basic Template

````markdown
---
project: [Project Name]
tech_stack:
  - [Technology 1]
  - [Technology 2]
  - [Technology 3]
---

# Project Context

## Overview
[Brief description of what this project does]

## Architecture
- **Component 1:** [Description]
- **Component 2:** [Description]
- **Component 3:** [Description]

## Coding Standards
- [Standard 1]
- [Standard 2]
- [Standard 3]

## Testing Requirements
- [Requirement 1]
- [Requirement 2]

## Common Commands
```bash
npm run dev     # [Description]
npm test        # [Description]
npm run build   # [Description]
```

## Important Files
- `src/main.ts` - [Description]
- `config/` - [Description]
````

## Full Example (Node.js API)

````markdown
---
project: E-Commerce API
tech_stack:
  - Node.js 20
  - TypeScript 5.3
  - Express 4.18
  - PostgreSQL 15
  - Redis 7
  - Jest (testing)
  - Docker
---

# E-Commerce API Context

## Overview
RESTful API for e-commerce platform. Handles products, orders, payments, and user management.

## Architecture
- **API Gateway:** Express with rate limiting and CORS
- **Auth Service:** JWT tokens + refresh tokens (Redis)
- **Product Service:** CRUD + Elasticsearch for search
- **Order Service:** State machine for order processing
- **Payment Service:** Stripe integration
- **Notification Service:** Email/SMS via message queue

## Database
- **PostgreSQL:** Main data store
- **Redis:** Sessions, caching, rate limiting
- **Elasticsearch:** Product search

## Coding Standards
- TypeScript strict mode enabled
- ESLint + Prettier configured
- 80% test coverage minimum
- All APIs must have OpenAPI documentation
- Use async/await (no callbacks)
- Error handling: centralized middleware
- Logging: structured JSON (Winston)

## Naming Conventions
- Files: kebab-case (user-service.ts)
- Classes: PascalCase (UserService)
- Functions: camelCase (getUserById)
- Constants: UPPER_SNAKE_CASE (MAX_RETRIES)
- Database columns: snake_case (created_at)

## Error Handling
```typescript
// Always use AppError for known errors
throw new AppError('User not found', 404);

// Log unexpected errors
logger.error('Unexpected error', { error, context });
```

## Testing
- **Unit tests:** `*.spec.ts` (mock external deps)
- **Integration tests:** `*.integration.ts` (test database)
- **E2E tests:** `*.e2e.ts` (full flow)
- Run before commit: `npm test`

## Common Commands
```bash
npm run dev             # Start dev server (nodemon)
npm test               # Run all tests
npm run test:watch     # Watch mode
npm run db:migrate     # Run database migrations
npm run db:seed        # Seed test data
npm run lint           # Lint code
npm run build          # Build for production
```

## Important Files
- `src/app.ts` - Express app setup
- `src/routes/` - API route definitions
- `src/services/` - Business logic
- `src/models/` - Database models (TypeORM)
- `src/middleware/` - Express middleware
- `config/` - Configuration files
- `migrations/` - Database migrations

## External APIs
- **Stripe:** Payments (keys in .env)
- **SendGrid:** Email (SENDGRID_API_KEY)
- **Twilio:** SMS (TWILIO_* vars)
- **AWS S3:** File storage

## Security
- All endpoints require authentication (except /health)
- Admin endpoints require admin role
- Rate limiting: 100 req/min per IP
- SQL injection prevention: use parameterized queries
- XSS prevention: sanitize all inputs
- Secrets: stored in .env (never commit)

## Performance
- Cache GET requests (Redis, 5min TTL)
- Pagination: max 100 items per page
- Database indexes on frequently queried fields
- Connection pooling enabled (max 20 connections)

## Deployment
- Docker container (multi-stage build)
- Kubernetes (3 replicas minimum)
- Health check: GET /health
- Metrics: Prometheus endpoint /metrics
````

## Tips for CLAUDE.md

✅ **Do:**
- Be specific and concise
- Include tech stack and versions
- Document coding standards
- List common commands
- Explain project structure
- Note important patterns

❌ **Don't:**
- Include entire codebase
- Add implementation details
- Duplicate README content
- Include temporary notes
- Exceed 5000 tokens




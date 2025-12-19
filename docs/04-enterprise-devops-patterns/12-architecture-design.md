# Section 12: Architecture & System Design

## Microservices Architecture

### Design Consistency Across Services
```bash
claude "Analyze these microservices for consistency:
@auth-service/src/
@user-service/src/
@payment-service/src/

Check for:
- Error handling patterns
- Logging standards
- API response formats
- Authentication methods
- Database transaction patterns

Suggest standardization improvements"
```

## API Design Automation

### OpenAPI Generation
```bash
# Generate OpenAPI spec
claude "@src/routes/ Generate OpenAPI 3.0 specification:
- Include all endpoints
- Request/response schemas
- Authentication (Bearer JWT)
- Error responses (400, 401, 403, 404, 500)
- Examples for each endpoint"
```

### REST API Best Practices
```bash
claude "Design RESTful API for e-commerce:
Resources: users, products, orders, payments
Requirements:
- Proper HTTP methods
- Pagination (cursor-based)
- Filtering & sorting
- Rate limiting
- Versioning (/v1/)
- HATEOAS links

Generate: routes.md with all endpoints"
```

## Database Schema Design

### Schema Generation
```bash
claude "Design PostgreSQL schema for:
- Multi-tenant SaaS application
- Users, Organizations, Projects, Tasks
- Role-based access (org-level, project-level)
- Audit trail for all changes
- Soft deletes

Generate: migrations with proper indexes, constraints, foreign keys"
```

## Technical Debt Analysis

### Codebase Assessment
```bash
claude "Analyze technical debt in @src/:
1. Code duplication (DRY violations)
2. Complex functions (cyclomatic complexity)
3. Missing tests (coverage gaps)
4. Outdated dependencies
5. TODO/FIXME comments with context
6. Anti-patterns

Prioritize by: impact and effort to fix"
```

[← Back: DevOps & CI/CD](11-devops-cicd) | [Next: Security & Compliance →](13-security-compliance)




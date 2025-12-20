---
title: "Section 2b: CLAUDE.md - Your Project's Memory"
parent: "Part 1: Fundamentals & Core Concepts"
nav_order: 3
---

# Section 2b: CLAUDE.md - Your Project's Memory

CLAUDE.md is the **single most important file** for working with Claude Code. It's your project's persistent context that Claude reads automatically in every session.

---

## What Is CLAUDE.md?

Think of CLAUDE.md as:
- 📖 **Project README for AI** - Essential project knowledge
- 📝 **Coding Standards Document** - Your team's conventions
- 🏗️ **Architecture Decision Record** - Why things are the way they are
- 🧠 **Team Knowledge Base** - Shared understanding

**Key Principle**: Anything Claude should **ALWAYS** know → Put in CLAUDE.md

---

## Why It Matters

### Without CLAUDE.md

```bash
# Session 1
You: "Add a REST endpoint"
Claude: Creates endpoint with generic pattern

# Session 2 (next day)
You: "Add another endpoint"
Claude: Creates endpoint with DIFFERENT pattern
# Has to guess your patterns every time
# Inconsistent code
# You repeat yourself constantly
```

### With CLAUDE.md

```bash
# Session 1
You: "Add a REST endpoint"
Claude: Reads CLAUDE.md → Follows YOUR patterns

# Session 2 (next day)
You: "Add another endpoint"
Claude: Reads CLAUDE.md → Uses SAME patterns
# Consistent code
# No repetition needed
# Scales with team
```

---

## Quick Start (5 Minutes)

Create `CLAUDE.md` in your project root:

```markdown
# [Your Project Name]

## What This Is
[One sentence: what does this project do?]

## Tech Stack
- **Backend**: [Your stack]
- **Database**: [Your DB]
- **Testing**: [Your framework]

## Key Rules
- [Rule 1]
- [Rule 2]
- [Rule 3]
```

**That's it!** Even this minimal version helps Claude significantly.

---

## Template Levels

### Level 1: Minimal (5 minutes) ⭐

**When**: Starting new project, quick setup

```markdown
# MyProject

## What This Is
E-commerce API for selling handmade crafts

## Tech Stack
- **Backend**: Node.js 18 + Express 4
- **Database**: PostgreSQL 14
- **Testing**: Jest
- **Deployment**: AWS ECS

## Project Structure
```
src/
  ├── routes/      # API endpoints
  ├── services/    # Business logic
  ├── models/      # Database models
  └── middleware/  # Express middleware
```

## Key Conventions
- **Files**: kebab-case (user-service.js)
- **Functions**: camelCase (getUserById)
- **Classes**: PascalCase (UserService)

## Important Rules
- Always write tests before implementation (TDD)
- All API responses: `{ success, data, error }` format
- Use async/await (never callbacks)
```

**When to use**: 
- ✅ New projects
- ✅ Learning/prototyping
- ✅ Small teams (<3 people)

**Limitations**:
- ❌ No patterns documented
- ❌ No anti-patterns
- ❌ No architecture decisions

---

### Level 2: Intermediate (15 minutes) ⭐⭐⭐

**When**: Production projects, team collaboration

```markdown
# MyProject

[Include all from Level 1, plus:]

## Architectural Decisions

### Authentication
We use JWT tokens stored in httpOnly cookies (NOT localStorage).

**Why**: Prevents XSS attacks
**Implementation**: `@src/middleware/auth.js`
**Token expiry**: 24 hours
**Refresh strategy**: Sliding window

### Database Access
All database queries go through the Repository pattern.

**Why**: Easier to test, swap databases
**Pattern**:
```
Routes → Controllers → Services → Repositories → Database
```

**Don't**: Write SQL in routes or services
**Do**: Use repository methods

### Error Handling
All errors use our custom `AppError` class:

```javascript
class AppError extends Error {
  constructor(message, statusCode, code) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = true;
  }
}

// Usage
throw new AppError('User not found', 404, 'USER_NOT_FOUND');
```

**Handling**:
- Operational errors: Send to client
- Programming errors: Log + 500
- Always log with context

## Code Patterns

### API Endpoint Pattern
```javascript
// routes/users.js
router.post('/users', 
  validateRequest(userSchema),    // 1. Validate input
  authenticate(),                  // 2. Check auth
  authorize('admin'),              // 3. Check permissions
  async (req, res, next) => {     // 4. Handle request
    try {
      const user = await userService.create(req.body);
      res.json({ success: true, data: user });
    } catch (error) {
      next(error);  // Pass to error middleware
    }
  }
);
```

**Always**:
1. Validate input first
2. Check authentication
3. Check authorization
4. Handle errors with try/catch
5. Pass errors to middleware

### Service Pattern
```javascript
// services/user-service.js
class UserService {
  constructor(userRepository) {
    this.users = userRepository;
  }

  async create(userData) {
    // 1. Validate business rules
    await this.validateBusinessRules(userData);
    
    // 2. Transform/prepare data
    const user = await this.prepareUser(userData);
    
    // 3. Save via repository
    const saved = await this.users.create(user);
    
    // 4. Post-process (e.g., send email)
    await this.sendWelcomeEmail(saved);
    
    return saved;
  }
}
```

**Structure**:
- Validate business rules first
- Transform data
- Delegate persistence to repository
- Handle side effects (emails, events)

### Repository Pattern
```javascript
// repositories/user-repository.js
class UserRepository {
  async create(userData) {
    return db.query(
      'INSERT INTO users (name, email) VALUES (?, ?)',
      [userData.name, userData.email]
    );
  }

  async findById(id) {
    const user = await db.query(
      'SELECT * FROM users WHERE id = ?',
      [id]
    );
    return user[0];
  }
}
```

**Purpose**: Encapsulate all database access

## Testing Standards

### Test Structure (AAA Pattern)
```javascript
describe('UserService', () => {
  describe('create', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const userData = { 
        name: 'John', 
        email: 'john@example.com' 
      };
      
      // Act
      const user = await userService.create(userData);
      
      // Assert
      expect(user).toBeDefined();
      expect(user.email).toBe('john@example.com');
    });
  });
});
```

### What to Test
✅ **Do test**:
- All public methods
- Edge cases (null, empty, boundary values)
- Error cases (network fail, DB error)
- Business logic

❌ **Don't test**:
- Private methods (test through public)
- Third-party libraries
- Trivial getters/setters

### Test Coverage
- Unit tests: 80%+ coverage
- Integration tests: Critical paths
- E2E tests: User journeys

## Common Tasks

### Adding a New Feature
1. Check for similar features: `grep -r "similar_feature" src/`
2. Create feature branch: `git checkout -b feature/your-feature`
3. Write tests first (TDD)
4. Implement following patterns above
5. Update this doc if new patterns introduced

### Database Migration
```bash
# Create
npm run migration:create add_user_roles

# Edit migration file in migrations/
# migrations/TIMESTAMP_add_user_roles.sql

# Run
npm run migration:run

# Rollback if needed
npm run migration:rollback
```

### Running Tests
```bash
# All tests
npm test

# Watch mode
npm test -- --watch

# Coverage
npm test -- --coverage

# Single file
npm test -- user-service.test.js
```
```

**When to use**:
- ✅ Production applications
- ✅ Teams of 3-10 people
- ✅ Projects with established patterns

**Covers**:
- ✅ Architecture decisions
- ✅ Code patterns with examples
- ✅ Testing standards
- ✅ Common tasks

---

### Level 3: Advanced (30 minutes) ⭐⭐⭐⭐⭐

**When**: Large teams, complex systems, critical applications

```markdown
# MyProject

[Include all from Level 2, plus:]

## Domain-Specific Context

### Payment Processing
We integrate with Stripe for all payments.

**Key Considerations**:
- All amounts in cents (never dollars)
- Always use idempotency keys for retries
- Webhook signature verification required
- Sandbox vs Production keys in `.env`

**Example**:
```javascript
const charge = await stripe.charges.create({
  amount: 5000,  // $50.00 in cents
  currency: 'usd',
  source: tokenId,
  idempotency_key: `charge_${orderId}_${timestamp}`
});
```

**Error Handling**:
- Card declined → Show friendly message
- Network error → Retry with exponential backoff
- Webhook failure → Alert on-call

### Email System
We use SendGrid for transactional emails.

**Template Management**:
- Templates defined in SendGrid dashboard
- Template IDs in `@config/email.config.js`
- Dynamic data passed as `dynamic_template_data`

**Queue System**:
- **Never** send emails directly from routes
- Always queue with Bull (Redis-backed)
- Retry failed emails: 3 attempts, exponential backoff

**Monitoring**:
- Track delivery rate (should be >95%)
- Alert on bounce rate >5%
- Track open rate (engagement metric)

### File Uploads
We use Cloudinary for image storage.

**Image Processing**:
- Auto-optimize on upload
- Generate thumbnails: 100x100, 300x300, 1000x1000
- WEBP format for modern browsers, fallback to JPEG
- Lazy loading on frontend

**Storage Strategy**:
- User avatars: /avatars/{userId}/{filename}
- Product images: /products/{productId}/{filename}
- Temporary uploads: /temp/ (auto-delete after 24h)

## Anti-Patterns (Don't Do This!)

### ❌ Anti-Pattern: Direct Database in Routes
```javascript
// BAD
router.get('/users', async (req, res) => {
  const users = await db.query('SELECT * FROM users');
  res.json(users);
});

// GOOD
router.get('/users', async (req, res) => {
  const users = await userService.findAll();
  res.json({ success: true, data: users });
});
```

**Why**: Routes should be thin orchestrators, not contain business logic.

### ❌ Anti-Pattern: Callback Hell
```javascript
// BAD
getUserById(id, (err, user) => {
  if (err) throw err;
  getOrders(user.id, (err, orders) => {
    if (err) throw err;
    res.json(orders);
  });
});

// GOOD
const user = await userService.getById(id);
const orders = await orderService.getByUser(user.id);
res.json({ success: true, data: orders });
```

**Why**: async/await is more readable and handles errors better.

### ❌ Anti-Pattern: Hardcoded Values
```javascript
// BAD
const apiKey = 'sk_live_abc123xyz';
const timeout = 30000;

// GOOD
const apiKey = process.env.STRIPE_SECRET_KEY;
const timeout = config.api.timeout;
```

**Why**: Secrets leak, hardcoded values are hard to change across environments.

### ❌ Anti-Pattern: Ignoring Error Cases
```javascript
// BAD
const user = await userRepository.findById(id);
return user.email;  // Crashes if user is null

// GOOD
const user = await userRepository.findById(id);
if (!user) {
  throw new AppError('User not found', 404, 'USER_NOT_FOUND');
}
return user.email;
```

**Why**: Always handle edge cases explicitly.

## Debugging Guide

### Common Issues

#### Issue: "Cannot read property 'id' of undefined"
**Cause**: Missing null check
**Fix**: Use optional chaining or explicit check
```javascript
// Before
const userId = user.id;

// After
const userId = user?.id ?? null;
// or
if (!user) throw new AppError('User not found', 404);
const userId = user.id;
```

**Prevention**: Add validation middleware to all routes

#### Issue: "Port 3000 already in use"
**Cause**: Server still running from previous session
**Fix**: 
```bash
# macOS/Linux
lsof -ti:3000 | xargs kill -9

# Windows
netstat -ano | findstr :3000
taskkill /PID [PID] /F
```

**Prevention**: Use `nodemon` for auto-restart, or Docker for isolation

#### Issue: "Test database not reset between tests"
**Cause**: Forgot to clear DB in `beforeEach`
**Fix**:
```javascript
beforeEach(async () => {
  await db.query('TRUNCATE TABLE users CASCADE');
  // Or use database migrations
  await db.migrate.latest();
  await db.seed.run();
});
```

**Prevention**: Add to test setup file that runs before all tests

### Performance Debugging

#### Slow API Endpoint
```bash
# 1. Profile with Node.js profiler
node --inspect server.js

# 2. Check database query time
EXPLAIN ANALYZE SELECT...

# 3. Check for N+1 queries
# Look for queries in loops

# 4. Add logging
logger.debug('Query time', { duration, query });
```

#### Memory Leak
```bash
# 1. Take heap snapshot
node --inspect server.js
# Chrome DevTools → Memory → Take Snapshot

# 2. Look for growing arrays/objects
# 3. Check for event listeners not removed
# 4. Check for closures holding references
```

## Security Checklist

### Before Deployment
- [ ] No API keys in code (use env vars)
- [ ] All inputs validated
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (output escaping)
- [ ] CSRF protection enabled
- [ ] Rate limiting on API
- [ ] HTTPS enforced
- [ ] Dependencies updated (no known vulnerabilities)
- [ ] Secrets in vault (not `.env` in production)
- [ ] Logging doesn't include sensitive data (passwords, tokens)

### Regular Maintenance
- [ ] Weekly: Update dependencies
- [ ] Monthly: Security audit
- [ ] Quarterly: Penetration test
- [ ] Rotate secrets every 90 days

## Environment Setup

### Prerequisites
```bash
# Required versions
node >= 18.0.0
postgresql >= 14
redis >= 7.0

# Optional (recommended)
docker >= 20.10
docker-compose >= 2.0
```

### First-Time Setup
```bash
# 1. Install dependencies
npm install

# 2. Setup environment
cp .env.example .env
# Edit .env with your values:
#   - DATABASE_URL
#   - REDIS_URL
#   - STRIPE_SECRET_KEY
#   - etc.

# 3. Database setup
npm run db:create
npm run db:migrate
npm run db:seed  # Optional: seed data

# 4. Start development server
npm run dev

# 5. Verify setup
curl http://localhost:3000/health
# Should return: {"status": "ok"}
```

### Connecting to Services

**PostgreSQL (Local)**:
```
Host: localhost
Port: 5432
Database: myproject_dev
User: postgres
Password: (see .env)
```

**Redis (Local)**:
```
Host: localhost
Port: 6379
Password: (none for local)
```

**Stripe (Sandbox)**:
```
Public Key: pk_test_...
Secret Key: sk_test_...
Webhook Secret: whsec_test_...
```

## Team Practices

### Before Committing
- [ ] All tests pass: `npm test`
- [ ] Linting passes: `npm run lint`
- [ ] No `console.log` in production code
- [ ] No commented-out code (delete it)
- [ ] Tests added for new features
- [ ] This document updated if patterns changed

### Pull Request Requirements
**Title**: Conventional commits format
- `feat(scope): description` for features
- `fix(scope): description` for bug fixes
- `refactor(scope): description` for refactoring
- `docs(scope): description` for documentation

**Description Must Include**:
- **What**: What changed
- **Why**: Why this change was needed
- **How to Test**: Steps to verify it works
- **Screenshots**: For UI changes
- **Breaking Changes**: If any
- **Related Issue**: Link to ticket

**Example**:
```markdown
## What
Add user role-based access control

## Why
- Requirement from PM: different permissions for admin/editor/viewer
- Security: prevent users from accessing admin functions

## How to Test
1. Create user with each role
2. Verify admin can access /admin routes
3. Verify editors cannot access /admin
4. Check tests: npm test -- roles.test.js

## Screenshots
[Screenshot of admin UI]

## Breaking Changes
None

## Related Issue
Fixes #123
```

### Code Review Checklist
**Reviewer checks**:
- [ ] Code follows patterns in this document
- [ ] Tests are comprehensive
- [ ] No security issues
- [ ] Performance considered
- [ ] Error handling adequate
- [ ] Documentation updated (if needed)
- [ ] No commented code
- [ ] Names are descriptive

## Performance Guidelines

### Response Time Targets
- API endpoints: <200ms (p95)
- Database queries: <50ms
- External API calls: <500ms
- Page load: <1s

### Optimization Strategies
1. **Database**:
   - Add indexes for frequently queried columns
   - Use connection pooling
   - Limit result sets (pagination)
   - Avoid N+1 queries

2. **Caching**:
   - Redis for session data
   - Cache-Control headers for static assets
   - ETags for conditional requests
   - Query result caching (where appropriate)

3. **API**:
   - Compress responses (gzip)
   - Rate limiting
   - Request batching
   - Async processing for slow tasks

### Monitoring
- Use New Relic / Datadog for APM
- Track key metrics:
  - Response time (p50, p95, p99)
  - Error rate
  - Throughput (requests/sec)
  - Database query time
- Alert thresholds:
  - Error rate > 1%
  - p95 response time > 500ms
  - CPU > 80%
  - Memory > 85%

## Deployment

### Environments
- **Development**: Local machines
- **Staging**: staging.myproject.com (AWS ECS)
- **Production**: myproject.com (AWS ECS)

### Deployment Process
```bash
# 1. Merge PR to main
# 2. CI/CD runs tests
# 3. Auto-deploy to staging
# 4. Manual verification on staging
# 5. Promote to production (manual approval)
```

### Rollback Procedure
```bash
# If production issue detected:
1. Click "Rollback" in deployment dashboard
2. Verify previous version deployed
3. Investigate issue in staging
4. Fix and redeploy
```

### Database Migrations
```bash
# Staging
npm run migration:run --env=staging

# Verify migration succeeded
# Check logs, test critical paths

# Production (during maintenance window)
npm run migration:run --env=production

# Monitor for issues
# Have rollback migration ready
```

## Contact & Resources

### Team
- **Tech Lead**: @alice (Slack: @alice)
- **DevOps**: @bob (Slack: @bob)
- **On-call**: Check #oncall Slack channel

### Documentation
- **API Docs**: `/docs/api/`
- **Architecture**: `/docs/architecture/`
- **Runbooks**: `/docs/runbooks/`

### External Resources
- **Stripe Docs**: https://stripe.com/docs
- **SendGrid Docs**: https://docs.sendgrid.com
- **AWS ECS Docs**: https://docs.aws.amazon.com/ecs

## Changelog

### 2025-12-19
- Added role-based access control patterns
- Updated error handling examples
- Added security checklist

### 2025-12-01
- Initial CLAUDE.md creation
- Documented existing patterns
- Added testing standards
```

**When to use**:
- ✅ Large teams (10+ people)
- ✅ Complex systems
- ✅ Critical applications
- ✅ Long-term projects

**Covers**:
- ✅ Everything from Level 2
- ✅ Domain-specific context
- ✅ Anti-patterns
- ✅ Debugging guide
- ✅ Security checklist
- ✅ Team practices
- ✅ Deployment procedures

---

## Real-World Examples

### Example 1: Express.js REST API

```markdown
# E-Commerce REST API

## Tech Stack
- Node.js 18 + Express 4
- PostgreSQL 14
- Redis 7 (caching)
- Stripe (payments)
- SendGrid (emails)

## Core Principles
1. **Thin routes**: Routes orchestrate, services contain logic
2. **Repository pattern**: All DB access through repositories
3. **Error middleware**: Centralized error handling
4. **TDD**: Tests before implementation

## Route Pattern
```javascript
router.post('/products',
  authenticate(),           // JWT validation
  authorize('admin'),       // Role check
  validate(productSchema),  // Input validation
  async (req, res, next) => {
    try {
      const product = await productService.create(req.body);
      res.status(201).json({ success: true, data: product });
    } catch (error) {
      next(error);
    }
  }
);
```

## Service Pattern
```javascript
class ProductService {
  async create(productData) {
    // Validate business rules
    await this.validateSKU(productData.sku);
    
    // Transform data
    const product = this.prepareProduct(productData);
    
    // Save
    return await this.productRepository.create(product);
  }
}
```

## Database Conventions
- Tables: `snake_case` (user_orders)
- Columns: `snake_case` (created_at)
- Indexes: `idx_tablename_columnname`
- Foreign keys: `fk_table1_table2`

## Testing Pattern
```javascript
describe('ProductService', () => {
  beforeEach(() => {
    // Reset database
  });
  
  describe('create', () => {
    it('creates product with valid data', async () => {
      const data = { name: 'Widget', price: 1999, sku: 'W-001' };
      const product = await service.create(data);
      expect(product.price).toBe(1999);
    });
  });
});
```
```

---

### Example 2: React Frontend

```markdown
# Dashboard Frontend

## Tech Stack
- React 18
- TypeScript
- Tailwind CSS
- React Query (server state)
- Zustand (client state)

## Component Structure
```
src/
  ├── components/     # Shared components
  │   ├── Button/
  │   │   ├── Button.tsx
  │   │   ├── Button.module.css
  │   │   └── Button.test.tsx
  │   └── ...
  ├── features/       # Feature-specific components
  │   ├── auth/
  │   ├── products/
  │   └── ...
  ├── hooks/          # Custom hooks
  ├── services/       # API calls
  └── stores/         # Zustand stores
```

## Component Pattern
```typescript
interface ButtonProps {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  onClick?: () => void;
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  onClick,
  children
}) => {
  return (
    <button
      className={`btn btn-${variant} btn-${size}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```

## State Management
- **Local state**: useState (component-specific)
- **Form state**: React Hook Form
- **Server state**: React Query (API data)
- **Global state**: Zustand (theme, user, etc.)

**Example**:
```typescript
// Zustand store
const useAuthStore = create<AuthState>((set) => ({
  user: null,
  login: (user) => set({ user }),
  logout: () => set({ user: null }),
}));

// React Query
const { data, isLoading } = useQuery({
  queryKey: ['products'],
  queryFn: fetchProducts
});
```

## Styling Conventions
- Tailwind for utilities
- CSS Modules for custom components
- NO inline styles
- Design tokens in `tailwind.config.js`

## Testing
```typescript
describe('Button', () => {
  it('renders with primary variant', () => {
    render(<Button variant="primary">Click</Button>);
    expect(screen.getByText('Click')).toHaveClass('btn-primary');
  });
  
  it('calls onClick when clicked', () => {
    const onClick = jest.fn();
    render(<Button onClick={onClick}>Click</Button>);
    fireEvent.click(screen.getByText('Click'));
    expect(onClick).toHaveBeenCalled();
  });
});
```
```

---

### Example 3: Python Data Pipeline

```markdown
# Data Processing Pipeline

## Tech Stack
- Python 3.11
- Pandas (data manipulation)
- DuckDB (local analytics)
- Apache Airflow (orchestration)
- Pytest (testing)

## Project Structure
```
src/
  ├── extractors/    # Data sources
  ├── transformers/  # Data transformation
  ├── loaders/       # Data destinations
  ├── utils/         # Helpers
  └── dags/          # Airflow DAGs
```

## Code Conventions
- Functions: `snake_case`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Type hints: Always (enforced by mypy)

## ETL Pattern
```python
def extract() -> pd.DataFrame:
    """Extract data from source."""
    return pd.read_csv('data.csv')

def transform(df: pd.DataFrame) -> pd.DataFrame:
    """Transform data."""
    return df.dropna().query('age > 18')

def load(df: pd.DataFrame) -> None:
    """Load data to destination."""
    df.to_parquet('output.parquet')

# Pipeline
df = extract()
df = transform(df)
load(df)
```

## Testing Pattern
```python
def test_transform_removes_nulls():
    # Arrange
    df = pd.DataFrame({'age': [25, None, 30]})
    
    # Act
    result = transform(df)
    
    # Assert
    assert len(result) == 2
    assert result['age'].isna().sum() == 0
```

## Type Hints (Mandatory)
```python
from typing import List, Dict, Optional

def process_users(
    users: List[Dict[str, str]],
    filter_active: bool = True
) -> List[str]:
    """Process user data.
    
    Args:
        users: List of user dictionaries
        filter_active: Whether to filter active users
        
    Returns:
        List of user IDs
    """
    return [u['id'] for u in users if not filter_active or u['active']]
```
```

---

### Example 4: Go Microservice

```markdown
# Payment Microservice

## Tech Stack
- Go 1.21
- gRPC (inter-service communication)
- PostgreSQL
- Redis (caching)

## Project Structure
```
cmd/
  └── server/        # Main application
internal/
  ├── domain/        # Business logic
  ├── infrastructure/# DB, Redis, external APIs
  └── interfaces/    # gRPC, HTTP handlers
pkg/                 # Public libraries
```

## Naming Conventions
- Files: `snake_case.go`
- Packages: `lowercase` (no underscores)
- Interfaces: `Type + er` (Reader, Writer)
- Structs: `PascalCase`
- Functions: `PascalCase` (exported), `camelCase` (unexported)

## Error Handling
```go
func (s *PaymentService) ProcessPayment(ctx context.Context, req *PaymentRequest) (*Payment, error) {
    // Validate
    if err := validate(req); err != nil {
        return nil, fmt.Errorf("validation failed: %w", err)
    }
    
    // Process
    payment, err := s.stripe.Charge(ctx, req)
    if err != nil {
        return nil, fmt.Errorf("stripe charge failed: %w", err)
    }
    
    return payment, nil
}
```

Always wrap errors with context using `fmt.Errorf` and `%w`.

## Testing Pattern
```go
func TestProcessPayment(t *testing.T) {
    // Arrange
    service := NewPaymentService(mockStripe)
    req := &PaymentRequest{Amount: 5000}
    
    // Act
    payment, err := service.ProcessPayment(context.Background(), req)
    
    // Assert
    assert.NoError(t, err)
    assert.Equal(t, 5000, payment.Amount)
}
```

## Concurrency
- Use channels for communication
- Use sync.WaitGroup for goroutine coordination
- Always have timeout context
- Avoid shared mutable state

```go
func processAsync(items []Item) []Result {
    results := make(chan Result, len(items))
    var wg sync.WaitGroup
    
    for _, item := range items {
        wg.Add(1)
        go func(i Item) {
            defer wg.Done()
            results <- process(i)
        }(item)
    }
    
    go func() {
        wg.Wait()
        close(results)
    }()
    
    return collectResults(results)
}
```
```

---

## CLAUDE.md Maintenance

### When to Update

#### ✅ Update When:
- New patterns introduced
- Architecture decisions made
- Anti-patterns identified
- Team practices change
- Tech stack updates
- Domain knowledge added

#### ❌ Don't Update For:
- Individual function implementations
- Temporary experiments
- Personal preferences
- One-off tasks

### Review Cycle

```bash
# Weekly
- Review recent PRs for new patterns
- Check if documented patterns still followed
- Update if conventions changed

# Monthly
- Full review with team
- Remove outdated sections
- Add new learnings
- Check examples still accurate

# Quarterly
- Major refactor if needed
- Reorganize for clarity
- Add advanced sections
# Update template level (minimal → intermediate → advanced)
```

### Keeping It Current

```markdown
## Changelog (at bottom of CLAUDE.md)

### 2025-12-19
- Added gRPC service pattern
- Updated error handling to use custom errors
- Removed deprecated PayPal integration docs

### 2025-12-01
- Added rate limiting to API pattern
- Updated database connection pooling config
- Added Redis caching strategy

### 2025-11-15
- Initial CLAUDE.md creation
```

---

## Tips & Best Practices

### ✅ Do's

1. **Start Simple, Grow Gradually**
   - Begin with Level 1 (5 min)
   - Add to Level 2 as patterns emerge (15 min)
   - Reach Level 3 after 3-6 months (30 min)

2. **Include Code Examples**
   - Every pattern should have code
   - Real examples from your codebase
   - Not pseudocode, actual working code

3. **Document Why, Not Just What**
   ```markdown
   # Bad
   Use async/await
   
   # Good
   Use async/await (not callbacks)
   Why: More readable, better error handling
   Example: [code]
   ```

4. **Keep It Updated**
   - Review monthly
   - Update when patterns change
   - Remove outdated sections

5. **Make It Searchable**
   - Good section headers
   - Consistent formatting
   - Table of contents (for long docs)

### ❌ Don'ts

1. **Don't Write a Novel**
   - Be concise
   - Focus on essentials
   - Link to external docs for details

2. **Don't Include Temporary Info**
   - No temporary decisions
   - No individual code snippets
   - No personal preferences

3. **Don't Let It Get Stale**
   - Outdated CLAUDE.md worse than none
   - Remove deprecated sections
   - Update examples to match current code

4. **Don't Document Everything**
   - Not every function
   - Not every file
   - Just patterns and principles

---

## Quick Reference

### Minimal Template (Copy-Paste)
```markdown
# [Project Name]

## What This Is
[One sentence]

## Tech Stack
- **Backend**: [Stack]
- **Database**: [DB]
- **Testing**: [Framework]

## Structure
```
src/
  ├── [folder]: [description]
  └── [folder]: [description]
```

## Key Rules
- [Rule 1]
- [Rule 2]
- [Rule 3]
```

### Essential Sections (Pick What Applies)
- ✅ **Always Include**: What This Is, Tech Stack, Key Rules
- ⭐ **Important**: Project Structure, Code Patterns
- 📚 **Helpful**: Architecture Decisions, Testing Standards
- 🔧 **Advanced**: Anti-Patterns, Debugging Guide, Team Practices

---

## Next Steps

- **See It In Action**: [Daily Workflows](03b-daily-workflows)
- **Learn Prompting**: [Prompt Engineering](../05-prompt-context-mastery/14-prompt-engineering)
- **Explore Examples**: Check `examples/configurations/` directory

---

[← Back: Environment Setup](02-environment-setup) | [Next: Core Workflows →](03-core-workflows)


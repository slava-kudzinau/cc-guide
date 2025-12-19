# Section 23: Anti-Patterns & Common Mistakes

Learn from others' mistakes! This guide shows you what **NOT** to do when working with Claude Code, and how to do it right instead.

---

## Prompting Anti-Patterns

### ❌ Anti-Pattern 1: Vague Requests

**The Mistake**:
```bash
claude "make it better"
claude "fix this"
claude "improve performance"
claude "refactor the code"
```

**Why It's Bad**:
- Claude has to guess what you want
- Results are inconsistent
- Often misses your actual intent
- Wastes time with back-and-forth

**Do This Instead**:
```bash
# Specific, measurable, actionable
claude "Refactor @src/auth.js for readability:
- Extract functions over 20 lines
- Add descriptive variable names (no single letters)
- Add JSDoc comments for public methods
- Follow error handling pattern from @CLAUDE.md"

claude "Fix null pointer exception on line 45 in @src/payment.js when user.address is undefined. Add null check and return proper error."

claude "Optimize database query in @src/services/user.js:getUserOrders. Currently 1800ms, target <200ms. Use JOIN instead of N+1 queries."
```

**Key Takeaway**: Be specific about what, why, and how.

---

### ❌ Anti-Pattern 2: No Context Provided

**The Mistake**:
```bash
claude "add authentication"
# Which file? What pattern? What tech?

claude "the tests are failing"
# Which tests? What error? What changed?

claude "create an API endpoint"
# For what? Following what pattern?
```

**Why It's Bad**:
- Claude invents patterns instead of following yours
- Inconsistent with your codebase
- Misses project-specific requirements
- Result doesn't match your architecture

**Do This Instead**:
```bash
# Include context files
claude "Add JWT authentication to @src/routes/api.js 
following pattern from @src/middleware/auth-example.js.

Use httpOnly cookies (not localStorage).
Token expiry: 24 hours.

@CLAUDE.md authentication section"

# Include error logs
npm test 2>&1 | claude "Tests failing:
[paste output]

Recent changes:
- Updated auth middleware (PR #234)

Files involved:
@src/middleware/auth.js
@tests/auth.test.js

Diagnose + fix"

# Include patterns
claude "Create REST API endpoint for products
following our pattern:

@src/routes/users.js (as template)
@CLAUDE.md API conventions

Include:
- Validation
- Error handling
- Tests"
```

**Key Takeaway**: Always include @CLAUDE.md and relevant files.

---

### ❌ Anti-Pattern 3: Everything At Once

**The Mistake**:
```bash
claude "Build complete e-commerce system with:
- User authentication
- Product catalog
- Shopping cart
- Payment processing
- Order management
- Inventory tracking
- Admin dashboard
- Email notifications
- Analytics
- Mobile responsiveness"
```

**Why It's Bad**:
- Overwhelming scope
- Hard to review
- Difficult to test
- Easy to introduce bugs
- Impossible to revert if something's wrong

**Do This Instead**:
```bash
# Break into phases
claude "Phase 1: User authentication

Step 1: Database schema for users
Generate migration following @migrations/pattern.sql"

# Wait, review, approve

claude "Step 2: User model
@src/models/User.js
Include: validation, password hashing"

# Continue incrementally

claude "Step 3: Auth endpoints
POST /register
POST /login
POST /logout"

# Then move to Phase 2 (products), etc.
```

**Key Takeaway**: Small, incremental steps. Commit often.

---

### ❌ Anti-Pattern 4: Ignoring Project Patterns

**The Mistake**:
```bash
claude "add a new feature"
# Claude invents its own pattern

# Claude generates:
function getUser(id, callback) {
  db.query('SELECT * FROM users', (err, result) => {
    callback(err, result);
  });
}

# But your project uses async/await!
```

**Why It's Bad**:
- Inconsistent codebase
- Harder to maintain
- Confuses team members
- Violates project standards

**Do This Instead**:
```bash
claude "Add getUser function following our patterns:

@CLAUDE.md (async/await, not callbacks)
@src/services/example-service.js (service pattern)

Must:
- Use async/await
- Use repository pattern
- Handle errors with AppError
- Include tests"
```

**Key Takeaway**: Always reference @CLAUDE.md patterns.

---

### ❌ Anti-Pattern 5: No Success Criteria

**The Mistake**:
```bash
claude "write tests"
# How many? What coverage? Which framework?

claude "optimize this"
# How much? What metric?

claude "make it secure"
# Against what threats?
```

**Why It's Bad**:
- Unclear when "done"
- Can't measure success
- May over/under-deliver
- Hard to verify correctness

**Do This Instead**:
```bash
claude "Generate tests for @src/services/payment.js:

Coverage requirements:
- Unit tests: All public methods
- Edge cases: null, undefined, empty, boundaries
- Error cases: Network timeout, DB failure
- Integration: Real DB (not mocks)
- Target: 90%+ coverage

Test framework: Jest
Pattern: @tests/example.test.js

Success criteria: All tests pass + 90% coverage"

claude "Optimize @src/api/search.js:

Current: 2000ms response time
Target: <200ms (p95)
Constraints: Can't change API response format

Measure: Time from request to response
Verify: Load test with 100 concurrent requests"

claude "Security review of @src/auth/:

Check for:
- SQL injection (parameterized queries?)
- XSS (output encoding?)
- CSRF (tokens?)
- Session fixation
- Secrets in code

Report: Severity + location + fix"
```

**Key Takeaway**: Define "done" clearly.

---

## Workflow Anti-Patterns

### ❌ Anti-Pattern 6: Accepting Code Blindly

**The Mistake**:
```bash
claude "implement user registration"
# Claude generates 200 lines
# You click Accept without reading
# Ship to production
# 🔥 Production breaks 🔥
```

**Why It's Bad**:
- Claude is smart but not perfect
- May misunderstand requirements
- Could have security issues
- Might break existing functionality
- You're responsible for the code

**Do This Instead**:
```bash
claude "implement user registration"

# Claude generates code

# YOU REVIEW:
# 1. Read the code line by line
# 2. Check for edge cases
# 3. Verify error handling
# 4. Look for security issues
# 5. Run tests
# 6. Manual testing

# Only THEN accept

# Better: Use Plan Mode
claude --plan-mode "implement user registration"
# Review plan BEFORE implementation
# Edit plan if needed
# THEN implement
```

**Key Takeaway**: Always review. You're the engineer, Claude is the assistant.

---

### ❌ Anti-Pattern 7: No CLAUDE.md

**The Mistake**:
```bash
# Project has NO CLAUDE.md

# Day 1
You: "Add API endpoint"
Claude: Creates pattern A

# Day 2
You: "Add another endpoint"
Claude: Creates pattern B (inconsistent!)

# Day 3
Teammate: "Add third endpoint"
Claude: Creates pattern C (more chaos!)

# Result: 3 different patterns, messy codebase
```

**Why It's Bad**:
- Claude reinvents patterns every session
- No consistency across team
- Wastes time re-explaining patterns
- Knowledge not preserved

**Do This Instead**:
```bash
# Create CLAUDE.md (5 minutes)
cat > CLAUDE.md << 'EOF'
# MyProject

## Tech Stack
- Node.js + Express
- PostgreSQL
- Jest

## API Endpoint Pattern
```javascript
router.post('/resource',
  validate(schema),
  authenticate(),
  async (req, res, next) => {
    try {
      const result = await service.create(req.body);
      res.json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }
);
```

## Testing Pattern
Follow @tests/example.test.js
Coverage target: 80%+
EOF

# Now Claude uses YOUR patterns consistently
```

**Key Takeaway**: Create CLAUDE.md on day 1. Update it as patterns evolve.

---

### ❌ Anti-Pattern 8: Overloading Context

**The Mistake**:
```bash
claude "Review this:
@src/  (entire directory, 50+ files, 10K+ lines)
@tests/  (50+ test files)
@docs/  (20+ doc files)
@config/  (10+ config files)

Fix any issues"
```

**Why It's Bad**:
- Slow responses (analyzing 100+ files)
- High token cost
- Claude gets overwhelmed
- Misses important details
- Hits context limits

**Do This Instead**:
```bash
# Target specific files
claude "Review authentication:
@src/auth/login.js
@src/middleware/auth.js
@tests/auth.test.js

Check for security issues"

# Or use focused queries
claude "Find all TODO comments in @src/auth/"

claude "Check error handling in @src/services/payment.js"

# Use grep for searching
grep -r "TODO" src/ | claude "Analyze these TODOs. Which are urgent?"
```

**Key Takeaway**: Less is more. Be targeted.

---

### ❌ Anti-Pattern 9: No Incremental Commits

**The Mistake**:
```bash
# Work for 8 hours
# Make 50 changes across 20 files
# One giant commit:
git commit -m "stuff"

# Problem: Can't revert part of changes
# Problem: Hard to review
# Problem: Loses history
```

**Why It's Bad**:
- Can't revert individual features
- Impossible to review properly
- Lost detailed history
- Hard to debug (which change broke it?)

**Do This Instead**:
```bash
# Commit after each logical step

# Step 1
claude "Add User model"
git add src/models/User.js
git commit -m "feat(models): add User model"

# Step 2
claude "Add user validation"
git add src/validators/user.js
git commit -m "feat(validation): add user validation"

# Step 3
claude "Add user service"
git add src/services/user-service.js
git commit -m "feat(services): add user service"

# Each step is reversible
# Each step is reviewable
# Clear history
```

**Key Takeaway**: Small commits, descriptive messages, often.

---

### ❌ Anti-Pattern 10: Ignoring Errors

**The Mistake**:
```bash
npm test
# ❌ 5 tests failing

# Ignore it, keep coding...

npm run lint
# ⚠️ 20 linting errors

# Ignore it...

git commit
# Ship it! 🚢

# Production: 🔥
```

**Why It's Bad**:
- Broken tests = broken functionality
- Lint errors = code quality issues
- Small problems become big problems
- Technical debt accumulates

**Do This Instead**:
```bash
# Fix immediately
npm test
# ❌ 5 tests failing

npm test 2>&1 | claude "Tests failing. Diagnose + fix:
@src/implementation
@tests/failing-tests

What changed that broke them?"

# Fix before moving on

npm run lint
# ⚠️ Warnings

npm run lint 2>&1 | claude "Fix these lint issues"

# Clean code before commit

# Pre-commit checklist
# - [ ] All tests pass
# - [ ] No lint errors
# - [ ] No console.logs
# - [ ] Code reviewed
```

**Key Takeaway**: Red = Stop. Fix before proceeding.

---

## Security Anti-Patterns

### ❌ Anti-Pattern 11: Storing Secrets in Code

**The Mistake**:
```javascript
// ❌ BAD
const API_KEY = 'sk_live_abc123xyz';
const DB_PASSWORD = 'superSecret123';
const JWT_SECRET = 'mySecretKey';

// Commit to git
// Now secrets are in git history FOREVER
```

**Why It's Bad**:
- Exposed in git history
- Visible to anyone with repo access
- Can't rotate without code change
- Security audit nightmare

**Do This Instead**:
```javascript
// ✅ GOOD
const API_KEY = process.env.STRIPE_API_KEY;
const DB_PASSWORD = process.env.DATABASE_PASSWORD;
const JWT_SECRET = process.env.JWT_SECRET;

// .env (NOT committed)
STRIPE_API_KEY=sk_live_abc123xyz
DATABASE_PASSWORD=superSecret123
JWT_SECRET=mySecretKey

// .env.example (committed - no real values)
STRIPE_API_KEY=sk_live_your_key_here
DATABASE_PASSWORD=your_password
JWT_SECRET=your_jwt_secret

// .gitignore
.env
```

**Key Takeaway**: Never commit secrets. Use environment variables.

---

### ❌ Anti-Pattern 12: No Input Validation

**The Mistake**:
```javascript
// ❌ BAD
router.post('/users', async (req, res) => {
  // No validation!
  const user = await db.query(
    `INSERT INTO users (name, email) VALUES ('${req.body.name}', '${req.body.email}')`
  );
  res.json(user);
});

// User sends: { name: "'; DROP TABLE users;--", email: "..." }
// SQL injection! 💀
```

**Why It's Bad**:
- SQL injection
- XSS attacks
- Invalid data in database
- Application crashes

**Do This Instead**:
```javascript
// ✅ GOOD
const userSchema = Joi.object({
  name: Joi.string().min(2).max(50).required(),
  email: Joi.string().email().required()
});

router.post('/users',
  validate(userSchema),  // Validate FIRST
  async (req, res, next) => {
    try {
      // Parameterized query (prevents SQL injection)
      const user = await db.query(
        'INSERT INTO users (name, email) VALUES (?, ?)',
        [req.body.name, req.body.email]
      );
      res.json({ success: true, data: user });
    } catch (error) {
      next(error);
    }
  }
);
```

**Key Takeaway**: Validate all input. Use parameterized queries.

---

## Performance Anti-Patterns

### ❌ Anti-Pattern 13: N+1 Query Problem

**The Mistake**:
```javascript
// ❌ BAD
async function getUsersWithOrders() {
  const users = await db.query('SELECT * FROM users');
  
  for (const user of users) {
    // 1 query per user! 💀
    user.orders = await db.query(
      'SELECT * FROM orders WHERE user_id = ?',
      [user.id]
    );
  }
  
  return users;
}

// 100 users = 101 queries (1 + 100)
// Response time: 2000ms 🐌
```

**Why It's Bad**:
- Slow (1 query per item)
- Scales terribly
- Wastes database resources
- Poor user experience

**Do This Instead**:
```javascript
// ✅ GOOD - Use JOIN
async function getUsersWithOrders() {
  const result = await db.query(`
    SELECT 
      users.*,
      orders.id as order_id,
      orders.total as order_total,
      orders.created_at as order_date
    FROM users
    LEFT JOIN orders ON users.id = orders.user_id
  `);
  
  // Group orders by user
  const users = groupOrdersByUser(result);
  return users;
}

// 1 query total
// Response time: 50ms ⚡
```

**Key Takeaway**: Use JOINs or batch queries, not loops.

---

### ❌ Anti-Pattern 14: No Caching

**The Mistake**:
```javascript
// ❌ BAD
router.get('/products/:category', async (req, res) => {
  // Query database every single request
  const products = await db.query(
    'SELECT * FROM products WHERE category = ?',
    [req.params.category]
  );
  res.json(products);
});

// 1000 requests/second = 1000 DB queries/second
// Database melts 🔥
```

**Why It's Bad**:
- Database overload
- Slow responses
- High costs
- Doesn't scale

**Do This Instead**:
```javascript
// ✅ GOOD - Add caching
const cache = new Redis();

router.get('/products/:category', async (req, res) => {
  const cacheKey = `products:${req.params.category}`;
  
  // Check cache first
  let products = await cache.get(cacheKey);
  
  if (!products) {
    // Cache miss - query database
    products = await db.query(
      'SELECT * FROM products WHERE category = ?',
      [req.params.category]
    );
    
    // Cache for 5 minutes
    await cache.set(cacheKey, JSON.stringify(products), 'EX', 300);
  } else {
    products = JSON.parse(products);
  }
  
  res.json(products);
});

// 1000 requests = maybe 1-2 DB queries (rest from cache)
// Fast! ⚡
```

**Key Takeaway**: Cache frequently accessed data.

---

## Testing Anti-Patterns

### ❌ Anti-Pattern 15: No Tests

**The Mistake**:
```javascript
// Implement feature
function calculateDiscount(price, coupon) {
  return price * coupon.percent / 100;
}

// Ship it!
// No tests...

// Production: Crashes when coupon is null 💀
```

**Why It's Bad**:
- No confidence in changes
- Bugs reach production
- Refactoring is scary
- Technical debt grows

**Do This Instead**:
```javascript
// Write tests FIRST (TDD)
describe('calculateDiscount', () => {
  it('calculates 10% discount', () => {
    const price = 100;
    const coupon = { percent: 10 };
    expect(calculateDiscount(price, coupon)).toBe(10);
  });
  
  it('handles null coupon', () => {
    const price = 100;
    expect(calculateDiscount(price, null)).toBe(0);
  });
  
  it('handles 0% discount', () => {
    const price = 100;
    const coupon = { percent: 0 };
    expect(calculateDiscount(price, coupon)).toBe(0);
  });
});

// THEN implement
function calculateDiscount(price, coupon) {
  if (!coupon || !coupon.percent) return 0;
  return price * coupon.percent / 100;
}

// All tests pass ✅
// Confident to ship
```

**Key Takeaway**: Write tests. Ideally before implementation (TDD).

---

### ❌ Anti-Pattern 16: Testing Implementation, Not Behavior

**The Mistake**:
```javascript
// ❌ BAD - Testing implementation details
describe('UserService', () => {
  it('calls repository.create with correct params', async () => {
    const spy = jest.spyOn(repository, 'create');
    
    await userService.create({ name: 'John' });
    
    // Testing HOW it works (implementation)
    expect(spy).toHaveBeenCalledWith({ name: 'John' });
  });
});

// You refactor to use different method
// Tests break even though behavior is same 💥
```

**Why It's Bad**:
- Tests break on refactoring
- Doesn't test user-facing behavior
- False confidence
- Maintenance nightmare

**Do This Instead**:
```javascript
// ✅ GOOD - Test behavior
describe('UserService', () => {
  it('creates user with valid data', async () => {
    const userData = { name: 'John', email: 'john@example.com' };
    
    const user = await userService.create(userData);
    
    // Test WHAT it does (behavior)
    expect(user).toBeDefined();
    expect(user.name).toBe('John');
    expect(user.email).toBe('john@example.com');
    
    // Verify it's in database
    const saved = await userRepository.findById(user.id);
    expect(saved).toBeDefined();
  });
});

// Refactor however you want
// Test still passes as long as behavior is same ✅
```

**Key Takeaway**: Test public behavior, not internal implementation.

---

## Quick Reference: Anti-Patterns Checklist

### Before Prompting
- [ ] Is my request specific? (not "make it better")
- [ ] Did I include context? (@CLAUDE.md, relevant files)
- [ ] Is the scope reasonable? (not "build entire app")
- [ ] Did I reference project patterns?
- [ ] Did I define success criteria?

### During Development
- [ ] Am I reviewing Claude's code?
- [ ] Am I committing incrementally?
- [ ] Are tests passing?
- [ ] Are there lint errors?
- [ ] Is CLAUDE.md up to date?

### Before Committing
- [ ] All tests pass?
- [ ] No secrets in code?
- [ ] Input validation added?
- [ ] No N+1 queries?
- [ ] Tests written?
- [ ] Code reviewed?

---

## Common Mistakes Summary

| Anti-Pattern | Impact | Fix |
|--------------|--------|-----|
| Vague prompts | Inconsistent results | Be specific: what, why, how |
| No context | Wrong patterns | Always include @CLAUDE.md |
| Everything at once | Overwhelming, buggy | Small incremental steps |
| No patterns | Inconsistent code | Reference @CLAUDE.md patterns |
| No success criteria | Unclear "done" | Define measurable goals |
| Accept blindly | Bugs in production | Review all code |
| No CLAUDE.md | Reinvent every time | Create CLAUDE.md day 1 |
| Overload context | Slow, expensive | Target specific files |
| Giant commits | Can't revert | Commit after each step |
| Ignore errors | Technical debt | Fix immediately |
| Secrets in code | Security breach | Use env vars |
| No validation | SQL injection, XSS | Validate all input |
| N+1 queries | Slow performance | Use JOINs |
| No caching | Database overload | Cache frequent data |
| No tests | Bugs in production | TDD: test first |
| Test implementation | Brittle tests | Test behavior |

---

## Next Steps

- **Learn Good Patterns**: [Prompt Engineering](../05-prompt-context-mastery/14-prompt-engineering)
- **Set Up Properly**: [CLAUDE.md Guide](../01-fundamentals-core-concepts/02b-claude-md-guide)
- **See Real Workflows**: [Daily Workflows](../01-fundamentals-core-concepts/03b-daily-workflows)

---

[← Back: Best Practices](22-best-practices) | [Next: Future Roadmap →](24-future-roadmap)


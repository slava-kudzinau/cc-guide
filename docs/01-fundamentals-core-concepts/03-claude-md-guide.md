---
title: "Section 3: CLAUDE.md - Your Project's Memory"
parent: "Part 1: Fundamentals & Core Concepts"
nav_order: 3
---

# Section 3: CLAUDE.md - Your Project's Memory

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

---

### Level 2: Production (15 minutes) ⭐⭐⭐

**When**: Production projects, team collaboration

Add to Level 1:

#### Architectural Decisions

Document **why** you made key decisions:

```markdown
### Authentication
We use JWT tokens stored in httpOnly cookies (NOT localStorage).

**Why**: Prevents XSS attacks
**Implementation**: `src/middleware/auth.js`
**Token expiry**: 24 hours
**Refresh strategy**: Sliding window
```

#### Code Patterns

Show concrete examples of your patterns:

```javascript
// API Endpoint Pattern
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

#### Testing Standards

```javascript
describe('UserService', () => {
  describe('create', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const userData = { name: 'John', email: 'john@example.com' };
      
      // Act
      const user = await userService.create(userData);
      
      // Assert
      expect(user).toBeDefined();
      expect(user.email).toBe('john@example.com');
    });
  });
});
```

#### Common Tasks

```bash
# Adding a Feature
1. Check for similar features: grep -r "similar_feature" src/
2. Create feature branch: git checkout -b feature/your-feature
3. Write tests first (TDD)
4. Implement following patterns above
5. Update this doc if new patterns introduced

# Database Migration
npm run migration:create add_user_roles
# Edit migration file, then:
npm run migration:run
```

**When to use**:
- ✅ Production applications
- ✅ Teams of 3-10 people
- ✅ Projects with established patterns

---

### Level 3: Enterprise (30+ minutes) ⭐⭐⭐⭐⭐

**When**: Large teams (10+ people), complex systems, critical applications

Add to Level 2:

- **Domain-Specific Context** - Payment processing rules, email system patterns, file upload workflows
- **Anti-Patterns** - Common mistakes to avoid with examples
- **Debugging Guide** - Common issues and fixes
- **Security Checklist** - Pre-deployment security requirements
- **Performance Guidelines** - Response time targets, optimization strategies
- **Team Practices** - PR requirements, code review checklist, deployment procedures

> **Note**: For detailed Level 3 examples and full tech stack templates (Express, React, Python, Go), see the [examples folder](examples/).

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
   - Review monthly with team
   - Update when patterns change
   - Remove outdated sections

### ❌ Don'ts

1. **Don't Write a Novel** - Be concise, focus on essentials, link to external docs for details
2. **Don't Include Temporary Info** - No temporary decisions, experiments, or personal preferences
3. **Don't Let It Get Stale** - Outdated CLAUDE.md worse than none
4. **Don't Document Everything** - Just patterns and principles, not every function

---

## Maintenance

**When to update CLAUDE.md:**
- ✅ New patterns introduced, architecture decisions made, anti-patterns identified
- ❌ Individual function implementations, temporary experiments, one-off tasks

**Review cycle:**
- **Weekly**: Check if recent PRs introduced new patterns
- **Monthly**: Full review with team, remove outdated sections
- **Quarterly**: Major refactor if needed

**Pro tip**: Add a changelog at the bottom to track evolution.

---

## Quick Reference Templates

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

### Essential Sections Priority
- ✅ **Always Include**: What This Is, Tech Stack, Key Rules
- ⭐ **Important**: Project Structure, Code Patterns
- 📚 **Helpful**: Architecture Decisions, Testing Standards
- 🔧 **Advanced**: Anti-Patterns, Debugging Guide, Team Practices

---

## Real-World Examples

Full CLAUDE.md templates for popular tech stacks:
- [Express.js REST API](examples/claude-md-express-api.md)
- [React Frontend](examples/claude-md-react-frontend.md)
- [Python Data Pipeline](examples/claude-md-python-pipeline.md)
- [Go Microservice](examples/claude-md-go-microservice.md)

---

## Next Steps

- **See It In Action**: [Daily Workflows](05-daily-workflows.md)
- **Learn Core Workflows**: [Core Workflows](04-core-workflows.md)
- **Master Prompting**: [Part 5: Prompt & Context Mastery](../../docs/05-prompt-context-mastery)

---

[← Back: Environment Setup](02-environment-setup.md) | [Next: Core Workflows →](04-core-workflows.md)

---
title: "Feature Development Prompt Template"
nav_exclude: true
---

# Feature Development Prompt Template

## Template

```
I need to implement: [FEATURE_NAME]

**Context:** @CLAUDE.md @relevant-files

**Requirements:**
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

**Constraints:**
- Must follow existing patterns in @src/
- Must maintain backward compatibility
- Must include tests
- Must update documentation

**Questions before proceeding:**
What questions do you have about:
- Requirements clarity?
- Edge cases?
- Architectural implications?
- Integration points?

Please analyze the codebase first, then ask clarifying questions.
```

## Example Usage

```bash
claude "
I need to implement: User role-based access control

**Context:** @CLAUDE.md @src/models/User.js @src/middleware/auth.js

**Requirements:**
1. Add 'role' field to User model (admin, editor, viewer)
2. Create middleware to check user roles
3. Protect admin-only routes
4. Update existing tests

**Constraints:**
- Must follow existing auth patterns in @src/middleware/
- Must maintain backward compatibility
- Must include unit and integration tests
- Must update API documentation

**Questions before proceeding:**
What questions do you have about:
- Requirements clarity?
- Edge cases (existing users without roles)?
- Architectural implications?
- Integration points?

Please analyze the codebase first, then ask clarifying questions.
"
```

## Expected Output

Claude will:
1. Analyze existing codebase patterns
2. Ask clarifying questions about edge cases
3. Propose architectural approach
4. Implement the feature incrementally
5. Generate comprehensive tests
6. Update documentation




---
title: "Section 10: Skills System & Knowledge Extension"
parent: "Part 3: Advanced API & Agent Development"
nav_order: 3
---

# Section 10: Skills System & Knowledge Extension

## Skills Architecture

Skills provide just-in-time specialized knowledge without bloating the context window.

### Progressive Disclosure Model

```mermaid
graph TD
    Trigger[User mentions skill] --> Load[Load SKILL.md]
    Load --> Execute[Execute instructions]
    Execute --> Need{Need resources?}
    Need -->|Yes| LoadRes[Load scripts/refs/assets]
    Need -->|No| Complete[Complete task]
    LoadRes --> Complete
```

## Creating Custom Skills

### Basic Skill Structure
```
my-skill/
├── SKILL.md          # Core instructions (required)
├── scripts/          # Executable code (optional)
├── references/       # Documentation (optional)
└── assets/           # Templates (optional)
```

### Example: API Testing Skill

````markdown
---
name: api-testing
description: Generate comprehensive API tests
allowed-tools: Read, Write, Bash
model: sonnet
---

# API Testing Skill

Generate production-ready API tests with:

## Test Coverage
- Happy path scenarios
- Error handling (4xx, 5xx)
- Edge cases
- Authentication/authorization
- Rate limiting
- Input validation

## Example Test Template

```javascript
describe('POST /api/users', () => {
  it('should create user with valid data', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test' })
      .expect(201);
    
    expect(response.body).toHaveProperty('id');
  });

  it('should return 400 with invalid email', async () => {
    await request(app)
      .post('/api/users')
      .send({ email: 'invalid', name: 'Test' })
      .expect(400);
  });
});
```
````

### Installation
```bash
# Package skill
zip -r api-testing.zip my-skill/

# Install
claude /skills install api-testing.zip

# Use
claude "Use api-testing skill to generate tests for @src/routes/users.js"
```

## Skills Composition

### Combining Multiple Skills
```bash
# Use multiple skills in sequence
claude "
1. Use api-testing skill to generate tests
2. Use security-review skill to check for vulnerabilities
3. Use documentation-generator skill to create API docs
For @src/routes/payments.js"
```

## Domain-Specific Skills

### Frontend Skill Example
```markdown
---
name: react-component
description: Generate React components with TypeScript and tests
---

# React Component Generator

Creates production-ready components with:
- TypeScript types
- Props validation
- Hooks for state management
- Styled components / Tailwind CSS
- Unit tests (Jest + Testing Library)
- Storybook stories
- Accessibility (ARIA labels)
```

### Backend Skill Example
```markdown
---
name: express-api
description: Generate Express API endpoints
---

# Express API Generator

Creates endpoints with:
- Input validation (Zod)
- Error handling middleware
- OpenAPI documentation
- Service layer separation
- Database operations (with transactions)
- Integration tests
```

## Context7 as a Dynamic Skill Alternative

While traditional skills provide static, pre-defined knowledge, **Context7** offers dynamic, always-current library documentation.

### Skills vs Context7: When to Use Each

| Aspect | Traditional Skills | Context7 |
|--------|-------------------|----------|
| **Knowledge type** | Custom patterns, conventions | Library/framework docs |
| **Update frequency** | Manual (you update) | Automatic (real-time) |
| **Use case** | Company-specific patterns | Public library knowledge |
| **Best for** | Internal conventions | Latest framework features |
| **Example** | "Use our auth pattern" | "Latest Next.js patterns" |

### Using Context7 Instead of Skills

**Before: Creating a Static Skill**
```bash
# Create skill for Next.js patterns (quickly outdated)
cat > nextjs-skill/SKILL.md << 'EOF'
# Next.js Patterns
Use these Next.js patterns:
- getServerSideProps for SSR
- getStaticProps for SSG
# ...but these may be outdated in months
EOF
```

**After: Use Context7 (Always Current)**
```bash
# No skill needed - query Context7 directly
claude "Context7: Next.js 15 server components data fetching patterns"

# Context7 provides current, version-specific guidance
# No maintenance needed - always up-to-date
```

### Hybrid Approach: Skills + Context7

Combine both for maximum power:

```bash
# Use skill for company conventions
claude "Use @auth-skill to understand our auth flow

# Use Context7 for latest library patterns
Context7: Show me Prisma 5 client extensions

# Implement using both
Now implement OAuth using our patterns with latest Prisma features"
```

### When to Use Context7 Over Skills

**✅ Use Context7 when:**
- Working with public libraries/frameworks
- Framework has version-specific differences (Next.js 13 vs 15)
- Library updates frequently (React, Vue, AWS SDK)
- Need latest best practices
- Checking for deprecations

**❌ Don't use Context7, create a Skill instead when:**
- Company-specific patterns and conventions
- Internal APIs and services
- Custom tooling and workflows
- Team coding standards
- Proprietary logic

### Examples: Context7 as Knowledge Source

**Frontend Development**
```bash
# Instead of creating React/Vue/Svelte skills
claude "Context7: React 19 use() hook for data fetching"
claude "Context7: Vue 3.4 composition API patterns"
claude "Context7: Svelte 5 runes state management"
```

**Backend Development**
```bash
# Instead of framework-specific skills
claude "Context7: NestJS 10 microservices setup"
claude "Context7: Fastify v4 async hooks"
claude "Context7: Express 5 router syntax changes"
```

**Database & ORM**
```bash
# Instead of ORM skills
claude "Context7: Prisma 5 multi-schema support"
claude "Context7: TypeORM 0.3 DataSource API"
claude "Context7: Drizzle ORM migration syntax"
```

**Cloud Platforms**
```bash
# Instead of cloud provider skills
claude "Context7: AWS CDK v3 Lambda L2 constructs"
claude "Context7: Terraform 1.7 import blocks"
claude "Context7: Pulumi ESC environment variables"
```

### Building Skills That Leverage Context7

Create skills that **use** Context7 for up-to-date info:

````markdown
---
name: modern-react-component
description: Generate React components using latest patterns
---

# Modern React Component Generator

## Instructions

1. Query Context7 for latest React patterns:
   - "Context7: React [current-version] component patterns"
   - "Context7: React [current-version] hooks best practices"

2. Generate component with:
   - Latest hook patterns from Context7
   - Our company TypeScript conventions
   - Our testing standards

3. Include Context7-verified patterns for:
   - State management
   - Effect handling
   - Performance optimization
````

### Context7 Usage in Skills

Reference Context7 in skill documentation:

```markdown
# Backend API Skill

## Before generating code:

1. Check latest patterns:
   ```
   Context7: [framework] [version] - verify current best practices
   ```

2. Apply our conventions:
   - Use our error handling middleware
   - Follow our naming conventions
   - Apply our security standards

3. Generate code using:
   - Latest library patterns (Context7)
   - Company standards (from skill)
```

### Team Skills Repository

### Shared Skills Setup
```bash
# Create team skills repo
mkdir company-skills
cd company-skills

# Add skills
mkdir -p skills/company-standards
mkdir -p skills/security-checklist
mkdir -p skills/deployment-guide

# Version control
git init
git add .
git commit -m "Initial skills"
git remote add origin git@github.com:company/claude-skills.git
git push

# Team members install
claude /plugin marketplace add git@github.com:company/claude-skills.git
```

---

## Context7: Dynamic Alternative to Static Skills

While skills provide static, packaged knowledge, **Context7** offers dynamic, always-up-to-date documentation access. Understanding when to use each is important.

### Skills vs Context7: Comparison

| Aspect | Static Skills | Context7 |
|--------|--------------|----------|
| **Update frequency** | Manual (when you update skill) | Automatic (real-time docs) |
| **Content** | Custom patterns, internal tools | Public library documentation |
| **Use case** | Company-specific patterns | Framework/library knowledge |
| **Setup** | Create + package + distribute | Just mention in prompt |
| **Version control** | Git repository | N/A (always latest) |
| **Offline** | Works offline | Requires API access |
| **Customization** | Full control | Uses official docs |
| **Maintenance** | You maintain | Anthropic maintains |

### When to Use Skills

✅ **Create custom skills for:**
- **Company-specific patterns**: "Use our API design skill"
- **Internal tools**: "Use deployment-to-staging skill"
- **Proprietary processes**: "Use security-review-checklist skill"
- **Team conventions**: "Use code-style-guide skill"
- **Complex multi-step workflows**: "Use feature-release skill"

**Example: Internal API Skill**
```bash
# Your company's specific API patterns
claude "Use company-api-patterns skill to create new user endpoint"

# Skill includes:
# - Your error handling conventions
# - Your authentication patterns
# - Your database transaction patterns
# - Your logging standards
```

### When to Use Context7

✅ **Use Context7 for:**
- **Public framework documentation**: "Context7: Next.js 15 patterns"
- **Library APIs**: "Context7: Prisma 5 advanced queries"
- **Recently updated docs**: "Context7: React 19 new hooks"
- **Version-specific guidance**: "Context7: AWS CDK v3 constructs"
- **Official best practices**: "Context7: TypeScript 5.4 features"

**Example: Framework Knowledge**
```bash
# Get latest Next.js patterns
claude "Context7: Next.js 15 server actions authentication"

# Context7 fetches:
# - Official Next.js docs
# - Current best practices
# - Version-specific examples
# - Latest API changes
```

### Hybrid Approach: Skills + Context7

Combine both for maximum effectiveness:

```bash
# Use Context7 for framework knowledge + custom skill for company patterns

claude "Using Context7 Next.js 15 patterns and our @company-api-patterns skill, 
create user authentication endpoint in src/app/api/auth/"
```

**Example workflow:**
1. **Context7** provides latest Next.js 15 server actions patterns
2. **Company skill** provides your specific:
   - Error handling conventions
   - Database connection patterns
   - Logging requirements
   - Security checks

### Creating Skills That Reference Context7

You can create skills that explicitly use Context7 for staying current:

````markdown
---
name: modern-react-components
description: Create React components using latest patterns
---

# Modern React Component Skill

When creating React components:

1. Query Context7 for latest React version patterns
2. Apply company styling conventions
3. Include TypeScript types
4. Add Storybook stories

## Template

```typescript
// Query Context7 for latest React hooks
// Use company @styles/theme
// Follow @company-typescript-patterns

export const ComponentName: React.FC<Props> = ({ ...props }) => {
  // Implementation using latest React patterns from Context7
};
```
````

**Usage:**
```bash
claude "Use modern-react-components skill to create UserProfile component"

# Skill will:
# 1. Query Context7 for React 19 patterns
# 2. Apply your company styles
# 3. Generate TypeScript types
# 4. Create Storybook file
```

### Best Practices: Combining Skills and Context7

#### Pattern 1: Context7 for Foundation, Skills for Customization

```bash
# Context7 provides framework baseline
# Skill provides your customizations

claude "Context7: Next.js 15 app router setup
Then apply @company-nextjs-config skill for our environment variables, 
monitoring, and error tracking setup"
```

#### Pattern 2: Skills Reference Context7

**Create adaptive skills** that query Context7:

```markdown
# In your skill SKILL.md

When creating new features:
1. Query Context7 for latest [framework] patterns
2. Apply patterns from this skill
3. Follow company conventions in references/conventions.md
```

#### Pattern 3: Regular Skill Updates from Context7

Keep your skills current by periodically updating them with Context7 knowledge:

```bash
# Monthly: Update skills with latest patterns
claude "Context7: Get latest Next.js 15 best practices for:
- Data fetching
- Authentication
- Error handling

Update our @company-nextjs skill with these patterns"
```

### Decision Matrix

**Choose Static Skills when:**
- ✅ Codifying company-specific knowledge
- ✅ Complex multi-step workflows
- ✅ Need offline access
- ✅ Internal tools and processes
- ✅ Custom patterns not in public docs

**Choose Context7 when:**
- ✅ Need latest public documentation
- ✅ Working with recently updated frameworks
- ✅ Version-specific library knowledge
- ✅ Official best practices
- ✅ Quick access without setup

**Use Both Together when:**
- ✅ Building with modern frameworks + company patterns
- ✅ Need latest knowledge + internal conventions
- ✅ Creating adaptive, future-proof skills
- ✅ Onboarding to both public libs and internal tools

### Example: Real-World Hybrid Usage

**Scenario**: Building new Next.js 15 feature with company standards

```bash
# Step 1: Get latest framework patterns (Context7)
claude "Context7: Next.js 15 app router server actions best practices"

# Step 2: Apply company patterns (Skills)
claude "Using Context7 Next.js 15 patterns and @company-standards skill:
1. Create user registration endpoint
2. Follow our error handling conventions
3. Use our logging standards
4. Add our monitoring hooks"

# Result:
# - Modern Next.js 15 code (via Context7)
# - Your company's patterns (via skill)
# - Best of both worlds
```

### Summary

**Static Skills** = Your custom knowledge (internal, static, controlled)  
**Context7** = Public documentation (external, dynamic, always current)  
**Together** = Powerful combination of latest frameworks + your patterns

**Rule of thumb:**
- If it's on npm/public → use Context7
- If it's internal/proprietary → create a skill
- For best results → combine both

---

[← Back: Agent SDK](09-agent-sdk) | [Part 3 Complete! → Part 4](../../docs/04-enterprise-devops-patterns)




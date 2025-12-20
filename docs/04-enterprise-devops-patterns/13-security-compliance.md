---
title: "Section 13: Security & Compliance"
parent: "Part 4: Enterprise & DevOps Integration"
nav_order: 3
---

# Section 13: Security & Compliance

## Security Vulnerability Detection

### Automated Security Scan
```bash
# Comprehensive security review
claude "Security audit of @src/:

**Check for:**
- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- Authentication bypass
- Authorization flaws
- Insecure deserialization
- Hardcoded secrets/credentials
- Insecure cryptography
- Path traversal
- Command injection
- CSRF vulnerabilities

For each issue:
- File and line number
- Severity (Critical/High/Medium/Low)
- Exploit scenario
- Recommended fix with code example"
```

### Secrets Detection
```bash
# Find hardcoded secrets
claude "Scan @src/ @config/ for:
- API keys
- Passwords
- JWT secrets
- Database credentials
- AWS access keys
- Private keys

Suggest: environment variable migration"
```

## Compliance Checking

### PCI DSS Compliance
```bash
claude "Review payment processing code @src/payment/ for PCI DSS:
- Cardholder data handling
- Encryption at rest and in transit
- Access control
- Audit logging
- Secure authentication
- Network segmentation

Generate compliance checklist"
```

### HIPAA Compliance (Healthcare)
```bash
claude "HIPAA compliance review of @src/patient/:
- PHI data encryption
- Access logging (who accessed what)
- Data retention policies
- Audit trail completeness
- Authentication strength
- Authorization granularity

Flag non-compliant code"
```

### GDPR Compliance
```bash
claude "GDPR compliance check:
- Right to be forgotten (data deletion)
- Data portability
- Consent management
- Data minimization
- Audit logging
- Breach notification readiness

Review @src/user/ @src/gdpr/"
```

## Secrets Management

### Environment Variable Migration
```bash
# Convert hardcoded to env vars
claude "Refactor @config/database.js:
- Extract all hardcoded credentials
- Use environment variables
- Provide .env.example template
- Update documentation
- Validate env vars at startup"
```

### Secrets Rotation Plan
```bash
claude "Generate secrets rotation plan:
Services using secrets: @src/services/
Current secrets: database, redis, API keys, JWT

Plan should include:
- Rotation frequency
- Zero-downtime rotation process
- Rollback procedure
- Audit requirements
- Automation steps"
```

## Audit Logging

### Comprehensive Audit Trail
```bash
claude "Implement audit logging for @src/admin/:
Log: who, what, when, where, why
Events: create, read, update, delete
Include: user ID, IP, timestamp, resource, changes
Storage: append-only audit table
Retention: 7 years (compliance)

Generate: AuditLogger service + database schema"
```

[← Back: Architecture Design](12-architecture-design) | [Part 4 Complete! → Part 5](../../docs/05-prompt-context-mastery)




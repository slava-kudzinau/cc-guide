---
title: "Section 03: Security & Compliance"
parent: "Part 4: Enterprise & DevOps Integration"
nav_order: 3
---

# Section 03: Security & Compliance

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

AI-specific security review: [PR Review Guide – Security](../07-reference-troubleshooting/05-pr-review-guide#1-security-vulnerabilities).

## Secrets Management

### Detection & Migration
```bash
# Find and fix hardcoded secrets
claude "Scan @src/ @config/ for hardcoded:
- API keys, passwords, JWT secrets
- Database credentials
- AWS access keys, private keys

For each finding:
1. Extract to environment variables
2. Update code to use process.env
3. Generate .env.example template
4. Add validation at startup"
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

## Compliance Checking

### Universal Compliance Template
```bash
# Adaptable for PCI DSS, HIPAA, GDPR, SOC2
claude "Compliance review of @src/[module]:

**Framework:** [PCI DSS / HIPAA / GDPR / SOC2]

**Check for:**
- Data encryption (at rest & in transit)
- Access control & authentication
- Audit logging (who, what, when, where)
- Data retention & deletion policies
- Consent management (GDPR)
- Sensitive data handling ([specify: PHI/PII/cardholder])
- Incident response readiness

**Output:**
- Compliance gaps with severity
- Remediation steps with code examples
- Documentation requirements
- Checklist for certification"
```

### Example: PCI DSS for Payment Processing
```bash
claude "Review payment processing code @src/payment/ for PCI DSS:
- Cardholder data handling
- Encryption at rest and in transit
- Access control
- Audit logging
- Network segmentation

Generate compliance checklist"
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

[← Back: Architecture Design](02-architecture-design.md) | [Part 4 Complete! → Part 5](../05-prompt-context-mastery/)


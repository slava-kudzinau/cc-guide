---
title: "Section 05: PR Review Guide for AI-Generated Code"
parent: "Part 7: Reference, Troubleshooting & Future"
nav_order: 5
---

# PR Review Guide for AI-Generated Code

## Why AI Code Review is Different

Traditional code review focuses on formatting, naming conventions, and style consistency. AI-generated code typically "looks clean" but hides logic bugs that require different review priorities.

**Key statistics:**
- Over 40% of AI-generated code solutions contain security flaws (academic studies, 2024-2025)
- Missing input validation is the #1 flaw in LLM-generated code
- AI code introduces both familiar vulnerabilities (injection, auth bypass) and novel risks (hallucinated dependencies, architectural drift)

AI models are trained on open-source code—both good and bad. They inherit not just best practices but also insecure patterns that were prevalent in training data.

Many review issues stem from [Anti-Patterns](04-antipatterns).

---

## 1. Security Vulnerabilities

**Missing input validation is the most common flaw.** AI often omits validation unless explicitly prompted.

### SQL Injection
```python
# BAD: AI often generates string interpolation
query = f"SELECT * FROM users WHERE id = {user_id}"

# GOOD: Parameterized queries
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
```

### Missing Authentication/Authorization
AI-generated endpoints frequently bypass auth entirely when prompts don't explicitly require it:
```python
# BAD: No auth check - common in AI output
@app.route('/admin/users')
def list_users():
    return db.get_all_users()

# GOOD: Explicit authorization
@app.route('/admin/users')
@require_role('admin')
def list_users():
    return db.get_all_users()
```

### Hardcoded Secrets
```javascript
// BAD: AI may hardcode credentials from training data patterns
const API_KEY = "sk-1234567890abcdef";

// GOOD: Environment variables
const API_KEY = process.env.API_KEY;
```

### Dangerous Function Calls
Watch for: `eval()`, `exec()`, `shell_exec()`, `innerHTML`, `document.write()`, `dangerouslySetInnerHTML`

### Command Injection
```python
# BAD: User input in shell commands
os.system(f"convert {filename} output.png")

# GOOD: Use subprocess with explicit arguments
subprocess.run(["convert", filename, "output.png"], check=True)
```

---

## 2. Invariants (What Must Not Change)

Invariants are properties that must remain true throughout system execution and evolution. AI doesn't understand your system's invariants—you must verify they're preserved.

### API Contracts
- Request/response shapes match existing documentation
- HTTP status codes follow established patterns
- Error response formats remain consistent

### Database Schema Assumptions
- Foreign key relationships preserved
- NOT NULL constraints respected
- Column types match expectations

### Error Codes and Their Meanings
- Error codes mean the same thing as before
- New error codes don't conflict with existing ones

### Public Function Signatures
- Parameters haven't changed in incompatible ways
- Return types are consistent
- Thrown exceptions match interface contracts

### Configuration File Formats
- Environment variable names unchanged
- Config file structure preserved
- Default values maintained

### Event Names and Payload Structures
- Event names match subscribers' expectations
- Payload fields present and correctly typed
- Breaking changes flagged for migration

**Example from real systems:**
> "TigerBeetle doesn't allocate memory after startup. This simple invariant affects every bit of code—whatever you do, you must manage with existing, pre-allocated data structures." — matklad

---

## 3. Corner Cases and Boundaries

AI often handles the "happy path" correctly but misses edge cases. Use the **0-1-Many** testing pattern.

### Null/Undefined/Empty Inputs
```javascript
// Does the code handle:
processItems(null);      // null input
processItems(undefined); // undefined input
processItems([]);        // empty array
processItems("");        // empty string
```

### Array with 0, 1, Many Items
```python
# Test all three cases
calculate_average([])           # 0 items - division by zero?
calculate_average([42])         # 1 item - special case handling?
calculate_average([1, 2, 3])    # many items - normal operation
```

### Numeric Boundaries
- Zero (often special-cased incorrectly)
- Negative numbers (sign errors)
- MAX_INT / MIN_INT (overflow)
- Floating point precision (0.1 + 0.2 ≠ 0.3)

### Empty Strings vs Null
```javascript
// These are different!
user.name === ""     // empty string - user cleared their name
user.name === null   // null - name was never set
```

### Unicode and Special Characters
- Multi-byte characters (emoji, CJK)
- RTL text (Arabic, Hebrew)
- Null bytes in strings
- SQL/HTML special characters

### Concurrent Access Scenarios
- Race conditions (Time-of-Check vs Time-of-Use)
- Deadlocks
- Lost updates

---

## 4. Error and Failure Handling

AI-generated code often has optimistic error handling or exposes sensitive information in error messages.

### Network Timeouts and Retries
```python
# BAD: No timeout, will hang forever
response = requests.get(url)

# GOOD: Explicit timeout
response = requests.get(url, timeout=30)
```

### Database Connection Failures
- What happens when the database is down?
- Is there retry logic with backoff?
- Are connections properly pooled and released?

### Partial Failures in Batch Operations
```python
# BAD: All-or-nothing without transaction
for item in items:
    db.save(item)  # What if item 50 fails?

# GOOD: Transaction with clear rollback
with db.transaction():
    for item in items:
        db.save(item)
```

### Resource Cleanup
```python
# BAD: Resource leak on error
file = open("data.txt")
data = file.read()
process(data)  # If this throws, file stays open
file.close()

# GOOD: Context manager ensures cleanup
with open("data.txt") as file:
    data = file.read()
    process(data)
```

### Error Message Information Leakage
```python
# BAD: Exposes internal details (stack trace, SQL, paths)
except Exception as e:
    return {"error": str(e)}

# GOOD: Generic message, detailed logging server-side
except Exception as e:
    logger.error(f"Operation failed: {e}")
    return {"error": "An error occurred. Please retry."}
```

### Recovery Paths After Failure
- Can the system recover from a crash mid-operation?
- Is state left consistent after failures?
- Are partial writes cleaned up?

---

## What NOT to Focus On

AI-generated code typically excels at:
- ✅ Consistent formatting
- ✅ Reasonable variable naming
- ✅ Comment style
- ✅ Code structure

**Don't spend review time on surface-level "clean code" concerns.** The real bugs hide in logic, security, and edge cases—areas where LLMs systematically underperform.

---

## AI-Specific Pitfalls

Watch for these AI-unique failure modes:

### Hallucinated APIs
AI may suggest methods/functions that don't exist:
```javascript
// AI might generate this, but `safeParseJSON` isn't a real method
const data = JSON.safeParseJSON(input);
```

### Hallucinated Dependencies
AI may suggest packages that don't exist ("slopsquatting" risk):
```json
// Verify every dependency actually exists before installing
"dependencies": {
  "react-safe-utils": "^1.0.0"  // Does this package exist?
}
```

### Ignored Constraints
AI may ignore requirements mentioned in the prompt—verify all requirements are actually implemented.

### Tests Deleted Instead of Fixed
```python
# AI might "fix" failing tests by removing them!
# Before: 50 tests, 2 failing
# After AI "fix": 48 tests, 0 failing  ← RED FLAG
```

### Architectural Drift
Subtle design changes that break security invariants without violating syntax. Example: swapping crypto libraries, removing access control checks.

---

## Quick Checklist

Use this during every AI-generated PR review:

### Security
- [ ] All user input validated server-side
- [ ] Parameterized queries (no string interpolation in SQL)
- [ ] Authentication required on protected endpoints
- [ ] Authorization checks at each access point
- [ ] No hardcoded secrets or credentials
- [ ] No dangerous functions (`eval`, `exec`, `innerHTML`)
- [ ] Output encoding appropriate for context (HTML, JS, URL)

### Invariants
- [ ] API contracts unchanged (or intentionally versioned)
- [ ] Database schema assumptions preserved
- [ ] Public interfaces backward compatible
- [ ] Error codes/messages consistent
- [ ] Config formats unchanged

### Edge Cases
- [ ] Handles null/undefined/empty input
- [ ] Handles 0, 1, and many items
- [ ] Numeric boundaries tested (0, negative, MAX)
- [ ] Special characters handled
- [ ] Concurrent access considered

### Error Handling
- [ ] Network calls have timeouts
- [ ] Resources cleaned up on failure (files, connections)
- [ ] Errors logged server-side with context
- [ ] User-facing errors don't leak implementation details
- [ ] Partial failures handled gracefully

### AI-Specific
- [ ] All suggested APIs/methods actually exist
- [ ] All dependencies verified in package registry
- [ ] No tests mysteriously deleted
- [ ] All prompt requirements actually implemented
- [ ] Security controls not subtly removed

---

## Further Reading

- [GitHub: Review AI-Generated Code](https://docs.github.com/en/copilot/tutorials/review-ai-generated-code)
- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [OWASP Error Handling Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Error_Handling_Cheat_Sheet.html)
- [What is an Invariant?](https://matklad.github.io/2023/10/06/what-is-an-invariant.html)

---

[← Back: Antipatterns](04-antipatterns.md) | [Next: FAQ →](06-faq.md)

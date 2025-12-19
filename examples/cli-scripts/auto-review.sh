#!/bin/bash
# auto-review.sh - Automated code review script

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}Error: Claude CLI not found${NC}"
    echo "Install: curl -fsSL https://claude.ai/install.sh | sh"
    exit 1
fi

# Get files to review (staged or all changes)
MODE="${1:-staged}"

if [ "$MODE" = "staged" ]; then
    FILES=$(git diff --cached --name-only --diff-filter=ACM)
    DIFF=$(git diff --cached)
    echo -e "${GREEN}Reviewing staged files...${NC}"
elif [ "$MODE" = "all" ]; then
    FILES=$(git diff --name-only --diff-filter=ACM)
    DIFF=$(git diff)
    echo -e "${GREEN}Reviewing all changes...${NC}"
else
    echo -e "${RED}Usage: $0 [staged|all]${NC}"
    exit 1
fi

if [ -z "$FILES" ]; then
    echo -e "${YELLOW}No files to review${NC}"
    exit 0
fi

echo -e "${GREEN}Files to review:${NC}"
echo "$FILES"
echo ""

# Run Claude review
echo -e "${GREEN}Running Claude code review...${NC}"
REVIEW=$(echo "$DIFF" | claude "
Review these changes for:

**Critical Issues:**
- Security vulnerabilities (SQL injection, XSS, etc.)
- Hardcoded credentials or API keys
- Unhandled errors or exceptions
- Memory leaks or resource issues

**Code Quality:**
- Code duplication
- Complex functions (>50 lines)
- Missing error handling
- Poor naming conventions
- Missing comments for complex logic

**Best Practices:**
- Follows project patterns
- Proper logging
- Input validation
- Test coverage

**Output format:**
For each issue:
- Severity: [CRITICAL|HIGH|MEDIUM|LOW]
- File: [filename:line]
- Issue: [description]
- Fix: [recommendation]

If no issues: Output 'LGTM - No issues found'
")

echo "$REVIEW"

# Check if critical issues found
if echo "$REVIEW" | grep -q "Severity: CRITICAL"; then
    echo -e "\n${RED}❌ Critical issues found - review required${NC}"
    exit 1
elif echo "$REVIEW" | grep -q "LGTM"; then
    echo -e "\n${GREEN}✅ No issues found${NC}"
    exit 0
else
    echo -e "\n${YELLOW}⚠️  Issues found - review recommended${NC}"
    exit 0
fi




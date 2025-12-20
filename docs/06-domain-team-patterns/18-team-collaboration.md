---
title: "Section 18: Team Adoption Playbook"
parent: "Part 6: Domain-Specific & Team Collaboration"
nav_order: 2
---

# Section 18: Team Adoption Playbook

**Complete Guide to Rolling Out Claude Code to Your Team**

**What You'll Learn:**
- 5-phase adoption strategy (from pilot to scale)
- Week-by-week implementation plan
- Training materials and workshops
- Measuring success and ROI
- Overcoming common adoption challenges

**Time to read:** 25 minutes  
**Time to implement:** 4-8 weeks for full adoption

---

## Executive Summary

**Target audience:** Engineering managers, tech leads, team enablers

**Adoption timeline:**
- Week 1-2: Pilot with 2-3 developers
- Week 3-4: Rollout to full team
- Week 5-8: Optimization and scale

**Expected outcomes:**
- 80%+ adoption rate
- 30-50% productivity improvement
- 50-200x ROI
- Developer satisfaction increase

---

## Phase 1: Preparation (Week 0)

### Goals
- [ ] Get leadership approval
- [ ] Identify pilot team
- [ ] Set up infrastructure
- [ ] Create training materials

### Step 1: Build Business Case

**ROI Calculation Template:**

```
Team size: 10 developers
Average salary: $100/hour
Expected time savings: 20 hours/month/developer

Monthly value created:
10 developers × 20 hours × $100 = $20,000

Monthly Claude Code cost:
10 developers × $25 = $250

Monthly ROI: $20,000 / $250 = 80x return

Annual value: $240,000
Annual cost: $3,000
Payback period: < 1 week
```

**Presentation to leadership:**

```markdown
# Claude Code Investment Proposal

## The Ask
- **Monthly investment**: $250 for 10 developers
- **Annual cost**: $3,000
- **Setup time**: 4 weeks to full adoption

## The Return
- **Time savings**: 200 hours/month team-wide
- **Value created**: $20,000/month
- **ROI**: 80x return on investment
- **Payback period**: <1 week

## Competitive Advantages
- Ship features 30-50% faster
- Improve code quality (automated reviews)
- Attract top talent (modern AI development)
- Reduce developer burnout (automate tedious work)

## Risk Mitigation
- Start with 2-3 person pilot (low risk)
- Cancel anytime (no long-term contracts)
- Cost controls built in (budget alerts)
- Training included (internal enablement)

## Timeline
- Week 1-2: Pilot
- Week 3-4: Team rollout
- Week 5+: Measure results

## Approval Needed
- [ ] Budget approval: $250/month
- [ ] Time allocation: 4 hours for training
- [ ] Go-ahead for pilot team
```

### Step 2: Select Pilot Team

**Ideal pilot team characteristics:**

✅ **Good candidates:**
- Early adopters (excited about AI tools)
- Diverse skill levels (junior + senior)
- Good communicators (can evangelize)
- Representative workflows (similar to rest of team)
- 2-3 developers (small enough to manage, large enough for validation)

❌ **Avoid:**
- Skeptics (wait for them to see results)
- Isolated developers (need shared experience)
- Very junior only (need experienced developers to evaluate)
- Too large (>5 people in pilot)

**Selection script:**

```markdown
# Pilot Team Invitation

Hi [Name],

We're piloting Claude Code, an AI coding assistant that's showing 30-50% 
productivity gains in early testing.

I'd like to invite you to be part of our pilot team (2-3 people, 2 weeks).

**What's involved:**
- 30-min onboarding session
- Use Claude Code for your daily work
- 15-min daily standups to share learnings
- Quick feedback survey at end of week 1 and 2

**What's in it for you:**
- Early access to cutting-edge AI tools
- Input on how we adopt this team-wide
- Potential 30-50% time savings on routine tasks

**Time commitment:**
- Onboarding: 30 minutes
- Daily usage: Integrated into your normal workflow
- Feedback: 5 minutes/day

Interested? Let me know by [date].

Thanks,
[Your Name]
```

### Step 3: Technical Setup

**Infrastructure checklist:**

```bash
# 1. API Key Management
# Option A: Individual keys (recommended)
- Each developer gets their own key
- Tracked separately for cost attribution
- Go to: https://console.anthropic.com/

# Option B: Shared key
- Use secret manager (1Password, AWS Secrets, etc.)
- Team budget tracking
- Less granular visibility

# 2. Install CLI for pilot team
npm install -g @anthropic/claude-code

# 3. Create shared CLAUDE.md template
cat > CLAUDE.md.template << 'EOF'
# Project: [PROJECT_NAME]

## Tech Stack
- [List technologies]

## Architecture
- [High-level architecture]

## Conventions
- [Coding standards]

## Common Tasks
- [Frequent operations]
EOF

# 4. Set up shared prompt library
mkdir .claude-prompts/
# Add prompts from Section 20

# 5. Configure cost alerts
claude --set-budget 100 --alert-at 80
```

### Step 4: Create Training Materials

**30-Minute Onboarding Workshop Outline:**

```markdown
# Claude Code Onboarding Workshop (30 min)

## Agenda
1. What is Claude Code (5 min)
2. Installation & Setup (5 min)
3. First Commands (10 min)
4. Daily Workflows (5 min)
5. Tips & Best Practices (3 min)
6. Q&A (2 min)

## 1. What is Claude Code (5 min)

**Demo**: Live coding showing:
- Code review: `git diff | claude "review"`
- Write tests: `claude "write tests for auth.ts"`
- Debug: `npm test | claude "explain failures"`

**Key message**: "It's like having a senior developer available 24/7"

## 2. Installation & Setup (5 min)

**Follow along**:
```bash
# Install
npm install -g @anthropic/claude-code

# Set API key
export ANTHROPIC_API_KEY="your-key"

# Test
claude "hello world"
```

**For VS Code users**:
- Install Claude Code extension
- Configure API key
- Show Spark icon

## 3. First Commands (10 min)

**Interactive exercises** (everyone does these):

Exercise 1: Code Review
```bash
git diff | claude "review my changes"
```

Exercise 2: Generate Tests
```bash
claude "write jest tests for src/utils.ts"
```

Exercise 3: Debug
```bash
npm test 2>&1 | claude "explain failures"
```

**Success check**: Everyone completes all 3 exercises

## 4. Daily Workflows (5 min)

**Cheat sheet distribution**:
- Morning routine
- Before committing
- Code review
- Debugging

**Demo**: Show workflow integration

## 5. Tips & Best Practices (3 min)

**Key tips:**
- Create CLAUDE.md (90% cost savings)
- Use specific prompts (not "fix my code")
- Attach relevant files
- Review before accepting

**Cost management:**
- Expected: $15-25/month
- Budget alert at $30
- Check daily: `claude --usage-today`

## 6. Q&A (2 min)

**Common questions**:
- "Is my code sent to Anthropic?" → Yes, see privacy policy
- "Can I use offline?" → No, requires internet
- "What if I make a mistake?" → Git is your friend, review before commit

## Homework

**Try these today:**
- Set up CLAUDE.md in your project
- Use Claude for one code review
- Use Claude to write one test

**Tomorrow's standup:**
- Share: What worked well?
- Share: Any issues?
```

**Create quick reference card:**

```markdown
# Claude Code Quick Reference

## Essential Commands
```bash
# Code review
git diff | claude "review"

# Write tests
claude "write tests for [file]"

# Debug
[command] 2>&1 | claude "explain errors"

# Generate
claude "create [description]"
```

## Daily Workflow
1. Morning: `git pull && claude "summarize changes"`
2. Before commit: `git diff --cached | claude "review"`
3. PR prep: `git diff main | claude "generate PR description"`

## Tips
- Create CLAUDE.md → 90% savings
- Be specific in prompts
- Attach files: `@filename`
- Check costs: `claude --usage-today`

## Help
- Docs: [link to your internal wiki]
- Slack: #claude-code
- Office hours: Fridays 2pm
```

---

## Phase 2: Pilot (Week 1-2)

### Week 1 Goals
- [ ] All pilot members successfully using Claude daily
- [ ] At least 5 use cases validated
- [ ] No blocking issues
- [ ] Initial productivity gains visible

### Day 1: Launch

**Morning (30 min):**
- Onboarding workshop (see Phase 1)
- Everyone completes first 3 commands
- Answer questions

**Afternoon:**
- Pilot team uses Claude for real work
- Encourage experimentation

**Evening:**
- Send Slack message:
```
Great job today, pilot team! 🚀

Tomorrow's challenge: Use Claude for ONE task that 
normally takes you 30+ minutes.

Share your win in #claude-code!
```

### Day 2-5: Daily Check-ins

**Daily Standup (5 min):**
```
Round-robin sharing:
- What did you use Claude for yesterday?
- What worked well?
- Any issues?
- New use case discovered?
```

**Track in shared doc:**
```markdown
# Pilot Team Daily Log

## Day 2 - [Date]
### Wins
- Alice: Code review caught 3 bugs I missed
- Bob: Generated test suite in 5 min (vs 45 min normally)

### Issues
- Charlie: Confused about when to use Haiku vs Sonnet

### Use Cases Discovered
- Analyzing log files
- Generating git commit messages

### Time Saved Today
- Estimated: 3 hours across team
```

### Week 1 Friday: First Retrospective

**15-minute retro:**

```markdown
# Week 1 Pilot Retrospective

## What Worked Well (Keep Doing)
- [Pilot team lists successes]

## What Didn't Work (Stop/Change)
- [Issues encountered]

## Surprises (Unexpected Benefits)
- [Unexpected wins]

## Use Cases Validated
- [ ] Code review
- [ ] Test generation
- [ ] Debugging
- [ ] Documentation
- [ ] [Others]

## Metrics
- Total queries: [X]
- Time saved: [X hours]
- Cost: $[X]
- Satisfaction: [X]/10

## Week 2 Goals
- [Specific goals based on learnings]
```

### Week 2: Expansion

**Goals:**
- Scale within pilot team (more use cases)
- Document best practices
- Prepare for full rollout
- Calculate ROI

**Activities:**

**Mon-Thu: Advanced Use Cases**
- Day 1: Architecture reviews
- Day 2: Refactoring automation
- Day 3: CI/CD integration
- Day 4: Documentation generation

**Friday: Final Pilot Review**

```markdown
# Pilot Program Final Review

## Success Criteria (Check All)
- [ ] All pilot members active users
- [ ] 10+ use cases validated
- [ ] No show-stopping issues
- [ ] Positive feedback (7+/10 satisfaction)
- [ ] Documented best practices
- [ ] ROI demonstrated

## Metrics Summary
- Pilot team size: [X]
- Active users: [X] ([X]%)
- Total queries: [X]
- Time saved: [X] hours
- Cost: $[X]
- ROI: [X]x

## Top Use Cases (By Frequency)
1. Code review - [X] times
2. Test generation - [X] times
3. Debugging - [X] times
4. [etc.]

## Testimonials
"[Quote from pilot member 1]"
"[Quote from pilot member 2]"

## Recommendations
✅ Proceed to full team rollout
Changes needed before rollout:
- [Any issues to address]
```

---

## Phase 3: Rollout (Week 3-4)

### Week 3: Training & Onboarding

**Goal:** Get entire team onboarded and productive

**Monday: Kickoff**

**Team announcement:**
```markdown
# Claude Code Rollout - Starting This Week!

Based on our successful pilot (3 developers, 2 weeks, 
50+ hours saved), we're rolling out Claude Code to the 
entire team.

**What**: AI coding assistant for faster development
**When**: Training sessions this week
**Who**: All developers

## Pilot Results
- 30-50% faster on routine tasks
- Caught bugs in code review
- Automated test generation
- 80x ROI

## Training Sessions
Choose ONE:
- Session A: Monday 2pm (30 min)
- Session B: Tuesday 10am (30 min)
- Session C: Wednesday 3pm (30 min)

[Sign up link]

## What You Need
- Laptop with VS Code or terminal
- 30 minutes
- Willingness to try something new

See you there!
[Your Name]
```

**Training Sessions:**
- Repeat onboarding workshop 3x (different times)
- Max 5 people per session (interactive)
- Record for those who can't attend

**Wednesday: Office Hours**
- Open 2-hour window
- Drop-in for questions
- Troubleshooting help

**Friday: Check-in**
- Slack poll: "Have you used Claude this week?"
- Share early wins in #claude-code
- Address any blockers

### Week 4: Momentum Building

**Goal:** Drive adoption to 80%+

**Activities:**

**Daily "Tip of the Day"** (Slack #claude-code):
```
Monday: 💡 Tip: Create CLAUDE.md for 90% cost savings!
Tuesday: 💡 Tip: Use `git diff | claude "review"` before every commit
Wednesday: 💡 Tip: Pipe command output to Claude: `npm test | claude`
Thursday: 💡 Tip: Check daily costs: `claude --usage-today`
Friday: 💡 Tip: Save effective prompts in .claude-prompts/
```

**"Win of the Week"** (Friday):
```
🏆 This Week's Claude Code Win

[Developer Name] used Claude to refactor the entire auth 
system (15 files) in 2 hours vs the estimated 2 days.

Time saved: 14 hours
What they learned: [Key insight]

Your wins? Share in #claude-code!
```

**Adoption tracking:**
```bash
# Weekly survey (30 seconds)
1. Did you use Claude Code this week? (Yes/No)
2. How many times? (0, 1-5, 6-10, 11-20, 20+)
3. What was your best use case?
4. Any blockers?
```

---

## Phase 4: Optimization (Week 5-8)

### Goal: Maximize value, reduce friction

**Week 5: Cost Optimization**

**Team workshop (30 min):**
```markdown
# Cost Optimization Workshop

## Current State
- Team size: 10
- Monthly cost: $285
- Could be: $150 with optimization

## Optimization Strategies

1. **Create CLAUDE.md** (30% savings)
   - Who has it? (show of hands)
   - Who doesn't? → Do it now (5 min)

2. **Use Haiku for simple tasks** (40% savings)
   - Demo: Same task, Haiku vs Opus
   - Cost difference: 12x
   - When to use what

3. **Batch related queries** (20% savings)
   - Cache hits within 5 minutes
   - Group related questions

## Exercise
Everyone checks: `claude --usage-stats --month=current`
Find most expensive operation
Discuss: Could we use cheaper model?

## Commit
Everyone: I will [specific optimization action]
```

**Week 6: Advanced Patterns**

**Lunch & Learn sessions** (3x 30 min):
```
Session 1: CI/CD Integration
- Automate PR reviews
- Pre-commit hooks
- Release automation

Session 2: Team Workflows
- Shared prompt library
- Code review standards
- Pair programming with Claude

Session 3: Domain-Specific Use Cases
- Frontend: Screenshot to code
- Backend: API generation
- DevOps: IaC generation
```

**Week 7: Quality Improvements**

**Focus: Using Claude to improve code quality**

**Team challenge:**
```
This Week's Challenge: Increase Test Coverage

Current: 72%
Goal: 80%
How: Use Claude to generate tests

Prize: Team lunch for highest coverage increase

Tips:
claude "write tests for [uncovered file]"
claude "add edge case tests for [function]"
```

**Week 8: ROI Review**

**Monthly team metrics review** (30 min meeting):

```markdown
# Month 1 Results Review

## Adoption Metrics
- Active users: 9/10 (90%)
- Queries/week: 215 (21.5 per dev)
- Most active: [Name] (45 queries)
- Least active: [Name] (8 queries)

## Productivity Metrics
- PRs merged: 62 (was 45 last month)
- Avg time to merge: 18h (was 36h)
- Test coverage: 85% (was 72%)
- Production bugs: 3 (was 7)

## Financial Metrics
- Cost: $215/month
- Time saved: 180 hours
- Value: $18,000
- ROI: 84x

## Team Feedback
- Satisfaction: 8.5/10
- Would recommend: 9/10
- Want to continue: 10/10

## Next Month Goals
- [ ] Reach 95% adoption
- [ ] Integrate with Jira
- [ ] Create team prompt library
- [ ] Reduce cost to <$20/dev
```

---

## Phase 5: Scale & Sustain (Month 2+)

### Sustaining Adoption

**Monthly rituals:**

**1. Metrics Review** (30 min, first Friday)
- Review dashboard (see Section 22)
- Celebrate wins
- Address any issues
- Set next month's goals

**2. Prompt Library Update** (ongoing)
```markdown
# Team Prompt Library

## Most Effective Prompts (This Month)

### Code Review (Used 45x, 95% satisfaction)
```bash
git diff --cached | claude "Review for security, performance, 
and edge cases. Be specific with file:line references."
```

### Test Generation (Used 38x, 90% satisfaction)
```bash
claude "Write Jest tests for [file] covering:
1. Happy path
2. Error cases
3. Edge cases (null, empty, boundary)
Aim for 100% coverage."
```

### [Add team's most effective prompts]
```

**3. Office Hours** (weekly, 1 hour)
- Drop-in Q&A
- Share advanced techniques
- Troubleshoot issues
- Collect feedback

**4. "Claude Champion" Rotation**
- Designate monthly "champion"
- Responsibilities:
  - Share tips in standup
  - Answer questions
  - Update prompt library
  - Run metrics review

**Quarterly reviews:**
- ROI calculation
- Budget review
- Feature requests
- Expansion planning

### Expanding to Other Teams

**Once successful in one team:**

```markdown
# Expansion Plan

## Validated Success
- Team 1 (Engineering): 90% adoption, 80x ROI
- Ready to expand to Teams 2-4

## Expansion Strategy

### Month 2-3: Second Wave
- Teams: QA, DevOps (10 people)
- Using learnings from Team 1
- Pilot: 1 week (vs 2 weeks originally)
- Training: Self-service + office hours

### Month 4-6: Third Wave
- Teams: Product, Design (8 people)
- Different use cases (documentation, research)
- Custom training for non-engineers

### Month 7+: Company-wide
- All technical staff
- Centralized support
- Enterprise licensing discussion
```

---

## Measuring Success

### Leading Indicators (Predict Success)

**Track weekly:**

| Metric | Target | Why It Matters |
|--------|--------|----------------|
| **Active users** | >80% | Adoption measure |
| **Queries per user** | 15-30/week | Engagement level |
| **Repeat usage** | >3 days/week | Habit formation |
| **Satisfaction** | >7/10 | User happiness |

**Red flags:**
- <60% active users → Need better training/communication
- <10 queries/week → Not finding value, need help
- <5/10 satisfaction → Serious issues, investigate immediately

### Lagging Indicators (Results)

**Track monthly:**

| Metric | Target | Calculation |
|--------|--------|-------------|
| **Team velocity** | +20% | PRs merged / month |
| **Time to merge** | -30% | Hours from PR → merge |
| **Test coverage** | +10% | Coverage tool |
| **Production bugs** | -20% | Issue tracker |
| **Cost per dev** | <$30 | Total cost / team size |
| **ROI** | >50x | Value created / cost |

### Qualitative Feedback

**Monthly pulse survey** (2 min):

```
1. How often do you use Claude Code?
   [ ] Daily  [ ] 2-3x/week  [ ] Weekly  [ ] Rarely

2. What's your primary use case?
   [ ] Code review  [ ] Testing  [ ] Debugging  [ ] Other: _____

3. How much time does it save you?
   [ ] 0-5h/month  [ ] 5-15h  [ ] 15-30h  [ ] 30+h

4. Satisfaction (1-10): ___

5. What would make you use it more?
   [Open text]

6. Biggest pain point?
   [Open text]
```

---

## Overcoming Common Challenges

### Challenge 1: Low Adoption

**Symptoms:**
- <60% active users after month 1
- Queries dropping week-over-week
- Lack of engagement

**Root causes & solutions:**

| Cause | Solution |
|-------|----------|
| **Don't see value** | Share concrete examples, calculate personal ROI |
| **Too complex** | Better training, simplify workflows |
| **No time to learn** | Mandatory 30-min session, show 5-min win |
| **Skeptical** | Show data from pilot, peer testimonials |
| **Forgot about it** | Daily tips, standups mention, make visible |

**Action plan:**
```markdown
Week 1: Diagnose
- Survey non-users: "Why aren't you using Claude?"
- Identify common themes

Week 2: Intervention
- For "don't see value": 1-on-1 demos showing their use cases
- For "too complex": Simplified 10-min quickstart
- For "forgot": Daily Slack reminders

Week 3-4: Re-engage
- Pair non-users with active users
- Set team challenge (everyone uses 1x this week)
- Celebrate any usage (positive reinforcement)
```

### Challenge 2: Cost Concerns

**Symptoms:**
- Budget alerts triggering
- Leadership questions about ROI
- Users worried about personal cost

**Solutions:**

**Immediate:**
```bash
# Enable cost optimization
1. Ensure all have CLAUDE.md: 90% savings
2. Set default to Sonnet: 5x savings vs Opus
3. Disable extended thinking by default: 2x savings
4. Batch related queries: 20% savings

# Result: $25/month → $8/month per dev
```

**Communicate ROI:**
```
Cost this month: $285
Time saved: 180 hours
Value at $100/hour: $18,000
ROI: 63x

Even if we're off by 50%, it's still 31x ROI.
```

**Set expectations:**
- Target: $15-25/month per developer
- Alert at: $35/month per developer
- Review: Anyone >$50/month

### Challenge 3: Quality Concerns

**Symptoms:**
- Code generated by Claude has bugs
- Team loses trust in tool
- More manual review needed

**Solutions:**

**Set clear expectations:**
```markdown
# Claude Code Review Policy

Claude is a TOOL, not a replacement for judgment.

✅ DO:
- Use Claude for first drafts
- Use Claude to catch obvious issues
- Use Claude to speed up routine tasks

❌ DON'T:
- Blindly accept all suggestions
- Skip code review
- Commit without testing
- Blame Claude for your mistakes

## Process
1. Claude generates code
2. YOU review carefully
3. YOU test thoroughly
4. YOU take responsibility
```

**Training on code review:**
- How to spot AI hallucinations
- Common patterns of errors
- When to question suggestions
- Verifying logic before accepting

**Metrics:**
- Track: Bugs from Claude-generated code
- If >10% of bugs: Need better review process
- If <5%: Claude is helping quality

### Challenge 4: Resistance from Senior Developers

**Symptoms:**
- Senior devs not using tool
- "We don't need AI" attitude
- Influencing others negatively

**Understanding their concerns:**
- Fear of being replaced
- Pride in craft
- Previous bad experiences with "AI hype"
- Complexity concerns

**Solutions:**

**Frame correctly:**
```
This is not about replacing you.
This is about amplifying your impact.

Junior dev + Claude ≠ Senior dev
Senior dev + Claude = 10x Senior dev

You have 10 years of experience.
Claude helps you apply it faster.
```

**Show advanced use cases:**
- Architecture reviews (Claude as sounding board)
- Code review at scale (review 5 PRs in time of 1)
- Mentoring (Claude explains to juniors, you focus on complex)
- Documentation (tedious but necessary)

**Respect their expertise:**
- Ask for their feedback on Claude's suggestions
- Use them to validate complex outputs
- Make them "Claude Champions"
- Highlight where their experience > Claude

---

## Team Collaboration Patterns

### Shared Prompt Library

**Structure:**
```
.claude-prompts/
├── README.md           # How to use
├── code-review.sh      # Standard code review
├── testing.sh          # Test generation
├── documentation.sh    # Doc generation
├── debugging.sh        # Debug patterns
└── team-specific/      # Your domain prompts
    ├── api-design.sh
    ├── database.sh
    └── frontend.sh
```

**Example shared prompt:**
```bash
#!/bin/bash
# .claude-prompts/code-review.sh
# Team standard code review prompt

git diff --cached | claude "Code review following our team standards:

Security:
- No secrets in code
- Input validation present
- SQL queries parameterized

Performance:
- No N+1 queries
- Proper indexing
- Caching where appropriate

Quality:
- Tests included (coverage >80%)
- Error handling present
- Documentation updated

Format: 
🔴 Blocking issues
🟡 Should fix
🟢 Good practices
💡 Suggestions

Be specific with file:line references."
```

**Usage:**
```bash
# Anyone on team
.claude-prompts/code-review.sh
```

### Pair Programming with Claude

**Pattern: Developer + Claude + Developer**

**Roles:**
- **Driver**: Writing code
- **Navigator**: Reviewing and asking Claude questions
- **Claude**: Generating, reviewing, explaining

**Example session:**
```
Driver: "Let's add pagination to the users endpoint"

Navigator asks Claude:
"What's the best practice for cursor-based pagination in Express?"

Claude responds with pattern.

Driver implements.

Navigator asks Claude:
"Review this implementation - any issues?"

Claude catches edge case (empty results).

Driver fixes.

Both learn from Claude's explanation.
```

**Benefits:**
- Knowledge sharing (both learn)
- Real-time code review
- Faster problem-solving
- Team building

### Code Review Standards

**Team decision: When to use Claude in review**

```markdown
## PR Review Process

### Automated (Claude)
Before requesting human review:
```bash
git diff main | claude "Automated review checklist:
- Security issues
- Performance problems
- Test coverage
- Documentation
Fail PR if critical issues found."
```

### Human Review
After Claude review passes:
- Architecture decisions
- Business logic correctness
- User experience
- Strategic direction

### Both
Some things need both:
- Complex algorithms (Claude catches bugs, human validates approach)
- API design (Claude checks patterns, human checks use cases)
- Database changes (Claude checks queries, human checks data model)
```

---

## Templates & Checklists

### Team Onboarding Checklist

```markdown
## New Team Member: Claude Code Setup

### Day 1
- [ ] API key obtained from [source]
- [ ] CLI installed: `npm install -g @anthropic/claude-code`
- [ ] VS Code extension installed (if applicable)
- [ ] ANTHROPIC_API_KEY environment variable set
- [ ] Test: `claude "hello world"` works

### Week 1
- [ ] Attended 30-min onboarding workshop
- [ ] Completed first 3 commands exercise
- [ ] Created CLAUDE.md in main project
- [ ] Read team prompt library (. claude-prompts/)
- [ ] Joined #claude-code Slack channel
- [ ] Used Claude for 1 real task

### Week 2-4
- [ ] Using Claude daily for routine tasks
- [ ] Contributed 1 prompt to team library
- [ ] Pair programmed with Claude with teammate
- [ ] Comfortable with cost monitoring

### Success Criteria
- [ ] 10+ Claude queries in first 2 weeks
- [ ] At least 1 meaningful time savings
- [ ] Confident to use independently
```

### Monthly Team Review Template

```markdown
# Claude Code Monthly Review - [Month]

**Attendees**: [Team members]
**Date**: [Date]

## Metrics Review (10 min)
- Adoption: [X]% active users
- Usage: [X] queries/week per person
- Cost: $[X] total, $[X] per dev
- Time saved: [X] hours
- ROI: [X]x

## Wins of the Month (10 min)
1. [Specific win with details]
2. [Another win]
3. [Third win]

## Challenges (5 min)
1. [Challenge] - Owner: [Name] - Due: [Date]
2. [Another challenge]

## Prompt Library Updates (3 min)
- New prompts added: [X]
- Most used: [Prompt name] ([X] uses)
- Retired: [Any outdated prompts]

## Next Month Goals (2 min)
- [ ] Goal 1 (Owner: [Name])
- [ ] Goal 2 (Owner: [Name])
- [ ] Goal 3 (Owner: [Name])

## Action Items
- [ ] [Action] - Owner: [Name] - Due: [Date]
- [ ] [Action] - Owner: [Name] - Due: [Date]

**Next review**: [Date]
```

---

## Summary

### Adoption Timeline

**Week 0**: Preparation (leadership approval, pilot selection)
**Week 1-2**: Pilot (2-3 developers validate)
**Week 3**: Training (full team onboarding)
**Week 4**: Momentum (drive to 80%+ adoption)
**Week 5-8**: Optimization (cost, quality, workflows)
**Month 2+**: Sustain & Scale

### Success Metrics

**By end of Month 1:**
- 80%+ adoption rate
- 20+ hours/month saved per developer
- <$30/month cost per developer
- 50x+ ROI
- 7+/10 satisfaction

### Key Success Factors

1. **Leadership support** - Budget and time allocated
2. **Pilot validation** - Early wins demonstrated
3. **Training quality** - Everyone knows how to use it
4. **Daily reinforcement** - Tips, wins, visible usage
5. **Continuous optimization** - Cost, quality, workflows improving

### Resources Created

- [ ] Business case presentation
- [ ] Pilot team selection
- [ ] 30-min onboarding workshop
- [ ] Quick reference card
- [ ] Shared prompt library
- [ ] Team collaboration patterns
- [ ] Monthly review template
- [ ] Metrics dashboard (see Section 22)

### Next Steps

1. **This week**: Present business case to leadership
2. **Next week**: Select pilot team, technical setup
3. **Week after**: Begin pilot
4. **Month 2**: Full team rollout

**Good luck with your Claude Code adoption!** 🚀

---

[← Back: Domain Workflows](17-domain-workflows) | [Next: Testing & QA →](19-testing-qa)

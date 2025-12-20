---
title: "Section 17b: Real Debugging Sessions"
parent: "Part 6: Domain-Specific & Team Collaboration"
nav_order: 2
---

# Section 17b: Real Debugging Sessions

**What This Section Provides:**
- Complete, unedited debugging conversations with Claude
- Real problems developers face daily
- Iterative problem-solving (not just final solutions)
- Time comparisons vs traditional debugging
- Lessons learned from each session

**Why These Matter:**
- See Claude's thought process in action
- Learn effective questioning techniques
- Understand when to pivot approaches
- Recognize patterns for your own debugging

---

## Table of Contents

1. [Session 1: API Returns 500, No Logs](#session-1-api-returns-500-no-logs)
2. [Session 2: React Component Infinite Re-Renders](#session-2-react-component-infinite-re-renders)
3. [Session 3: TypeScript Build Fails with Cryptic Error](#session-3-typescript-build-fails-with-cryptic-error)
4. [Session 4: Performance Regression After Refactor](#session-4-performance-regression-after-refactor)
5. [Session 5: Flaky Test in CI](#session-5-flaky-test-in-ci)
6. [Session 6: Memory Leak in Node.js Service](#session-6-memory-leak-in-nodejs-service)
7. [Session 7: CORS Error in Production Only](#session-7-cors-error-in-production-only)

---

## Session 1: API Returns 500, No Logs

**Context:**
- **Tech Stack**: Node.js 20, Express 4, PostgreSQL with Prisma
- **Symptom**: POST /api/users endpoint returns 500 error for ~5% of requests
- **Severity**: High (production issue affecting users)
- **Traditional Debug Time**: 2-4 hours (reproduce locally, add logging, deploy, wait)
- **With Claude**: 8 minutes

### Initial Problem Report

**Developer:**
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User"}' \
| claude "API returns 500 error but nothing in logs. Here's the endpoint code:" \
  --files="src/routes/users.ts"
```

**File: src/routes/users.ts**
```typescript
router.post('/users', async (req, res) => {
  const { email, name } = req.body;
  
  const user = await prisma.user.create({
    data: { email, name }
  });
  
  res.json(user);
});
```

### Claude's Initial Analysis

**Claude:**
```
I can see several issues that would cause intermittent 500 errors without logs:

🔴 **Critical Issue 1: Unhandled Promise Rejection**
Lines 2-7: The async function has no try-catch block. If prisma.user.create() 
throws an error (duplicate email, database connection timeout, etc.), the 
promise rejection is unhandled, resulting in a 500 error.

🔴 **Critical Issue 2: Missing Error Middleware**
The error isn't being logged because Express default error handler doesn't 
catch async errors unless you have async error handling middleware.

🟡 **Issue 3: No Input Validation**
Missing validation for email/name could cause database constraint errors.

**Why no logs?**
Unhandled promise rejections in async Express routes bypass error middleware 
unless you explicitly catch them or use express-async-errors.

**Immediate Fix:**
Add try-catch and proper error handling.
```

### Follow-up Question

**Developer:**
```bash
claude "Show me the fix for both the route and the error middleware"
```

### Claude's Solution

**Claude:**
```typescript
// Fix 1: Add try-catch to route
router.post('/users', async (req, res, next) => {
  try {
    const { email, name } = req.body;
    
    // Add validation
    if (!email || !name) {
      return res.status(400).json({ 
        error: 'Email and name are required' 
      });
    }
    
    const user = await prisma.user.create({
      data: { email, name }
    });
    
    res.json(user);
  } catch (error) {
    // Pass error to error middleware
    next(error);
  }
});

// Fix 2: Add error middleware (in app.ts)
app.use((err, req, res, next) => {
  // Log error for debugging
  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    body: req.body
  });
  
  // Handle specific errors
  if (err.code === 'P2002') { // Prisma unique constraint
    return res.status(409).json({ 
      error: 'User with this email already exists' 
    });
  }
  
  if (err.code === 'P2024') { // Prisma connection timeout
    return res.status(503).json({ 
      error: 'Database temporarily unavailable' 
    });
  }
  
  // Generic error
  res.status(500).json({ 
    error: 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { 
      details: err.message 
    })
  });
});
```

**Explanation:**
1. Added try-catch in async route handler
2. Pass errors to Express error middleware via next(error)
3. Created error middleware that:
   - Logs all errors (now you'll see them!)
   - Handles Prisma-specific errors
   - Returns appropriate HTTP status codes
   - Includes details in development mode
```

### Verification

**Developer:**
```bash
# Applied changes, restarted server, tested
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"email":"existing@example.com","name":"Test"}'

# Output now shows:
# {"error":"User with this email already exists"}

# And in server logs:
# Error: Unique constraint failed on email
# Path: /api/users
# Method: POST
```

### Outcome

✅ **Fixed:**
- Added proper async error handling
- Implemented error logging middleware
- Added input validation
- Proper HTTP status codes (400, 409, 503, 500)

⏱️ **Time Saved:**
- Traditional debugging: 2-4 hours (reproduce, add logs, deploy, monitor)
- With Claude: 8 minutes (analyze, fix, test)
- **Savings: 15-30x faster**

💰 **Cost:** $0.08 (Sonnet 4.5)

📚 **Lessons Learned:**
1. Always wrap async Express handlers in try-catch or use express-async-errors
2. Unhandled promise rejections bypass error middleware
3. Prisma error codes are crucial for proper error handling
4. Include request context in error logs (path, method, body)

### Additional Refinement

**Developer:** "Is there a cleaner way than wrapping every route?"

**Claude:**
```typescript
// Option 1: Async wrapper utility
const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};

// Use it:
router.post('/users', asyncHandler(async (req, res) => {
  const { email, name } = req.body;
  // No try-catch needed!
  const user = await prisma.user.create({ data: { email, name } });
  res.json(user);
}));

// Option 2: Install express-async-errors
// npm install express-async-errors
// In app.ts:
require('express-async-errors');
// Now all async errors are automatically caught!
```

**Developer chose:** Option 2 (express-async-errors) - applied globally, no route changes needed.

---

## Session 2: React Component Infinite Re-Renders

**Context:**
- **Tech Stack**: React 18, TypeScript, Custom hooks
- **Symptom**: Browser freezes, console shows "Maximum update depth exceeded"
- **Severity**: High (app unusable)
- **Traditional Debug Time**: 1-2 hours (isolate component, review deps, trial-and-error)
- **With Claude**: 5 minutes

### Initial Problem Report

**Developer:**
```bash
# Browser console error
claude "Component keeps re-rendering infinitely. Error: Maximum update depth exceeded.
Here's the component:" --files="src/components/UserDashboard.tsx"
```

**File: src/components/UserDashboard.tsx**
```typescript
function UserDashboard() {
  const [user, setUser] = useState(null);
  const [stats, setStats] = useState({ visits: 0, posts: 0 });
  
  // Fetch user data
  useEffect(() => {
    fetchUser().then(data => setUser(data));
  }, [user]); // ⚠️ Problem here
  
  // Fetch stats when user changes
  useEffect(() => {
    if (user) {
      fetchStats(user.id).then(data => setStats(data));
    }
  }, [user, stats]); // ⚠️ And here
  
  return (
    <div>
      <h1>{user?.name}</h1>
      <Stats data={stats} />
    </div>
  );
}
```

### Claude's Analysis

**Claude:**
```
Found the infinite loop! There are TWO problematic dependency arrays:

🔴 **Problem 1: Line 6 - useEffect depends on what it updates**
useEffect(() => {
  fetchUser().then(data => setUser(data));
}, [user]); // ← INFINITE LOOP

Flow:
1. Effect runs → fetches user → calls setUser
2. setUser updates user state
3. user changed → effect runs again (because user is in deps)
4. Repeat forever ♾️

**Fix:** Remove 'user' from dependencies. Run only on mount.
```tsx
useEffect(() => {
  fetchUser().then(data => setUser(data));
}, []); // ← Empty array = run once on mount
```

🔴 **Problem 2: Line 12 - useEffect depends on stats, updates stats**
useEffect(() => {
  if (user) {
    fetchStats(user.id).then(data => setStats(data));
  }
}, [user, stats]); // ← stats shouldn't be here

Flow:
1. Effect runs → fetches stats → calls setStats
2. setStats updates stats
3. stats changed → effect runs again (because stats is in deps)
4. Repeat forever ♾️

**Fix:** Only depend on user, not stats.
```tsx
useEffect(() => {
  if (user) {
    fetchStats(user.id).then(data => setStats(data));
  }
}, [user]); // ← Only re-run when user changes
```

**Root Cause:**
Depending on state that the effect itself updates creates infinite loops.
```

### Developer Follow-up

**Developer:** "Why did React add stats to the deps? I thought I only put user?"

**Claude:**
```
You did only put [user, stats]. The problem is you intentionally added 'stats' 
to the dependency array on line 12.

However, if you're using ESLint with react-hooks plugin, it may have 
SUGGESTED adding 'stats' because you're comparing it with new data:

```tsx
// ESLint sees stats in the function body
fetchStats(user.id).then(data => setStats(data));
// Suggests: "stats is used in effect but not in deps"
```

**Important:** ESLint's exhaustive-deps rule is helpful but NOT always right.

**When to ignore ESLint deps warning:**
1. ✅ State updated BY the effect (like this case)
2. ✅ Functions that don't need to trigger re-runs
3. ✅ Refs (never need to be in deps)

**When to listen to ESLint:**
1. ❌ Props used in effect
2. ❌ External state
3. ❌ Values from context
```

### Fixed Code

**Developer:**
```bash
claude "Show me the corrected component"
```

**Claude:**
```typescript
function UserDashboard() {
  const [user, setUser] = useState(null);
  const [stats, setStats] = useState({ visits: 0, posts: 0 });
  
  // Fetch user data once on mount
  useEffect(() => {
    fetchUser().then(data => setUser(data));
  }, []); // ✅ Empty deps = run once
  
  // Fetch stats when user changes (not when stats changes)
  useEffect(() => {
    if (user) {
      fetchStats(user.id).then(data => setStats(data));
    }
  }, [user]); // ✅ Only user in deps
  
  return (
    <div>
      <h1>{user?.name}</h1>
      <Stats data={stats} />
    </div>
  );
}
```

### Outcome

✅ **Fixed:**
- Removed circular dependencies
- Component renders exactly twice (initial + after user loads)
- Stats load once per user

⏱️ **Time Saved:**
- Traditional: 1-2 hours (trial and error with deps)
- With Claude: 5 minutes
- **Savings: 12-24x faster**

💰 **Cost:** $0.03 (Haiku 4.5)

📚 **Lessons Learned:**
1. Never put state in deps if the effect updates that state
2. ESLint exhaustive-deps is helpful but not infallible
3. Empty deps [] = run once on mount
4. [value] = run when value changes
5. Use React DevTools Profiler to see render causes

---

## Session 3: TypeScript Build Fails with Cryptic Error

**Context:**
- **Tech Stack**: TypeScript 5.3, Node.js project
- **Symptom**: `tsc` fails with error: "Type instantiation is excessively deep and possibly infinite"
- **Severity**: Critical (can't build)
- **Traditional Debug Time**: 2-3 hours (isolate type, simplify recursion, Google)
- **With Claude**: 12 minutes

### Initial Problem Report

**Developer:**
```bash
npm run build 2>&1 | claude "TypeScript build failing with weird error. 
Show the problematic types:" --files="src/types/api.ts"
```

**Error Output:**
```
error TS2589: Type instantiation is excessively deep and possibly infinite.
  at src/types/api.ts:45:3
```

**File: src/types/api.ts**
```typescript
// API response wrapper
type ApiResponse<T> = {
  data: T;
  meta: Metadata;
};

type Metadata = {
  timestamp: string;
  pagination?: Pagination;
};

type Pagination = {
  page: number;
  total: number;
  next?: ApiResponse<any>; // ⚠️ Problem here
};

// User types
type User = {
  id: string;
  name: string;
  friends: ApiResponse<User[]>; // ⚠️ And here
};

// Usage
type UsersResponse = ApiResponse<User[]>; // ← Fails here (line 45)
```

### Claude's Analysis

**Claude:**
```
Found the infinite type recursion!

🔴 **Problem: Circular Type References**

Line 18: Pagination references ApiResponse
Line 5:  ApiResponse can contain Pagination (via Metadata)
Line 18: Pagination references ApiResponse again...
→ Infinite loop of type instantiation

**Visual:**
```
ApiResponse
  └─ Metadata
      └─ Pagination
          └─ next?: ApiResponse  ← Back to start!
              └─ Metadata
                  └─ Pagination
                      └─ next?: ApiResponse
                          └─ ... infinite
```

**Additional Problem:**
Line 25: User type has friends: ApiResponse<User[]>
This creates another circular reference:
User → ApiResponse<User[]> → User → ApiResponse<User[]> → ...

**Why TypeScript Can't Handle This:**
TypeScript tries to fully resolve all type relationships at compile time. 
Circular references with generics create infinite type instantiation.
```

### Developer Question

**Developer:** "How do I fix this? I need pagination links and nested user data."

### Claude's Solution

**Claude:**
```typescript
// Fix 1: Break circularity in Pagination
type Pagination = {
  page: number;
  total: number;
  // Instead of ApiResponse<any>, use plain URL string
  nextUrl?: string; // ✅ Clients can fetch this
};

// Fix 2: For User friends, separate the response type
type User = {
  id: string;
  name: string;
  // Don't nest ApiResponse in the model
  friendIds: string[]; // ✅ Reference by ID
};

// Create separate response type for friends endpoint
type UserWithFriends = User & {
  friends: User[]; // Already resolved, no ApiResponse nesting
};

// Or if you need the full response wrapper:
type UserFriendsResponse = ApiResponse<User[]>;

// Usage (no more infinite types)
type UsersResponse = ApiResponse<User[]>; // ✅ Works!

// Alternative: Use interface (handles circularity better)
interface ApiResponse<T> {
  data: T;
  meta: Metadata;
}

interface User {
  id: string;
  name: string;
  friendIds: string[];
}

// For truly recursive types, use explicit recursion hint:
type NestedComment = {
  id: string;
  text: string;
  replies?: NestedComment[]; // ✅ This is OK (array breaks recursion)
};
```

**Best Practices:**
1. **Avoid circular generics** - ApiResponse<T> where T contains ApiResponse
2. **Use IDs for relationships** - Store friendIds, not full User objects
3. **Separate model and response types** - User (data model) vs UserResponse (API shape)
4. **Use interfaces for recursive types** - Better TS handling
5. **Arrays break recursion** - NestedComment[] is OK, NestedComment<T> is not
```

### Developer Follow-up

**Developer:** "What if I really need the nested structure from my API?"

**Claude:**
```typescript
// Solution: Type the API response as-is, but separate concerns

// 1. API response (exactly as API returns)
type ApiUserResponse = {
  data: {
    id: string;
    name: string;
    friends: {
      data: Array<{
        id: string;
        name: string;
      }>;
      meta: {
        pagination: {
          page: number;
          total: number;
          nextUrl?: string;
        };
      };
    };
  };
  meta: {
    timestamp: string;
  };
};

// 2. Domain model (for your app)
type User = {
  id: string;
  name: string;
  friendIds: string[];
};

// 3. Transformer function
function toUserModel(response: ApiUserResponse): User {
  return {
    id: response.data.id,
    name: response.data.name,
    friendIds: response.data.friends.data.map(f => f.id)
  };
}

// No infinite types, clean separation of concerns
```

### Outcome

✅ **Fixed:**
- Removed circular type references
- Separated API responses from domain models
- Build succeeds

⏱️ **Time Saved:**
- Traditional: 2-3 hours (Google, trial-and-error, Stack Overflow)
- With Claude: 12 minutes
- **Savings: 10-15x faster**

💰 **Cost:** $0.05 (Sonnet 4.5)

📚 **Lessons Learned:**
1. Avoid circular generic types (A<B> where B contains A<C>)
2. Use IDs for relationships instead of nesting full objects
3. Separate concerns: API types vs domain models
4. Interfaces handle recursion better than type aliases
5. Arrays naturally break recursion (T[] is safe)
6. Transform API responses to clean domain models

---

## Session 4: Performance Regression After Refactor

**Context:**
- **Tech Stack**: Node.js, Express, PostgreSQL
- **Symptom**: API endpoint went from 50ms → 2000ms after refactor
- **Severity**: High (40x slower)
- **Traditional Debug Time**: 2-4 hours (profiling, SQL logging, benchmarking)
- **With Claude**: 15 minutes

### Initial Problem Report

**Developer:**
```bash
git diff main src/services/posts.ts | claude "This refactor caused 40x performance regression. 
API went from 50ms to 2000ms. What did I break?"
```

**Git Diff:**
```diff
// Before (fast - 50ms)
-async function getPostsWithAuthors() {
-  const posts = await prisma.post.findMany({
-    include: {
-      author: true
-    }
-  });
-  return posts;
-}

// After (slow - 2000ms)
+async function getPostsWithAuthors() {
+  const posts = await prisma.post.findMany();
+  
+  // Add author info to each post
+  for (const post of posts) {
+    const author = await prisma.user.findUnique({
+      where: { id: post.authorId }
+    });
+    post.author = author;
+  }
+  
+  return posts;
+}
```

### Claude's Instant Analysis

**Claude:**
```
🔴 **Classic N+1 Query Problem**

**Before:**
- 1 query: Fetch all posts WITH authors (SQL JOIN)
- Total queries: 1
- Time: ~50ms

**After:**
- 1 query: Fetch all posts
- N queries: For EACH post, fetch author separately
- Total queries: 1 + N (if 100 posts = 101 queries)
- Time: ~2000ms (20ms per query × 100 posts)

**Visual:**
```
Before:
[ SELECT posts.*, users.* FROM posts JOIN users ... ] ← 1 query, 50ms

After:
[ SELECT * FROM posts ]                    ← 1 query, 20ms
[ SELECT * FROM users WHERE id = 1 ]       ← +20ms
[ SELECT * FROM users WHERE id = 2 ]       ← +20ms
[ SELECT * FROM users WHERE id = 3 ]       ← +20ms
... 97 more queries ...                    ← +1,940ms
Total: 2000ms
```

**Why the refactor broke it:**
Removing `include: { author: true }` broke Prisma's JOIN optimization.
Your manual loop creates one database round-trip PER POST.

**Fix:**
Restore the `include` (let Prisma optimize):
```typescript
async function getPostsWithAuthors() {
  const posts = await prisma.post.findMany({
    include: {
      author: true // ✅ Single JOIN query
    }
  });
  return posts;
}
```

**Performance:**
- Before refactor: 50ms ✅
- After your refactor: 2000ms ❌ (40x slower)
- After fix: 50ms ✅ (restored)
```

### Developer Question

**Developer:** "What if I need to do some processing on the author data before attaching it?"

### Claude's Better Solution

**Claude:**
```typescript
// Option 1: Post-process after fetching (still 1 JOIN)
async function getPostsWithAuthors() {
  const posts = await prisma.post.findMany({
    include: {
      author: true // ✅ Still fast JOIN
    }
  });
  
  // Process authors after fetch (in memory, not DB queries)
  return posts.map(post => ({
    ...post,
    author: {
      ...post.author,
      displayName: `${post.author.firstName} ${post.author.lastName}`
    }
  }));
}

// Option 2: If you really need separate queries, batch them
async function getPostsWithAuthors() {
  const posts = await prisma.post.findMany();
  
  // Collect all unique author IDs
  const authorIds = [...new Set(posts.map(p => p.authorId))];
  
  // ONE query for all authors (not N queries)
  const authors = await prisma.user.findMany({
    where: { id: { in: authorIds } }
  });
  
  // Create lookup map (O(1) lookups)
  const authorMap = new Map(authors.map(a => [a.id, a]));
  
  // Attach authors (in-memory, no DB queries)
  return posts.map(post => ({
    ...post,
    author: authorMap.get(post.authorId)
  }));
}

// Performance comparison:
// Original (include):     1 query,     50ms    ✅ Best
// Your refactor (loop):   N queries,   2000ms  ❌ Worst
// Option 2 (batch):       2 queries,   70ms    ✅ Good when processing needed
```

### Verification

**Developer:**
```bash
# Applied fix (restored include), tested with 100 posts
curl http://localhost:3000/api/posts | time

# Before fix: 2.1s
# After fix:  0.05s

# 42x faster! ✅
```

### Outcome

✅ **Fixed:**
- Restored Prisma JOIN optimization
- Reduced from 101 queries → 1 query
- Performance back to 50ms

⏱️ **Time Saved:**
- Traditional: 2-4 hours (enable SQL logging, profile queries, optimize)
- With Claude: 15 minutes (instant spotting of N+1)
- **Savings: 8-16x faster**

💰 **Cost:** $0.04 (Haiku 4.5 - simple query analysis)

📚 **Lessons Learned:**
1. **N+1 queries**: Most common performance killer
2. Always use `include` or `select` with Prisma for relations
3. If you need custom processing, fetch with JOIN first, process in-memory
4. Batch queries: ONE query for all related data, not N queries
5. Use `git diff` with Claude to catch regressions before deploy
6. Profile tools show symptoms; Claude explains causes

---

## Session 5: Flaky Test in CI

**Context:**
- **Tech Stack**: Jest, React Testing Library, CI/CD (GitHub Actions)
- **Symptom**: Test passes locally, fails intermittently in CI (30% failure rate)
- **Severity**: Medium (blocks deployments)
- **Traditional Debug Time**: 3-5 hours (reproduce, add delays, investigate race conditions)
- **With Claude**: 10 minutes

### Initial Problem Report

**Developer:**
```bash
# CI test failure log
claude "This test passes locally but fails randomly in CI. What's the race condition?" \
  --files="src/components/UserProfile.test.tsx"
```

**Test Code:**
```typescript
describe('UserProfile', () => {
  it('should display user data after loading', async () => {
    // Mock API
    const mockUser = { id: 1, name: 'John Doe' };
    fetchUser.mockResolvedValue(mockUser);
    
    render(<UserProfile userId={1} />);
    
    // Wait for name to appear
    const nameElement = screen.getByText('John Doe');
    expect(nameElement).toBeInTheDocument();
    
    // Check loading state is gone
    expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
  });
});
```

**CI Error:**
```
TestingLibraryElementError: Unable to find an element with text: John Doe

<div>
  <div>Loading...</div>
</div>
```

### Claude's Analysis

**Claude:**
```
🔴 **Race Condition: Test doesn't wait for async operation**

**The Problem:**
Line 9: `screen.getByText('John Doe')` executes IMMEDIATELY after render.

Flow:
1. Component renders → shows "Loading..."
2. Test runs getByText('John Doe') ← FAILS (data not loaded yet)
3. Component fetches data (async)
4. Component re-renders with "John Doe" ← Too late, test already failed

**Why it works locally but fails in CI:**
- Local machine: Faster, more resources, mock resolves quickly (race condition doesn't surface)
- CI: Slower, shared resources, mock takes longer → race condition exposed

**The Fix:**
Use `findByText` (async) instead of `getByText` (sync):

```typescript
// ❌ Wrong: getByText is synchronous
const nameElement = screen.getByText('John Doe');

// ✅ Correct: findByText waits up to 1000ms
const nameElement = await screen.findByText('John Doe');
```

**Full corrected test:**
```typescript
describe('UserProfile', () => {
  it('should display user data after loading', async () => {
    const mockUser = { id: 1, name: 'John Doe' };
    fetchUser.mockResolvedValue(mockUser);
    
    render(<UserProfile userId={1} />);
    
    // ✅ Wait for name to appear (async)
    const nameElement = await screen.findByText('John Doe');
    expect(nameElement).toBeInTheDocument();
    
    // ✅ Loading should be gone by now
    expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
  });
});
```

**Testing Library Query Cheat Sheet:**
```
getBy*:    Synchronous, throws if not found → Use for already-rendered content
queryBy*:  Synchronous, returns null if not found → Use for asserting absence
findBy*:   Async, waits up to 1000ms → Use for content that loads asynchronously
```
```

### Developer Follow-up

**Developer:** "Should I just add a setTimeout to make it work?"

**Claude:**
```
❌ **No! Never use setTimeout in tests**

// ❌ Bad: Brittle, slow, still flaky
await new Promise(resolve => setTimeout(resolve, 1000));
const nameElement = screen.getByText('John Doe');

Problems:
1. Fixed delay (1000ms) might not be enough in slow CI
2. Wastes time in fast environments
3. Doesn't actually wait for the right condition
4. Test fails if timing changes

// ✅ Good: Wait for actual condition
const nameElement = await screen.findByText('John Doe');

Benefits:
1. Waits only as long as needed (could be 10ms)
2. Retries automatically up to timeout
3. Fails fast if something is broken
4. Self-documenting (waiting for specific element)
```

### Additional Issues Found

**Developer:** "Any other flaky patterns in this test file?"

**Claude reviewed the full file:**

```
Found 3 more flaky patterns:

🟡 **Issue 1: Missing async/await on user event**
```typescript
// ❌ Flaky
userEvent.click(screen.getByRole('button', { name: 'Save' }));
expect(screen.getByText('Saved!')).toBeInTheDocument();

// ✅ Stable
await userEvent.click(screen.getByRole('button', { name: 'Save' }));
await screen.findByText('Saved!');
```

🟡 **Issue 2: Not waiting for disappearance**
```typescript
// ❌ Flaky
fireEvent.click(deleteButton);
expect(screen.queryByText('Item')).not.toBeInTheDocument();

// ✅ Stable
fireEvent.click(deleteButton);
await waitForElementToBeRemoved(() => screen.queryByText('Item'));
```

🟡 **Issue 3: Testing implementation details**
```typescript
// ❌ Flaky (depends on internal state)
expect(wrapper.find('UserProfile').state('loading')).toBe(false);

// ✅ Stable (test what users see)
expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
expect(screen.getByText('John Doe')).toBeInTheDocument();
```
```

### Outcome

✅ **Fixed:**
- Changed getByText → findByText for async content
- Added await to userEvent interactions
- Used waitForElementToBeRemoved for deletions
- Removed implementation detail tests

📊 **Results:**
- Before: 30% CI failure rate
- After: 0% CI failure rate over 50 runs

⏱️ **Time Saved:**
- Traditional: 3-5 hours (reproduce, debug timing, trial-and-error)
- With Claude: 10 minutes
- **Savings: 18-30x faster**

💰 **Cost:** $0.06 (Sonnet 4.5)

📚 **Lessons Learned:**
1. Use `findBy*` for async content, never `getBy*`
2. Never use setTimeout in tests
3. Always await user interactions
4. Use `waitForElementToBeRemoved` for deletions
5. Test user-visible behavior, not implementation
6. Flaky tests usually indicate real timing issues in code
7. CI is slower than local - exposes race conditions

---

## Session 6: Memory Leak in Node.js Service

**Context:**
- **Tech Stack**: Node.js 20, Express, WebSocket (ws library)
- **Symptom**: Memory usage grows from 100MB → 2GB over 24 hours, then crashes
- **Severity**: Critical (production crashes)
- **Traditional Debug Time**: 4-8 hours (heap snapshots, profiling, isolation)
- **With Claude**: 25 minutes

### Initial Problem Report

**Developer:**
```bash
# Heap snapshot comparison tool shows growth
claude "Memory leak in production. Heap grows 2GB in 24h. Suspect WebSocket connections.
Here's the server code:" --files="src/server.ts src/websocket.ts"
```

**File: src/websocket.ts**
```typescript
const wss = new WebSocketServer({ server });
const clients = new Map();

wss.on('connection', (ws, req) => {
  const userId = getUserIdFromToken(req);
  
  // Store client
  clients.set(userId, ws);
  
  ws.on('message', (data) => {
    const message = JSON.parse(data);
    handleMessage(userId, message);
  });
  
  ws.on('close', () => {
    console.log(`User ${userId} disconnected`);
    // ⚠️ Problem: Not removing from clients Map
  });
});

// Broadcast to all users
function broadcast(data) {
  clients.forEach((ws) => {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify(data));
    }
  });
}
```

### Claude's Analysis

**Claude:**
```
🔴 **Memory Leak: WebSocket clients never removed from Map**

**The Problem:**
Line 19: On 'close' event, you log disconnection but never remove client from Map.

**Memory Leak Flow:**
1. User connects → added to `clients` Map (memory +1KB per client)
2. User disconnects → 'close' event fires
3. Log message printed
4. **But client stays in Map** ← LEAK
5. WebSocket object can't be garbage collected (Map holds reference)
6. Repeat 1000x per day → 1000 dead connections in memory
7. After 24 hours: 2GB of dead WebSocket objects

**Visual:**
```
Hour 0:  clients Map size: 0,    Memory: 100MB
Hour 1:  clients Map size: 50,   Memory: 150MB  (50 disconnected but not removed)
Hour 6:  clients Map size: 300,  Memory: 400MB  (300 dead connections)
Hour 24: clients Map size: 1200, Memory: 2.1GB  (1200 zombies)
         ↓
       CRASH (out of memory)
```

**Fix:**
```typescript
ws.on('close', () => {
  console.log(`User ${userId} disconnected`);
  clients.delete(userId); // ✅ Remove from Map
});
```

**Additional Issue:**
Line 9: Using userId as key means multiple connections per user will overwrite.
Last connection wins, but old connection still in memory.

**Better Fix:**
```typescript
// Use connection ID, not user ID
const connections = new Map(); // connectionId -> { ws, userId }
let nextConnectionId = 0;

wss.on('connection', (ws, req) => {
  const userId = getUserIdFromToken(req);
  const connectionId = nextConnectionId++;
  
  // Store with unique connection ID
  connections.set(connectionId, { ws, userId });
  
  ws.on('message', (data) => {
    const message = JSON.parse(data);
    handleMessage(userId, message);
  });
  
  ws.on('close', () => {
    connections.delete(connectionId); // ✅ Remove by connection ID
    console.log(`Connection ${connectionId} (user ${userId}) closed`);
  });
  
  ws.on('error', (error) => {
    connections.delete(connectionId); // ✅ Also remove on error
    console.error(`Connection ${connectionId} error:`, error);
  });
});

// Broadcast to all connections
function broadcast(data) {
  connections.forEach(({ ws }) => {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify(data));
    }
  });
}
```
```

### Developer Question

**Developer:** "How do I verify the leak is fixed without waiting 24 hours?"

**Claude:**
```typescript
// Add monitoring endpoint
app.get('/health/connections', (req, res) => {
  const stats = {
    totalConnections: connections.size,
    memoryUsage: process.memoryUsage(),
    uptime: process.uptime(),
    connections: Array.from(connections.entries()).map(([id, { userId }]) => ({
      id,
      userId
    }))
  };
  res.json(stats);
});

// Test the fix:
// 1. Start server
// 2. Check baseline: curl localhost:3000/health/connections
//    → {"totalConnections": 0, "memoryUsage": {"heapUsed": 10MB}}

// 3. Connect 100 clients (use a script)
// 4. Check: curl localhost:3000/health/connections
//    → {"totalConnections": 100, "memoryUsage": {"heapUsed": 50MB}}

// 5. Disconnect all 100 clients
// 6. Check again: curl localhost:3000/health/connections
//    → {"totalConnections": 0, "memoryUsage": {"heapUsed": 12MB}}
//                            ↑ Back to ~baseline (2MB diff is normal GC)

// If connections still > 0 after disconnect → leak still present
// If heapUsed keeps growing → different leak

// Automated test:
// test/load/websocket-leak.test.js
const WebSocket = require('ws');

test('no memory leak after 1000 connect/disconnect cycles', async () => {
  const baseline = (await fetch('http://localhost:3000/health/connections')).json();
  
  for (let i = 0; i < 1000; i++) {
    const ws = new WebSocket('ws://localhost:3000');
    await new Promise(resolve => ws.on('open', resolve));
    ws.close();
    await new Promise(resolve => ws.on('close', resolve));
  }
  
  // Force GC (run node with --expose-gc)
  if (global.gc) global.gc();
  
  await new Promise(resolve => setTimeout(resolve, 1000)); // Let GC run
  
  const after = (await fetch('http://localhost:3000/health/connections')).json();
  
  expect(after.totalConnections).toBe(0);
  expect(after.memoryUsage.heapUsed).toBeLessThan(baseline.memoryUsage.heapUsed * 1.1); // Within 10%
});
```

### Additional Leaks Found

**Developer:** "Can you check for other leaks in the codebase?"

**Claude analyzed related files:**

```
Found 2 more potential leaks:

🟡 **Leak 2: Event listeners not removed**
```typescript
// src/services/notification.ts

// ❌ Leak: event listener never removed
function subscribe(userId, callback) {
  eventEmitter.on(`user:${userId}`, callback);
}

// ✅ Fix: return unsubscribe function
function subscribe(userId, callback) {
  eventEmitter.on(`user:${userId}`, callback);
  
  return () => {
    eventEmitter.removeListener(`user:${userId}`, callback);
  };
}

// Usage:
const unsubscribe = subscribe(userId, handleNotification);
// Later:
unsubscribe(); // Clean up
```

🟡 **Leak 3: Timers not cleared**
```typescript
// src/services/session.ts

// ❌ Leak: setTimeout never cleared if user disconnects
function extendSession(sessionId) {
  setTimeout(() => {
    expireSession(sessionId);
  }, 24 * 60 * 60 * 1000); // 24 hours
}

// ✅ Fix: store timeout ID and clear on disconnect
const sessionTimers = new Map();

function extendSession(sessionId) {
  // Clear old timer if exists
  if (sessionTimers.has(sessionId)) {
    clearTimeout(sessionTimers.get(sessionId));
  }
  
  const timerId = setTimeout(() => {
    expireSession(sessionId);
    sessionTimers.delete(sessionId);
  }, 24 * 60 * 60 * 1000);
  
  sessionTimers.set(sessionId, timerId);
}

function cancelSession(sessionId) {
  if (sessionTimers.has(sessionId)) {
    clearTimeout(sessionTimers.get(sessionId));
    sessionTimers.delete(sessionId);
  }
}
```
```

### Outcome

✅ **Fixed:**
- Remove WebSocket clients from Map on disconnect
- Use connection IDs instead of user IDs (handle multiple connections)
- Add error handler cleanup
- Fixed event listener leaks
- Cleared timers properly
- Added monitoring endpoint

📊 **Results:**
- Before: 100MB → 2GB over 24 hours
- After: 100MB → 120MB over 24 hours (stable)
- **Memory leak eliminated** ✅

⏱️ **Time Saved:**
- Traditional: 4-8 hours (heap snapshots, profiling, trial-and-error)
- With Claude: 25 minutes
- **Savings: 10-20x faster**

💰 **Cost:** $0.12 (Sonnet 4.5, multiple file analysis)

📚 **Lessons Learned:**
1. Always clean up Map/Set entries when items are removed
2. Event listeners must be removed to prevent leaks
3. Clear timers/intervals when no longer needed
4. Use connection IDs, not user IDs for WebSockets
5. Add monitoring endpoints for memory debugging
6. Test with connect/disconnect cycles, not just long-running connections
7. Run Node.js with `--expose-gc` for memory testing

---

## Session 7: CORS Error in Production Only

**Context:**
- **Tech Stack**: React (frontend), Express (backend), deployed separately
- **Symptom**: API works locally, fails in production with CORS error
- **Severity**: Critical (production down)
- **Traditional Debug Time**: 1-3 hours (check CORS config, headers, domains)
- **With Claude**: 7 minutes

### Initial Problem Report

**Developer:**
```bash
# Browser console error
claude "API works locally but production shows CORS error. Frontend and backend configs:" \
  --files="frontend/src/api/client.ts backend/src/app.ts"
```

**Browser Error:**
```
Access to fetch at 'https://api.example.com/users' from origin 'https://app.example.com' 
has been blocked by CORS policy: Response to preflight request doesn't pass access control check: 
No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

**Backend: src/app.ts**
```typescript
import cors from 'cors';
import express from 'express';

const app = express();

// CORS configuration
app.use(cors({
  origin: 'http://localhost:3000', // ⚠️ Problem here
  credentials: true
}));

app.get('/api/users', (req, res) => {
  res.json({ users: [] });
});

app.listen(4000, () => {
  console.log('Server running on port 4000');
});
```

**Frontend: src/api/client.ts**
```typescript
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:4000';

export async function fetchUsers() {
  const response = await fetch(`${API_URL}/api/users`, {
    credentials: 'include' // ⚠️ Important detail
  });
  return response.json();
}
```

### Claude's Analysis

**Claude:**
```
🔴 **CORS Misconfiguration: Hardcoded localhost origin**

**The Problem:**
Line 7 in backend: `origin: 'http://localhost:3000'`

**Why it works locally:**
Local:
- Frontend: http://localhost:3000
- Backend allows: http://localhost:3000
- ✅ Match!

**Why it fails in production:**
Production:
- Frontend: https://app.example.com
- Backend allows: http://localhost:3000 ← Still hardcoded!
- ❌ No match → CORS blocked

**Additional Issue:**
Preflight (OPTIONS) request failing because:
1. Production frontend sends: Origin: https://app.example.com
2. Backend responds: Access-Control-Allow-Origin: http://localhost:3000
3. Browser: "That's not the origin I sent from!" → Blocks request

**The Fix:**
```typescript
// ✅ Option 1: Multiple origins (recommended)
const allowedOrigins = [
  'http://localhost:3000',           // Local development
  'https://app.example.com',         // Production
  'https://staging.example.com'      // Staging (if applicable)
];

app.use(cors({
  origin: (origin, callback) => {
    // Allow requests with no origin (e.g., mobile apps, Postman)
    if (!origin) return callback(null, true);
    
    if (allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true
}));

// ✅ Option 2: Environment variable
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || 'http://localhost:3000',
  credentials: true
}));

// .env.production:
// ALLOWED_ORIGINS=https://app.example.com,https://staging.example.com

// ✅ Option 3: Dynamic based on environment
app.use(cors({
  origin: process.env.NODE_ENV === 'production' 
    ? 'https://app.example.com' 
    : 'http://localhost:3000',
  credentials: true
}));
```
```

### Developer Question

**Developer:** "Why does OPTIONS request fail specifically?"

**Claude:**
```
**CORS Preflight Explained:**

When you use `credentials: 'include'` or custom headers, browser sends 
a "preflight" OPTIONS request BEFORE the actual request.

**Request Flow:**
```
1. Browser: "Can I make a POST to /api/users from app.example.com?"
   OPTIONS /api/users
   Origin: https://app.example.com
   
2. Server: "Yes, if you're from localhost:3000"
   Access-Control-Allow-Origin: http://localhost:3000  ← Wrong!
   
3. Browser: "That's not my origin!" → BLOCKS REQUEST
   ❌ CORS error
```

**Correct Flow:**
```
1. Browser: "Can I make a POST to /api/users from app.example.com?"
   OPTIONS /api/users
   Origin: https://app.example.com
   
2. Server: "Yes, you (app.example.com) are allowed"
   Access-Control-Allow-Origin: https://app.example.com ✅
   Access-Control-Allow-Credentials: true
   Access-Control-Allow-Methods: GET, POST, PUT, DELETE
   Access-Control-Allow-Headers: Content-Type, Authorization
   
3. Browser: "Great! Proceeding with actual request"
   POST /api/users
   ✅ Request succeeds
```

**Preflight is sent when:**
- credentials: 'include'
- Custom headers (Authorization, etc.)
- Methods other than GET/POST/HEAD
- Content-Type other than application/x-www-form-urlencoded, multipart/form-data, text/plain
```

### Additional Issues Found

**Claude noticed a potential second issue:**

```
🟡 **Potential Issue: Missing HTTPS requirement**

Your production frontend is HTTPS (https://app.example.com).
If backend API is HTTP (http://api.example.com), browsers block it:
"Mixed Content: The page at https://... was loaded over HTTPS, 
but requested an insecure resource http://... This request has been blocked."

**Check:**
1. Is production backend using HTTPS?
2. If behind load balancer, is HTTPS termination configured?

**Fix if needed:**
```typescript
// Force HTTPS in production
if (process.env.NODE_ENV === 'production') {
  app.use((req, res, next) => {
    if (req.header('x-forwarded-proto') !== 'https') {
      return res.redirect(`https://${req.header('host')}${req.url}`);
    }
    next();
  });
}
```
```

### Complete Fixed Configuration

**Claude provided the production-ready config:**

```typescript
// backend/src/app.ts
import cors from 'cors';
import express from 'express';

const app = express();

// ✅ Production-ready CORS configuration
const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',') || [
  'http://localhost:3000',
  'http://localhost:3001'
];

app.use(cors({
  origin: (origin, callback) => {
    // Allow requests with no origin (mobile apps, server-to-server)
    if (!origin) return callback(null, true);
    
    if (allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.warn(`Blocked CORS request from origin: ${origin}`);
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  exposedHeaders: ['X-Total-Count'], // If you use custom response headers
  maxAge: 86400 // Cache preflight for 24 hours
}));

// ✅ HTTPS redirect in production
if (process.env.NODE_ENV === 'production') {
  app.set('trust proxy', 1); // Trust load balancer
  
  app.use((req, res, next) => {
    if (req.header('x-forwarded-proto') !== 'https') {
      return res.redirect(301, `https://${req.header('host')}${req.url}`);
    }
    next();
  });
}

// ✅ Log CORS issues for debugging
app.use((err, req, res, next) => {
  if (err.message === 'Not allowed by CORS') {
    console.error(`CORS blocked: ${req.header('origin')} → ${req.method} ${req.path}`);
    return res.status(403).json({ 
      error: 'CORS not allowed',
      origin: req.header('origin')
    });
  }
  next(err);
});

// Your routes...
app.get('/api/users', (req, res) => {
  res.json({ users: [] });
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Allowed origins: ${allowedOrigins.join(', ')}`);
});
```

**Environment variables:**
```bash
# .env.production (backend)
NODE_ENV=production
ALLOWED_ORIGINS=https://app.example.com,https://staging.example.com
PORT=4000

# .env.production (frontend)
REACT_APP_API_URL=https://api.example.com
```

### Outcome

✅ **Fixed:**
- Configured CORS for production domain
- Used environment variables for flexibility
- Added HTTPS enforcement
- Added preflight caching
- Added CORS error logging

📊 **Results:**
- Production API now accessible from frontend
- CORS errors eliminated
- Proper HTTPS enforcement

⏱️ **Time Saved:**
- Traditional: 1-3 hours (trial-and-error with CORS config)
- With Claude: 7 minutes
- **Savings: 9-26x faster**

💰 **Cost:** $0.05 (Sonnet 4.5)

📚 **Lessons Learned:**
1. Never hardcode origins - use environment variables
2. Whitelist specific origins in production (not wildcard `*` with credentials)
3. Understand preflight OPTIONS requests
4. HTTPS frontend requires HTTPS backend (mixed content)
5. Trust proxy setting needed behind load balancers
6. Cache preflight responses with maxAge
7. Log CORS rejections for debugging
8. Test CORS in staging before production

---

## Key Patterns Across All Sessions

### Pattern 1: Claude Explains "Why", Not Just "What"
Every session showed Claude explaining:
- **What** is broken
- **Why** it's broken
- **How** the bug manifests
- **Why** the fix works

Traditional debugging focuses on "what" - Claude adds crucial context.

### Pattern 2: Iterative Refinement Works
Sessions showed multiple back-and-forth exchanges:
1. Initial analysis (identify problem)
2. Developer asks follow-up (clarify/extend)
3. Claude provides deeper insight or alternative approaches
4. Repeat until fully understood

### Pattern 3: Prevention > Cure
Claude consistently suggested:
- Additional issues in the same area
- Related problems to check
- Best practices to prevent recurrence
- Monitoring/testing to catch early

### Pattern 4: Time Savings Are Exponential
- **Average traditional time**: 1-4 hours per bug
- **Average Claude time**: 5-15 minutes per bug
- **Typical speedup**: 10-30x faster

### Pattern 5: Learning While Debugging
Each session taught concepts:
- Session 1: Async error handling in Express
- Session 2: React effect dependencies
- Session 3: TypeScript type recursion
- Session 4: N+1 query optimization
- Session 5: Testing Library async queries
- Session 6: Memory leak patterns
- Session 7: CORS preflight mechanics

---

## How to Apply These Patterns

### Before Debugging
1. **Gather context** - error messages, stack traces, relevant code
2. **Isolate** - which file/function is involved?
3. **Reproduce** - can you trigger it locally?

### With Claude
1. **Share full context** - paste errors + attach relevant files
2. **Ask specific questions** - "What's the race condition?" not "Fix my code"
3. **Follow up** - ask "why?" to understand, not just copy fixes
4. **Request alternatives** - "Is there a better approach?"
5. **Ask for related issues** - "What else should I check?"

### After Fixing
1. **Test the fix** - verify it actually works
2. **Add tests** - prevent regression
3. **Document learnings** - share with team
4. **Update monitoring** - catch similar issues early

---

## Debugging Prompts to Copy

```bash
# Async/Promise issues
git diff | claude "What promise rejections are unhandled? Suggest error handling."

# Performance regression
git diff main -- src/ | claude "What performance anti-patterns did this introduce?"

# React issues
claude "Why does this React component re-render infinitely?" --files="src/components/MyComponent.tsx"

# Type errors
npm run build 2>&1 | claude "Explain this TypeScript error in simple terms"

# Test flakiness
claude "Why is this test flaky in CI but passes locally?" --files="src/**/*.test.ts"

# Memory leaks
claude "What memory leaks exist in this code? Check Maps, listeners, timers." --files="src/server.ts"

# CORS issues
claude "CORS failing in production but works locally. Check configuration:" --files="backend/src/app.ts frontend/src/api/"

# General debugging
npm test 2>&1 | claude "Debug this test failure - explain root cause and fix"
```

---

**Next:** [Section 18: Team Collaboration →](18-team-collaboration.md)  
**Related:** [Section 21: Troubleshooting Decision Tree →](../07-reference-troubleshooting/21-troubleshooting.md)


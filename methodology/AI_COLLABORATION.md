# Development Methodology: AI Collaboration Best Practices

**Last Updated**: 2025-12-15
**Purpose**: Document proven development practices and AI collaboration strategies
**Keywords**: AI collaboration, AI開発, methodology, 開発手法, best practices, ベストプラクティス, development workflow, 開発ワークフロー, prompt engineering, プロンプトエンジニアリング, iterative development, 反復開発, AI assistant, AI補助, pair programming, ペアプログラミング, battle-tested, 実証済み, upfront design, 事前設計, specification, 仕様, TDD, test-driven development, テスト駆動開発, code generation, コード生成, LLM, workflow, ワークフロー, quality, 品質, accelerated development, 高速開発, sustainable pace, 持続可能なペース, predictable outcomes, 予測可能な結果, energy preservation, エネルギー保存
**Related**: @DESIGN_PHILOSOPHY.md, @../context/coding/TESTING.md, @../context/coding/CONVENTIONS.md

---

## [Target] Overview

This document captures battle-tested development methodologies derived from real-world projects (primarily KakeiBon, which achieved 525 tests with 100% success rate). These practices enable:

- **Accelerated development**: 10-100x faster than traditional estimates
- **High quality**: Minimal bugs, rare specification changes
- **Sustainable pace**: Energy preservation through strategic choices
- **Predictable outcomes**: Accurate time estimates based on experience

---

## [Build]️ Core Principles

### 1. Thorough Upfront Design

**Philosophy**: Invest heavily in design before implementation.

**Why it works**:
- Clear specifications → AI generates correct code
- Minimal hand-back (specification changes)
- Reduced debugging time
- Faster overall delivery

**Implementation**:
```
Design phase: Hours to days
  ↓
Implementation phase: Minutes to hours
  ↓
Total time: Less than "code first, design later" approach
```

**KakeiBon evidence**:
- Specification changes: Almost none
- Major refactoring: None (only modularization)
- Debugging sessions: Rare (mostly when fatigued)

---

### 2. Immediate Refactoring ("See It, Fix It")

**Philosophy**: When you see duplication or improvement opportunity, refactor immediately (not "later").

**Traditional approach (deferred)**:
```
See duplication → Mark as TODO → Continue coding
  ↓
Technical debt accumulates
  ↓
"Later" never comes or becomes expensive
```

**This approach (immediate)**:
```
See duplication → Stop → Extract to module → Continue
  ↓
No technical debt
  ↓
Codebase stays clean
```

**Granularity**: Any size (1 line to 100+ lines)
- If `cost of extraction < cost of maintaining duplication` → Extract immediately
- No size is too small or too large

**Applies to**:
- Code logic
- UI components
- CSS classes
- Modal structures
- Validation patterns
- **Anything that appears more than once**

---

### 3. Strategic Commonalization (AI Variation Absorption)

**Core insight**: AI is probabilistic → Output variations are inherent to the technology, not bugs.

#### The Problem
```
Same prompt: "Create a modal dialog"
  ↓ (Probabilistic AI)
Output A: <div class="modal-dialog">...
Output B: <div class="modal-popup">...
Output C: <div class="custom-modal">...
  ↓
Endless checking and fixing
```

#### The Solution
```
1. Identify variation patterns
   - Modal structures vary
   - CSS class names vary
   - Button layouts vary

2. Create common modules
   - Modal class (standardized)
   - CSS standards (consistent naming)
   - Component templates (reusable)

3. Instruct AI to use common modules
   - "Use the Modal class from modal.js"
   - Variations absorbed by module
   - Checking burden minimized
```

#### Energy Preservation
- ✅ Spend energy on: Strategic commonalization, core logic, design
- ❌ Don't spend energy on: Checking AI variations, fixing cosmetic differences

#### Real-world validation
- **KakeiBon**: 525 tests, 100% success rate
- **How**: Modal class, validation helpers, CSS standards absorbed all variations

---

### 4. Constants Externalization

**Philosophy**: All literal values must be defined as constants in external modules.

#### Why Externalize (Not Just Define)

**❌ Bad - Constants in same file**:
```rust
// src/services/user_management.rs
const MIN_PASSWORD_LENGTH: usize = 16;  // Local constant

pub fn validate_password(password: &str) -> Result<()> {
    if password.len() < MIN_PASSWORD_LENGTH { ... }
}
```

**✅ Good - Constants in external module**:
```rust
// src/validation.rs (external module)
pub const MIN_PASSWORD_LENGTH: usize = 16;

// src/services/user_management.rs
use crate::validation::MIN_PASSWORD_LENGTH;

pub fn validate_password(password: &str) -> Result<()> {
    if password.len() < MIN_PASSWORD_LENGTH { ... }
}
```

#### Benefits

1. **Reusability**: Multiple modules can reference the same constant
2. **Consistency**: Frontend and backend can share values (via parallel definitions)
3. **Dependency clarity**: `use` statements show dependencies explicitly
4. **Change impact**: Modify in one place, effect everywhere
5. **AI instruction clarity**: "Use MIN_PASSWORD_LENGTH from validation.rs"

#### Module Organization (KakeiBon example)

```
src/consts.rs           → Role constants (ROLE_ADMIN, ROLE_USER)
src/sql_queries.rs      → ALL SQL queries
src/validation.rs       → Validation constants and logic

res/js/consts.js        → Frontend constants
res/tests/validation-helpers.js → Test validation logic
```

---

### 5. SQL Queries Centralization

**Philosophy**: ALL SQL queries must be defined as constants in `sql_queries.rs`.

#### This is NOT about code reuse

**Common misconception**: "Centralize SQL for reuse"
- Reality: Each SQL query is often unique
- Actual reuse rate: Moderate

**True reason**: Separation of Concerns + Cognitive Load Reduction

#### The Real Problem: Context Switching

**❌ SQL scattered across files**:
```rust
// src/services/user_management.rs
sqlx::query("SELECT * FROM USERS WHERE USER_ID = ?")...

// src/services/category.rs
sqlx::query("UPDATE CATEGORY2 SET NAME = ? WHERE CODE = ?")...

// src/services/transaction.rs
sqlx::query("INSERT INTO TRANSACTIONS (...) VALUES (?, ?, ?)")...
```

**When implementing business logic**:
```
Thinking about user workflow
  ↓
Need SQL → Write SQL syntax → Think about columns, types
  ↓ (Context switch!)
Lost train of thought about business logic
  ↓
Cognitive load increases, energy drains
```

**✅ SQL centralized in sql_queries.rs**:
```rust
// src/sql_queries.rs
pub const USER_SELECT_BY_ID: &str = "SELECT * FROM USERS WHERE USER_ID = ?";
pub const CATEGORY2_UPDATE: &str = "UPDATE CATEGORY2 SET NAME = ? WHERE CODE = ?";
pub const TRANSACTION_INSERT: &str = "INSERT INTO TRANSACTIONS (...) VALUES (?, ?, ?)";

// src/services/user_management.rs
use crate::sql_queries::USER_SELECT_BY_ID;

pub async fn get_user(&self, id: i64) -> Result<User> {
    // Focus on business logic only
    sqlx::query_as(USER_SELECT_BY_ID)
        .bind(id)
        .fetch_one(&self.pool)
        .await
}
```

**When implementing business logic**:
```
Thinking about user workflow
  ↓
Need SQL → Use pre-defined constant
  ↓ (No context switch!)
Continue thinking about business logic
  ↓
Cognitive flow maintained, energy preserved
```

#### Benefits for Humans

1. **Thought concentration**: Think about logic OR SQL, not both simultaneously
2. **Search efficiency**: "Where's that SQL?" → Open sql_queries.rs (done)
3. **Energy preservation**: No file-hopping, no mental fatigue
4. **Review efficiency**: Security review = check one file

#### Benefits for AI (Same Principle!)

**Your insight**: "This is probably the same for AI"

**AI context management**:
```
SQL scattered:
- Read user_management.rs → See SQL A
- Read category.rs → See SQL B
- Need CATEGORY2 syntax? → Search through context
  ↓
Context thrashing, increased tokens

SQL centralized:
- Read sql_queries.rs → All SQL loaded
- Read user_management.rs → See `use sql_queries::USER_SELECT`
- Need CATEGORY2 syntax? → Immediate reference
  ↓
Clean context, reduced tokens
```

**AI instruction clarity**:
```
❌ Vague: "Write an update query for Category2"
  → AI invents SQL syntax (may vary)

✅ Clear: "Use CATEGORY2_UPDATE from sql_queries.rs"
  → AI uses exact constant (no variation)
```

#### Separation of Concerns

```
Business Logic Files: Focus on workflow, data transformation, error handling
SQL Definitions File: Focus on data access patterns, query optimization

Never mix: Business logic AND SQL syntax in the same mental space
```

---

### 6. Minimal Intervention in AI-Generated Code

**Philosophy**: Trust AI output, intervene only for structural quality.

#### Intervention Policy

**✅ Always intervene**:
1. Constants externalization
2. Common module extraction

**⚠️ Sometimes intervene** (context-dependent):
- CSS units (px → em) for frontend
- UI/UX adjustments (AI's weak area)
- Accessibility improvements

**❌ Never intervene** (unless explicitly broken):
- Code style preferences ("I'd write it differently")
- Minor optimizations ("This could be 5% faster")
- Cosmetic refactoring ("Let's rename this variable")

#### Why This Works

**Prerequisite**: Clear specifications
```
Clear spec + AI implementation = Functionally correct code
  ↓
"Preference-based" changes are waste of energy
  ↓
Focus on structural quality instead
```

#### Frontend vs Backend

**Frontend (UI)**: More intervention needed
```
Reason: UI is AI's weak area
Intervention: Visual adjustments, UX improvements
```

**Backend (Logic)**: Minimal intervention
```
Reason: Logic is AI's strong area
Intervention: Constants, modules only
```

#### Energy Trade-off

```
❌ Traditional approach:
Generate → Review → Nitpick → Regenerate → Review → ...
  ↓
Energy drain, diminishing returns

✅ This approach:
Generate → Structural fixes only → Done
  ↓
Energy preserved for design and strategy
```

---

### 7. Test-Driven AI Collaboration

**Philosophy**: Implement functionality, then immediately generate tests.

#### The Workflow

```
1. You: "Implement feature X"
   ↓
2. AI: Generates code
   ↓
3. You: "Create test cases for this feature"
   ↓
4. AI: Generates tests
   ↓
5. AI: "Should I run the tests?" (AI often asks)
   ↓
6. You: "Yes, run them"
   ↓
7. AI: Runs tests → Detects errors
   ↓
8. AI: Self-corrects (without human intervention)
   ↓
9. You: Verify final result only
```

#### Why "Immediately" Matters

**❌ Batch testing (implementation first)**:
```
Implement A → Implement B → Implement C → Test all
  ↓
Problems:
- Hard to isolate which feature has bugs
- AI's context about A is stale
- Complex debugging session
```

**✅ Immediate testing**:
```
Implement A → Test A → Fix A (if needed) → Done
Implement B → Test B → Fix B (if needed) → Done
  ↓
Benefits:
- Easy isolation of problems
- AI's context is fresh
- Simple, focused fixes
```

#### Tests as Objective Specifications

**Human explanation** (subjective):
```
"Create a user update function"
  ↓
AI interprets (may vary)
```

**Test cases** (objective):
```rust
assert_eq!(updated_user.name, "NewName");
assert!(updated_user.update_dt.is_some());
  ↓
AI sees exact success criteria (no ambiguity)
```

#### AI Self-Correction Trigger

**Key insight**: Test generation triggers AI self-review.

```
Code generation only:
AI: "Implemented as specified" (no verification)

Code + Test generation:
AI: "Let me verify against tests... wait, there's a bug!"
  ↓
Self-correction without human prompting
```

#### When Self-Correction Happens

**Your observation**: "Self-correction happens most often right after test implementation"

**Pattern**:
```
AI generates tests
  ↓
AI reviews own code against test expectations
  ↓
AI: "Oh, I forgot to update UPDATE_DT"
  ↓
AI: Corrects immediately
  ↓
You: (no intervention needed)
```

#### AI's "Should I run tests?" Pattern

**Why AI asks**:
- Learned pattern: test generation → test execution
- Predicts next logical step
- Seeks confirmation

**Why you say "Yes"**:
- Triggers AI self-correction loop
- Minimizes human intervention
- Maximizes efficiency

#### Not Always 100%, But Eventually Correct

**Your insight**: "AI output isn't always 100% on first try, but it often self-corrects"

```
Initial output: 80-90% correct (often has minor bugs)
  ↓
Test generation: AI reviews own code
  ↓
Self-correction: → 95-100% correct
  ↓
Test execution: Final verification
  ↓
Result: High quality without human debugging
```

**Key point**: Focus on results, not process perfection.

#### Real-World Example: Promps Phase 0-1 Testing

**Context**: After completing Phase 1 (Tauri + Blockly.js GUI), tests were implemented immediately before moving to Phase 2.

**Timeline**:
```
Day 1, Session 1:
  - Implemented Phase 1 features (Blockly integration, real-time preview)
  - Phase 1 marked as "complete" based on manual testing

Day 1, Session 2:
  - User: "Let's implement tests before Phase 2"
  - Created frontend tests: Jest + JSDOM (21 tests)
  - Created backend integration tests: Rust (11 tests)
  - Tests revealed critical design issue
```

**The Discovery**:
```
Test expectation:
  Input:  "_N:User _N:Order"
  Output: "User (NOUN) が Order (NOUN) を 作成"
           ↑               ↑
           Two separate noun markers expected

Actual output:
  "User Order (NOUN)"
   ↑
   Only ONE marker for entire sentence

Problem identified:
  Implementation was sentence-level, but requirement was token-level
```

**User's Real-World Example**:
```
Japanese: "_N:タコ と _N:イカ を 食べる"
Expected: "タコ (NOUN) と イカ (NOUN) を 食べる"
          ↑               ↑
          Each noun marked individually

Why this matters:
  - Multiple nouns in one sentence are common in Japanese
  - Each noun needs explicit marking for AI understanding
  - Sentence unity must be preserved (no double-space split)
```

**Refactoring Impact**:
```
Files modified:
  - src/lib.rs: Complete parse_input() refactoring
  - src/lib.rs: Modified generate_prompt() output format
  - src/commands.rs: Updated 11 integration tests
  - docs/*: Updated 6 documentation files

Code change magnitude:
  - Core algorithm: ~50 lines changed
  - Test expectations: ~20 lines updated
  - Documentation: ~30 sections updated

Time to fix:
  - Discovery to completion: ~45 minutes
  - All 42 tests passing at 100%
```

**What If Tests Were Deferred?**:
```
Without immediate testing:
  Phase 1 → Phase 2 (add more block types)
    ↓
  Phase 3 → Phase 4 (implement more features)
    ↓
  Phase N (finally add tests)
    ↓
  Discover sentence-level doesn't work
    ↓
  Must refactor ALL phases retroactively
    ↓
  Estimated impact: Days to weeks of rework

With immediate testing:
  Phase 1 → Tests (catch issue immediately)
    ↓
  Fix before Phase 2
    ↓
  Estimated impact: 45 minutes
    ↓
  Time saved: Multiple days of debugging and rework
```

**The Key Insight**:
```
User quote: "リアルタイムでテストケースを実装して良かったです。
             これで後続Phaseにて変なバグに悩まされずに済みます。
             これがテストケースを早いうちに実装するパワーとメリットですね。"

Translation: "It was good to implement test cases in real-time.
              This way we won't be troubled by weird bugs in subsequent phases.
              This is the power and merit of implementing test cases early."
```

**Quantitative Evidence**:
```
Test coverage achieved:
  - Backend: 21 tests (lib.rs + commands.rs)
  - Frontend: 21 tests (blockly-config.js + main.js)
  - Total: 42 tests at 100% passing

Types of bugs caught:
  1. Sentence-level vs token-level mismatch (critical)
  2. Output format inconsistency (moderate)
  3. Mock setup issues in frontend tests (minor)

Prevention value:
  - Phase 2+ development: Safe to proceed
  - Confidence level: High (42 tests covering core behavior)
  - Technical debt: Zero (fixed before it accumulated)
```

**Application to Other Projects**:
```
When to implement tests:
  ✅ Immediately after completing a phase
  ✅ Before adding features that depend on current implementation
  ✅ When manual testing shows "it works" but behavior isn't validated

What to test:
  ✅ Core algorithms (parse_input, generate_prompt)
  ✅ Integration points (Tauri commands, UI logic)
  ✅ Edge cases (multiple nouns, empty input, special characters)

Expected outcomes:
  ✅ Design issues discovered early (before they compound)
  ✅ Refactoring is surgical (not architectural)
  ✅ Development speed increases (no mystery bugs later)
```

**Comparison with KakeiBon**:
```
KakeiBon: 525 tests, 100% success
  - Strategy: Test after each feature
  - Result: Minimal specification changes, rare bugs

Promps: 42 tests (so far), 100% success
  - Strategy: Test after Phase 1 (before Phase 2)
  - Result: Critical design issue caught immediately
  - Time saved: Days of potential rework

Common pattern:
  Immediate testing → Early bug detection → Exponential time savings
```

---

### 8. Three-Layer PDCA Cycles

**Philosophy**: Three parallel PDCA cycles operating at different speeds create exponential acceleration.

#### Traditional Development: Single-Layer PDCA

```
Human-driven PDCA only:
Plan → Do → Check → Act → (repeat)
  ↓
Speed: Days to weeks per cycle
Scale: Linear progress
```

#### This Methodology: Three-Layer PDCA

```
Layer 1: AI-driven PDCA     (seconds to minutes)
Layer 2: Human-driven PDCA  (minutes to hours)
Layer 3: Human+AI PDCA      (hours to days)
  ↓
Three cycles running concurrently
  ↓
Exponential acceleration through compound effect
```

---

#### Layer 1: AI-Driven PDCA (Seconds to Minutes)

**Cycle**:
```
Plan:   Understand specification, decide implementation approach
Do:     Generate code
Check:  Generate tests → Run tests → Detect errors
Act:    Self-correct
  ↓
Next Plan: Verify corrected version
```

**Example**:
```
You: "Implement Category2 update function"
  ↓
AI-PDCA Cycle 1:
  Plan:  Write UPDATE statement
  Do:    Generate code
  Check: "Oh, forgot UPDATE_DT"
  Act:   Add UPDATE_DT update
  ↓
AI-PDCA Cycle 2:
  Plan:  Verify corrected version
  Do:    Generate tests
  Check: Run tests → All pass
  Act:   Done
```

**Characteristics**:
- **Speed**: Seconds to minutes
- **Autonomy**: No human intervention needed
- **Frequency**: 5-20 cycles per feature

---

#### Layer 2: Human-Driven PDCA (Minutes to Hours)

**Cycle**:
```
Plan:   "Next, implement this feature"
Do:     Instruct AI
Check:  Review AI output (test results, etc.)
Act:    Request constants externalization, modularization
  ↓
Next Plan: "Now implement next feature"
```

**Example**:
```
You-PDCA Cycle 1:
  Plan:  "Need user management"
  Do:    Instruct AI to implement
  Check: Review test results → OK
  Act:   "Extract SQL to sql_queries.rs"
  ↓
You-PDCA Cycle 2:
  Plan:  "Next, category management"
  Do:    Instruct AI to implement
  Check: ...
```

**Characteristics**:
- **Speed**: Minutes to hours
- **Role**: Direction, structural quality assurance
- **Frequency**: 10-50 cycles per session

---

#### Layer 3: Human+AI PDCA (Hours to Days)

**Cycle**:
```
Plan:   Overall design, architecture decisions (Human)
Do:     Multiple feature implementations (AI + Human direction)
Check:  Integration tests, overall verification (Human + AI)
Act:    Refactoring, commonalization (Human decision + AI implementation)
  ↓
Next Plan: Design next phase
```

**Example (KakeiBon aggregation features)**:
```
Human+AI-PDCA (Overall):
  Plan:  "Need 5 aggregation features"
         "Feature 1 builds foundation, others reuse"
  Do:    Feature 1: 5-6 hours (foundation)
         Features 2-3: Gradual speedup
         Features 4-5: 10 minutes (reuse)
  Check: All features tested → Integration verified
  Act:   Extract common modules, constants
  ↓
Next Plan: "Now implement reports feature"
```

**Characteristics**:
- **Speed**: Hours to days
- **Role**: Overall strategy, learning curve utilization
- **Frequency**: 5-20 cycles per project

---

#### Nested Structure and Compound Acceleration

```
Layer 3 (Human+AI) - 1 cycle
  │
  ├─ Layer 2 (Human) - Multiple cycles
  │    │
  │    ├─ Layer 1 (AI) - Many cycles
  │    ├─ Layer 1 (AI) - Many cycles
  │    └─ Layer 1 (AI) - Many cycles
  │
  └─ Layer 2 (Human) - Multiple cycles
       │
       └─ Layer 1 (AI) - Many cycles
```

**Compound effect**:
- Layer 1 fast → Layer 2 accelerates
- Layer 2 fast → Layer 3 accelerates
- **Result**: Exponential speed improvement

---

#### Learning Curve Acceleration

**Feature 1 (5-6 hours)**:
```
Layer 3: Architecture design
Layer 2: Foundation module creation
Layer 1: Implementation + trial/error + self-correction
  ↓
Slow because:
- No foundation exists
- Patterns not established
- Exploring commonalization opportunities
```

**Feature 5 (10 minutes)**:
```
Layer 3: (Architecture already established)
Layer 2: "Same pattern as Feature 4"
Layer 1: Reuse existing modules
  ↓
Fast because:
- Foundation exists
- Patterns established
- Rich common modules available
```

**Time progression**:
```
Feature 1: 6 hours
Feature 2: 3 hours
Feature 3: 1.5 hours
Feature 4: 30 minutes
Feature 5: 10 minutes
  ↓
Exponential decay (learning curve)
```

---

#### Prediction Accuracy

**Case Study: KakeiBon 5 Aggregation Features**

| Source | Total Estimate | Per Feature | Actual Result |
|--------|---------------|-------------|---------------|
| Copilot | 2 months | ~80 hours | - |
| You | 10-15 hours | 2-3 hours | 7.5 hours |
| Actual | - | - | **1.5 hours avg** |

**Why Copilot was off**:
```
Assumption: Traditional single-layer PDCA
  ↓
Linear time accumulation per feature
  ↓
5 features × 80 hours = 400 hours (2 months)
```

**Why you were accurate**:
```
Understanding: Three-layer PDCA + commonalization
  ↓
Exponential acceleration via learning curve
  ↓
First feature slow, later features fast
  ↓
Average: 1.5 hours (actual was even better than estimate!)
```

**Why actual beat your estimate**:
- Reuse was more effective than expected
- AI self-correction worked better than anticipated
- Common modules more powerful than predicted

---

#### Synergy with Other Methodologies

**1. Thorough upfront design**:
```
Effect: Layer 3 Plan is solid
  ↓
Layer 2 and 1 have clear direction
  ↓
Eliminate wasteful cycles
```

**2. Constants externalization & modularization**:
```
Effect: Each cycle's output is reusable
  ↓
Subsequent cycles accelerate
  ↓
Steep learning curve
```

**3. AI self-correction**:
```
Effect: Layer 1 completes without human intervention
  ↓
Layer 2 cycles speed up
  ↓
Layer 3 overall speed increases
```

**4. Immediate testing**:
```
Effect: Each cycle's Check is reliable
  ↓
Act direction is accurate
  ↓
No backtracking → Overall acceleration
```

---

#### Application to Promps Development

**Phase 0 (CLI)**: 1 hour completion

```
Copilot estimate: Several hours to days
Your estimate: ~1 hour
Actual: ~1 hour
  ↓
Three-layer PDCA in action:
- Layer 3: Design philosophy already documented
- Layer 2: Clear incremental tasks
- Layer 1: AI rapid implementation + self-correction
```

**Phase 1 (GUI)**: Predicted 2-3 hours

```
Layer 3: Blockly.js integration design
Layer 2: Component-by-component implementation
Layer 1: AI handles details + self-corrects
  ↓
Likely actual: 2-3 hours (your prediction will be accurate)
```

**Phase N (Logic Check)**: Predicted days to 1 week

```
Pattern 1-10: Hours (foundation building)
Pattern 11-50: Gradual speedup
Pattern 51-100: Minutes (reuse)
  ↓
Copilot estimate: Weeks to months
Your estimate: Days to 1 week
Likely actual: Your estimate (based on KakeiBon evidence)
```

---

## [Target] Integrated Workflow Example

Here's how all methodologies work together in practice:

### Scenario: Implement New Feature "X"

**Phase 1: Upfront Design** (Layer 3 Plan)
```
You: [30 minutes of design thinking]
- Feature purpose and specifications
- Data structures
- Edge cases
- Integration points
```

**Phase 2: Initial Implementation** (Layer 2 + Layer 1)
```
You: "Implement feature X with these specs..."
  ↓
AI (Layer 1 PDCA):
  Plan: Understand requirements
  Do: Generate code
  Check: "Hmm, edge case not handled"
  Act: Fix edge case
  ↓
You (Layer 2 Check): Review output
You (Layer 2 Act): "Extract SQL to sql_queries.rs"
  ↓
AI: Extraction done
```

**Phase 3: Immediate Testing** (Layer 1 self-correction trigger)
```
You: "Generate test cases"
  ↓
AI (Layer 1 PDCA):
  Plan: Identify test scenarios
  Do: Generate tests
  Check: Review against implementation
  Act: "Oh, forgot validation check" → Self-correct
  ↓
AI: "Should I run tests?"
You: "Yes"
  ↓
AI: Tests run → All pass
```

**Phase 4: Commonalization** (Layer 2 Act)
```
You: [Spot duplication with Feature Y]
You: "Extract common logic to shared module"
  ↓
AI: Extraction done
  ↓
[Energy preserved, codebase cleaner]
```

**Total time**: 45 minutes
**Traditional estimate**: 4-6 hours
**Acceleration factor**: ~6x

---

## [Chart] Quantitative Evidence

### KakeiBon Project Results

**Development Stats**:
- Total tests: 525 (121 backend + 404 frontend)
- Success rate: 100%
- Major bugs: Near zero
- Specification changes: Almost none
- Refactoring: Commonalization only (no architectural rewrites)

**Speed Achievements**:
- 5 aggregation features: 7.5 hours actual (vs 2 months estimated by Copilot)
- Later features: 10 minutes each (vs 80 hours traditional estimate)
- Average acceleration: **10-100x** faster than traditional estimates

**Prediction Accuracy**:
- Your estimates: Consistently accurate (within 10-20%)
- AI estimates: Often off by 10-50x (assumes traditional development)

### Promps Phase 0 Results

**Development Stats**:
- Implementation time: ~1 hour
- Tests created: 7
- Success rate: 100%
- Specification changes: 1 (flexible noun positioning - caught during development)

**Files Created**:
- Core implementation: ~110 lines
- Documentation: Comprehensive
- Community files: Complete set
- AI context: Extensive design philosophy documentation

---

## [Rocket] Why This Works

### Fundamental Insights

1. **AI is Probabilistic**
   - Output variations are inherent, not bugs
   - Strategy: Absorb variations, don't fight them

2. **AI Can Self-Correct**
   - Condition: Clear specifications + tests
   - Result: High quality without human debugging

3. **Compound Acceleration**
   - Three-layer PDCA creates exponential speedup
   - Learning curve + reuse = dramatic time reduction

4. **Energy Preservation**
   - Focus on strategic decisions
   - Minimize tactical interventions
   - Sustained high performance

### Success Prerequisites

These methodologies work when:
- ✅ Specifications are clear and thorough
- ✅ Tests are generated immediately
- ✅ AI self-correction is trusted (but verified)
- ✅ Common patterns are extracted immediately
- ✅ Energy is consciously preserved

They may not work if:
- ❌ Specifications are vague or changing
- ❌ Testing is deferred or skipped
- ❌ Every AI output is micro-managed
- ❌ Duplication is tolerated "for now"
- ❌ Energy is spent on non-essential details

---

## [Note] Application to New Projects

### For Promps (and Future Projects)

**Phase 1 (GUI)**: Expected 2-3 hours
```
Apply:
- Layer 3: Design Blockly.js integration architecture
- Layer 2: Component-by-component implementation
- Layer 1: AI handles implementation details
- Immediate testing for each component
- Extract common UI modules
```

**Phase N (Logic Check)**: Expected days to 1 week
```
Apply:
- Pattern 1-10: Foundation building (slower)
- Pattern 11+: Exponential acceleration (reuse)
- All patterns in external module
- Comprehensive test suite
- Three-layer PDCA for rapid iteration
```

### General Project Template

**1. Design Phase** (Layer 3 Plan)
- Invest hours to days in thorough design
- Clear specifications, edge cases, constraints
- Document for AI context

**2. Foundation Phase** (Slower, builds acceleration)
- First features take longer
- Extract patterns immediately
- Build common module library

**3. Acceleration Phase** (Exponential speedup)
- Reuse common modules
- Features complete in minutes
- Maintain quality through tests

**4. Completion** (Faster than estimated)
- Later features very fast
- Overall time: 10-100x faster than traditional
- Quality: High (test-verified)

---

## [Desktop]️ The CPU Architecture Analogy: Why This Works

### Perfect Structural Correspondence

The hierarchical task structure with PDCA cycles is not just a methodology—it mirrors **fundamental computer architecture principles** that have been optimized over 70+ years.

---

### CPU Architecture ≡ Task Architecture

**CPU Hierarchy**:
```
Physical CPU (Hardware)
  └─ Physical Cores × N
      └─ Logical Threads (Hyperthreading) × M
          └─ Processes × Many
              └─ Threads × Many
                  └─ Mutex/Semaphore (Synchronization)
```

**Task Hierarchy**:
```
Project (Physical Entity)
  └─ Phases × N
      └─ Features × M
          └─ Layer 2 PDCA × Many
              └─ Layer 1 PDCA × Many
                  └─ Detail Tasks (Synchronization)
```

**Perfect correspondence in structure, behavior, and lifecycle.**

---

### Lifecycle Correspondence

**CPU Process/Thread**:
```
Creation: fork() / pthread_create()
  ↓
Execution: CPU time allocation
  ↓
Termination: exit() / pthread_join()
  ↓
Destruction: Resource release, disappears from memory
```

**PDCA Task**:
```
Creation: Plan (task definition)
  ↓
Execution: Do (implementation)
  ↓
Validation: Check (verification)
  ↓
Adjustment: Act (correction)
  ↓
Completion: Lifetime ends, task disappears
```

**Identical lifecycle management.**

---

### Parallel Processing Principles

**CPU Scheduling**:
```
Physical cores: 4
Logical threads: 8 (Hyperthreading)
  ↓
Concurrent execution: 8 processes
  ↓
When processes > 8:
  - Time slicing
  - Context switching
  - Apparent parallelism
```

**Task Scheduling**:
```
Human: 1 person
Attention resource: Limited
  ↓
Concurrent processing: Several at Layer 2
  ↓
When tasks > capacity:
  - Quick switching
  - Context switching
  - Delegate to AI (Layer 1)

AI: Internal parallelism
  ↓
Apparent parallelism = Dramatically increased
```

---

### The m × n Formula: CPU Performance Model

**CPU Performance**:
```
Cores: n
Threads per core: m
  ↓
Logical parallelism = n × m
  ↓
Example: 4 cores × 2 threads = 8 parallel
```

**Task Processing Performance**:
```
Hierarchy levels: n
Tasks per level: m
  ↓
Processing opportunities = m × n
  ↓
Parallelism ∝ m × n
  ↓
Effective performance = (m × n) × parallel efficiency
```

**Same multiplicative structure.**

---

### Counterintuitive Truth: More PDCA = Faster

**Common Misconception**:
```
More PDCA cycles = Slower processing
Fewer PDCA cycles = Faster processing
```

**Reality** (Same as CPU parallelism):
```
For the same number of tasks:
More PDCA cycles = More parallel opportunities = FASTER
Fewer PDCA cycles = Fewer parallel opportunities = Slower
```

**Why This Works**:

**Pattern A: Flat (Few PDCA)**:
```
25 tasks in 1 large PDCA:

Plan: All 25 tasks
  ↓ (Sequential execution)
Do: Task1 → Task2 → ... → Task25
  ↓ (After all complete)
Check: All 25 tasks
  ↓ (If problems found)
Act: Redo everything

Parallelism: 1 (sequential only)
```

**Pattern B: Hierarchical (Many PDCA)**:
```
25 tasks hierarchically decomposed, PDCA at each level:

Layer 3 (1 PDCA):
  Plan: Overall architecture
  Do: Instruct Layer 2
  Check: Verify Layer 2 results
  Act: Adjust if needed

Layer 2 (5 PDCA, parallel):
  Feature1 PDCA ┐
  Feature2 PDCA ├─ Concurrent!
  Feature3 PDCA │
  Feature4 PDCA │
  Feature5 PDCA ┘

Layer 1 (5 PDCA per feature, parallel):
  SQL definition PDCA    ┐
  Test creation PDCA     ├─ Concurrent!
  Verification PDCA      │
  ...                    ┘

Parallelism: Up to 25 (all tasks can be parallel)
```

---

### Synchronization: Mutex/Semaphore ≡ Dependencies

**CPU Synchronization**:
```c
mutex_lock(&resource);
  // Critical section
  // Other threads wait
mutex_unlock(&resource);

sem_wait(&semaphore);  // Decrement counter
  // Use resource
sem_post(&semaphore);  // Increment counter
```

**Task Synchronization**:
```
Layer 2 TaskA: "Create foundation module" (acquire lock)
  ↓
Layer 2 TaskB: "Use foundation module" (waiting)
  ↓
TaskA complete: Foundation established (release lock)
  ↓
TaskB start: Implement using foundation (parallel execution possible)
```

**Dependencies = Locks/Semaphores**

---

### Hyperthreading ≡ Human+AI Collaboration

**Hyperthreading**:
```
1 physical core
  ↓
2 logical threads (apparent)
  ↓
Actual performance: 1.3-1.5x improvement
  ↓
Reason: Efficient CPU resource utilization
```

**Human+AI Collaboration**:
```
1 human
  ↓
Human + AI (apparent dual entity)
  ↓
Actual performance: 10-100x improvement
  ↓
Reason:
  - Human: Strategy at Layer 2, 3
  - AI: Parallel implementation at Layer 1
  - Optimal resource distribution
```

**AI acts like hyperthreading for performance boost!**

---

### Context Switch Cost

**CPU Context Switch**:
```
Process switching:
  - Register save/restore
  - Cache flush
  - TLB flush
  ↓
Cost: Microseconds to milliseconds
  ↓
Frequent switching = High overhead
```

**Human Task Switch**:
```
Task switching:
  - Thought context save/restore
  - "Where was I?"
  - "What's next?"
  ↓
Cost: Minutes to tens of minutes (cognitive load)
  ↓
Frequent switching = Fatigue and errors
```

**Hierarchical Optimization**:
```
Coarse granularity (Layer 3):
  - Low switching frequency
  - Few context switches

Fine granularity (Layer 1):
  - Processed internally by AI
  - No human switching needed
  ↓
Overhead minimized!
```

---

### Process Hierarchy ≡ PDCA Hierarchy

**Unix Process Tree**:
```
init (PID 1)
  └─ systemd
      └─ apache
          └─ worker process #1
          └─ worker process #2
          └─ worker process #3
              └─ thread pool
```

**PDCA Task Tree**:
```
Project (Layer 3 PDCA)
  └─ Phase 1 (Layer 3 PDCA)
      └─ Feature A (Layer 2 PDCA)
          └─ Task A-1 (Layer 1 PDCA)
          └─ Task A-2 (Layer 1 PDCA)
          └─ Task A-3 (Layer 1 PDCA)
              └─ Subtask details (AI internal)
```

**Parent-child relationships, creation/destruction—all identical!**

---

### Resource Management Correspondence

**CPU Resources**:
```
CPU time: Finite
Memory: Finite
I/O bandwidth: Finite
  ↓
Scheduler optimally allocates
  ↓
Priority control, fairness guarantee
```

**Human Resources**:
```
Attention: Finite
Energy: Finite
Time: Finite
  ↓
Self as scheduler
  ↓
Focus on critical tasks (Layer 3, 2)
Delegate details to AI (Layer 1)
```

**Resource constraints are identical!**

---

### Mathematical Proof of Acceleration

**Sequential Processing (Flat)**:
```
Task count: 25
PDCA count: 1
Parallelism: 1

Processing time = 25 tasks × unit time
                = 25 time units
```

**Parallel Processing (Hierarchical)**:
```
Task count: 25
PDCA count: 25 (each task independent)
Parallelism: 25

Processing time = max(individual task times)
                ≈ 1 time unit (ideally)

Reality: Dependencies exist, so not fully parallel
But: Significant reduction (5-10x)
```

---

### KakeiBon Evidence: Parallelism Evolution

**Feature 1 (Low parallelism)**:
```
Foundation building phase:
  ↓
Many dependencies between tasks
  ↓
Parallelism: ~2-3
  ↓
Time: 6 hours
```

**Features 2-3 (Medium parallelism)**:
```
Pattern establishment phase:
  ↓
Dependencies become clear
  ↓
Parallelism: ~5-8
  ↓
Time: 3 hours → 1.5 hours
```

**Features 4-5 (High parallelism)**:
```
Reuse phase:
  ↓
Nearly independent tasks
  ↓
Parallelism: ~10-15
  ↓
Time: 30 minutes → 10 minutes
```

**Increasing parallelism also contributes to acceleration!**

---

### Complete Acceleration Model: Three Factors

**1. m × n Reduction (Reuse)**:
```
15 → 6 → 4 → 1 → 1
Exponential reduction in work volume
```

**2. Parallelism Increase**:
```
Parallelism: 2 → 5 → 10
Actual time = Work volume / Parallelism
  ↓
Increased parallelism further reduces actual time
```

**3. Synergistic Effect**:
```
Reduction effect = (m × n reduction) × (parallelism increase)
  ↓
Feature 1: 15 / 2 = 7.5 units → 6 hours
Feature 5: 1 / 10 = 0.1 units → 10 minutes
  ↓
75x acceleration! (6 hours → 10 minutes)
```

---

### Why This Analogy is Perfect

**1. Structural Identity**:
```
Physical hierarchy (CPU/Core/Thread)
  ≡
Logical hierarchy (Project/Phase/Feature)
```

**2. Operational Principle Identity**:
```
Parallel execution, scheduling, synchronization
  ≡
Task parallelism, priority control, dependency management
```

**3. Lifecycle Identity**:
```
Create → Execute → Terminate → Destroy
  ≡
Plan → Do → Check → Act → Complete
```

**4. Performance Improvement Mechanism Identity**:
```
Multicore × Hyperthreading
  ≡
Hierarchical × AI collaboration
```

---

### Implications for Understanding

**Why This Matters**:

**1. Intuitive Understanding**:
```
"Works like a CPU"
  ↓
Engineers understand immediately
```

**2. Design Validity Proof**:
```
CPU architecture = 70 years of optimization history
  ↓
Same structure = Fundamentally sound
```

**3. Further Optimization Hints**:
```
CPU optimization techniques:
  - Cache strategies
  - Pipelining
  - Speculative execution
  ↓
Potentially applicable to task processing?
```

---

### For Article Writers: What They Miss

**Misconception 1: "Prompts are simple instructions"**:
```
❌ Prompt = 1 command

✅ Prompt = Process hierarchy
   (Same as CPU process/thread)
```

**Misconception 2: "Context enables automation"**:
```
❌ Context = Magic

✅ Context = OS (scheduling, resource management)
   Prompt = Process (actual processing)
   Both required (OS alone doesn't run programs)
```

**Misconception 3: "More PDCA = Slower"**:
```
❌ More PDCA cycles = More overhead

✅ More PDCA cycles = More parallelism = FASTER
   (Same principle as multicore CPUs)
```

---

### The Deep Insight

**Your methodology = Applying CPU architecture principles to Human+AI collaboration**

This is why:
- 10-100x acceleration is achievable (multicore + hyperthreading effect)
- Predictions are accurate (schedulable like CPU tasks)
- It scales naturally (same principles at any scale)

**The methodology works because it follows proven hardware architecture principles that have been optimized for decades.**

---

## [Graduate] Learning and Evolution

### Continuous Improvement

This methodology itself follows PDCA:

**Plan**: Document current practices
**Do**: Apply to new projects (Promps)
**Check**: Measure results, compare predictions
**Act**: Refine methodologies based on outcomes

### Future Enhancements

Areas for exploration:
- Automated commonalization detection
- AI-driven test generation strategies
- Multi-project pattern libraries
- Quantitative metrics for prediction accuracy

---

**This document captures proven methodologies from real-world development. Results may vary based on project complexity, AI capabilities, and developer experience, but the fundamental principles remain valid across contexts.**

# 🔍 Code Review Checklist

Use this checklist before approving any pull request. Not every item applies to every PR—use judgment based on scope and risk.

---

## 📋 General

- [ ] **PR description is clear and linked to issue/ticket**
  &gt; The description explains *what* changed and *why*. Includes links to relevant tickets, designs, or requirements.

- [ ] **Commits are atomic and messages follow convention**
  &gt; Each commit represents a single logical change. Messages use imperative mood (`Add feature` not `Added feature`) and reference tickets.

- [ ] **Branch is up-to-date with target branch**
  &gt; No merge conflicts. Rebased or merged recently to avoid integration issues.

- [ ] **Changeset size is reasonable (&lt; 400 lines ideally)**
  &gt; Large PRs are harder to review thoroughly. Suggest splitting if excessive.

---

## 🧠 Logic & Correctness

- [ ] **Code handles edge cases and error states**
  &gt; Empty inputs, null values, network failures, timeouts, and race conditions are considered.

- [ ] **No obvious bugs or logic errors**
  &gt; Step through the code mentally. Check boundary conditions, off-by-one errors, and boolean logic.

- [ ] **Async operations handle failures and cancellations**
  &gt; Promises have `.catch()`, async/await uses try/catch, and abort controllers clean up properly.

- [ ] **Resource leaks are prevented**
  &gt; Event listeners removed, intervals cleared, files closed, connections released.

---

## 🏗️ Architecture & Design

- [ ] **Single Responsibility Principle is respected**
  &gt; Functions and classes do one thing well. No god objects or 500-line functions.

- [ ] **Dependencies are appropriate and justified**
  &gt; New libraries are necessary, well-maintained, and licensed compatibly. No left-pad incidents.

- [ ] **API changes are backward compatible or versioned**
  &gt; Breaking changes are documented and follow deprecation policies.

- [ ] **Database migrations are safe and reversible**
  &gt; Migrations don't lock tables for extended periods. Rollback strategy exists.

---

## 🧪 Testing

- [ ] **Unit tests cover new/changed logic**
  &gt; Tests verify behavior, not implementation. Edge cases and error paths included.

- [ ] **Integration tests verify external interactions**
  &gt; Database, API, and service boundaries are tested with realistic fixtures.

- [ ] **Tests are deterministic and isolated**
  &gt; No flaky tests. No shared state between tests. No time-based failures.

- [ ] **Test names describe behavior, not implementation**
  &gt; `it('returns 404 when user not found')` not `it('tests getUser')`.

---

## 🔒 Security

- [ ] **User inputs are validated and sanitized**
  &gt; All external data validated for type, length, format, and range. SQL injection, XSS, and command injection prevented.

- [ ] **Authentication and authorization checks are present**
  &gt; Endpoints verify identity and permissions. No security by obscurity.

- [ ] **Secrets are not hardcoded or logged**
  &gt; No API keys, passwords, or tokens in code. Sensitive data excluded from logs.

- [ ] **Sensitive operations have audit trails**
  &gt; Authentication events, permission changes, and data modifications are logged.

---

## 📊 Performance

- [ ] **No N+1 queries or inefficient algorithms**
  &gt; Database queries use appropriate joins, indexes, and batching.

- [ ] **Large data sets are paginated or streamed**
  &gt; Memory usage stays bounded. No unbounded arrays or string concatenation.

- [ ] **Caching strategy is appropriate**
  &gt; Cache keys are namespaced, TTLs are set, and invalidation is handled.

---

## 📝 Documentation

- [ ] **Code comments explain "why," not "what"**
  &gt; Comments clarify business logic, workarounds, and non-obvious decisions.

- [ ] **README/API docs updated for interface changes**
  &gt; Consumers can understand new behavior without reading source code.

- [ ] **Changelog updated for user-facing changes**
  &gt; Breaking changes, new features, and deprecations are documented.

---

## 🎨 Style & Maintainability

- [ ] **Code follows project style guide (linting passes)**
  &gt; ESLint/Prettier/Black/Rustfmt passes without suppressions.

- [ ] **Variable and function names are descriptive**
  &gt; `isUserActive` not `flag`. `calculateTotalPrice` not `doStuff`.

- [ ] **No commented-out code or debug statements**
  &gt; Clean production code. Debug logs removed or converted to proper logging levels.

- [ ] **Magic numbers and strings are constants**
  &gt; Named constants with context instead of bare literals scattered through code.

---

## ✅ Final Approval

- [ ] **I understand this change and would debug it at 3 AM**
  &gt; If you wouldn't want to be paged for this code, request changes.

- [ ] **CI passes and I verified locally if needed**
  &gt; Green builds. Manual testing performed for UI changes or complex logic.

**Reviewer:** _______________ **Date:** _______________

---
name: Tests
description: Conventions and strategy for writing tests when adding tests, fixing bug regressions, or users ask to test something
---

## Conventions first

Before writing any test: find existing tests for the module, and follow the already-established framework, naming, fixtures, and directory layout. In unfamiliar territory, write new tests next to what exists (e.g. `foo_test.go` beside `foo.go`; `foo.test.ts` in `__tests__/`; pytest under `tests/`). Match assertion style of neighbors.

## Strategy

1. **Test behavior, not implementation** — assert on outputs/results, not internal call sequences.
2. **Cover the change, not everything.** Prioritize: new/changed logic paths, the exact bug being fixed (regression test), edge cases and error paths actually reachable. For a bug fix, the failing-before test is mandatory.
3. **One reason per test.** One arrange-act-assert flow; name it after the behavior: `rejects_expired_token` / "returns 404 when order is missing".
4. **No flaky constructs:** no sleeps/timeouts for ordering, no reliance on wall-clock, network, or cross-test state. Freeze time by injection; mock at the network boundary only.
5. **Minimal fixtures** — build the smallest object needed for the assertion; share construction through helpers, not copy-paste.
6. **Run them.** Run the new tests plus the nearest affected suite with the project's runner. All green before reporting back; if the suite was already failing before your change, report it, do not silently fix unrelated failures.

## Failure handling

When a test fails unexpectedly, apply the `debugging` skill: is the production code wrong, the test wrong, or the assumption wrong? Report any production bug found like any other change.

---
name: tdd
description: Instructions for implementing Test-Driven Development. Use when writing new features or fixing bugs.
---

# Test-Driven Development

Follow the red-green-refactor cycle:

1. Write a failing test that defines the expected behavior.
2. Write the minimal code to make the test pass.
3. Refactor while keeping tests green.

## Rules

* Never write implementation code without a failing test.
* Each cycle adds one small behavior.
* Run tests after every change.

## Test Quality

* Tests define the API UX; write them with the same care as the interface itself.
* Test behavior, not implementation.
* Avoid mocks.
* Avoid brittle tests that break on unrelated changes.
* Avoid test sclerosis: delete tests that slow evolution without catching real bugs.
* No overlapping coverage; if more than one test covers the same use case, keep only one.
* Prefer integration tests; they often replace many redundant unit tests.

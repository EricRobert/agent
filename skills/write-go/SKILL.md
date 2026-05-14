---
name: write-go
description: Rules and recommendations for writing Go code. Use when writing, editing, or reviewing Go code.
---

# Go Guidelines

## Idiomatic Go

Avoid code that:

- feels academic or tutorial-like
- over-abstracted
- over-engineered
- prematurely generalized
- designed around hypothetical misuse

## Small Package Surface

Only export symbols that are truly part of the API.
Prefer unexported symbols.
Avoid adding new top-level symbols with inlining and function literals.
Before adding a new top-level symbol, ask whether it is essential, meaningfully reusable.
Do not split logic into helpers just to make functions simpler.
Avoid one-use helpers, wrappers with no semantic value, and boilerplate.

## Useful Types

Do not introduce types unless they carry real meaning or boundaries.
Avoid unnecessary structs, interfaces, configs, option types, and custom errors.
Prefer passing values directly.
Prefer concrete types over interfaces unless abstraction is clearly needed.

## Useful Errors

Handle errors where they occur, with useful context.
Prefer simple checks and early returns.
Focus on real failure paths, not hypothetical ones.
Avoid speculative guards, excessive pre-validation, and defensive code meant to prevent misuse.
Do not suppress panics that correctly expose broken assumptions.

# Go Naming Conventions

Good names: consistent, short, accurate.
Longer names for wider scope.

## MixedCase

No underscores.
All-caps acronyms: `ServeHTTP`, `IDProcessor`.

## Local Variables

Short: `i`, `r`, `b`.
Avoid redundancy from context: `count` not `runeCount` inside `RuneCount`.

## Parameters

Short when types are descriptive (`d Duration, f func()`).
Longer when ambiguous (`sec, nsec int64`).

## Return Values

Name only for documentation on exported functions: `(written int64, err error)`.

## Receivers

1-2 chars reflecting type, consistent across methods: `(b *Buffer)`, `(sh serverHandler)`.

## Exported Package-Level Names

Qualified by package: `bytes.Buffer` not `bytes.ByteBuffer`.

## Interfaces

Single-method: method + `er` (`Reader`, `Execer`).
Multi-method: describes purpose (`net.Conn`).

## Errors

Types: `FooError`.
Values: `ErrFoo`.

```go
type ExitError struct { ... }
var ErrFormat = errors.New("image: unknown format")
```

## Packages

Names should lend meaning to exports.
Avoid `util`, `common`.
Last path component = package name.
No stutter, no uppercase in paths.

---
name: write-go-cli
description: Instuctions for creating a Go CLI interface. Use when adding or reviewing Go CLI flags or commands.
---

# Go CLI Development

Use package `github.com/lachaloupe/cli`.
It is used to generate command-line interfaces from Go code by inspecting handler signatures and argument structs.

Use `go generate` with `cligen` to auto-generate CLI glue code into `*.cli.go` files.

Handler signatures:

- No args: `func Run(ctx context.Context) error`
- With args: `func Run(ctx context.Context, args Args) error`

Comments on handlers and struct fields are displayed in --help.

## Quick Start

See [main.go](./main.go) for a complete example.
Use as-is when starting a new CLI.

## Directives

| Directive | Meaning |
| --- | --- |
| `//cli:arg` | Make field positional (scalar: 1 value, slice: remaining) |
| `//cli:arg=N` | Positional, consume exactly N values |
| `//cli:required` | Require the argument |
| `//cli:alias=x` | Short/alternate name |
| `//cli:default=value` | Default value (multiple allowed, tried in order) |
| `//cli:enum` | Discover choices from `Strings() []string` |
| `//cli:enum=value` | Add allowed enum choice |
| `//cli:path=...` | Path validation |

## Path Directives

- `exists`, `not-exists`, `dir`, `file`, `mkdir`, `creatable`, `readable`, `writeable`, `symlink`, `abs`, `rel`, `exec`, `clean`, `empty`, `glob`, `.ext`

## Subcommands

```go
var CLI = cli.Command{
	Commands: []*cli.Command{
		{
			Name:    "image",
			Handler: image.RunLs,
		},
		{
			Name:    "container",
			Handler: container.RunRm,
		},
	},
}
```

Each subcommand should be in its own file `cmd-<command>.go` except the root command.

```
cmd/
├── main.go    # root command + CLI definition
├── cmd-foo.go # foo subcommand
├── cmd-bar.go # bar subcommand
└── ...
```

## Context Values

Access parsed args across command tree:

```go
rootArgs := ctx.Value(cli.Args("/")).(RootArgs)
loginArgs := ctx.Value(cli.Args("/login")).(LoginArgs)
```

## Slices

```go
type Args struct {
	//cli:default=50,95,99
	Percentiles []float64
}
```

CLI usage: `./app --percentiles 90 --percentiles 99`

## Value Resolution

```go
//cli:default=$GIT_MESSAGE
//cli:default=@COMMIT_EDITMSG
Message string
```

- `@path` reads from file
- `$NAME` expands env var
- Use `@@value` for literal leading `@`

## io.Reader Inputs

Native type supporting: local files, `-` (stdin), `file://`, `http://`, `https://`, `s3://` (AWS provider)

## Runtime Hooks

| Hook | Purpose |
| --- | --- |
| `New` | Seed initial args before defaults |
| `Lookup` | Rewrite raw string values before parsing |
| `Open` | Rewrite values for `io.Reader` fields |
| `Arg.Parse` | Custom parsing for unsupported types |
| `Arg.Validate` | Domain validation after parsing |

## AWS Provider

```go
//go:generate go tool cligen --provider aws
```

Enables: `@aws:ssm:/path`, `@aws:secret:name`, `s3://bucket/object`

## Enums with TextUnmarshaler

```go
type Mode string

func (Mode) Strings() []string { return []string{"fast", "safe"} }

func (m *Mode) UnmarshalText(text []byte) error { ... }

type Args struct {
	//cli:enum
	Mode Mode
}
```

## Built-in Version Command

```bash
go build -ldflags="-X github.com/lachaloupe/cli.Version=v1.2.3"
```

Then: `./app version`

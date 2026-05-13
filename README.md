# AI Agent Environment

Run AI coding CLIs from isolated Docker images while keeping your current workspace, tool caches, and agent configuration on the host.

This repo installs local shortcuts for:

- `claude`
- `codex`
- `gemini`
- `kiro`
- `opencode`

Each shortcut builds the matching Docker target when needed, mounts the current directory into the container, and then runs the requested agent command.

## Quick Start

Install the wrapper and agent shortcuts:

```bash
git clone git@github.com:EricRobert/agent.git
cd agent
make install
```

The first install can take a while because each shortcut is checked with `--version`, which builds the corresponding Docker image if it is not already cached.

Run an agent from any project directory:

```bash
cd ~/src/my-project
claude --help
codex
gemini "Explain this codebase"
kiro chat
opencode .
```

The directory you run the command from is mounted at `/home/$USER/workspace` inside the container.

## Included Tools

The base image includes a number of tools including:

- Go
- Node.js
- Python 3

Agent images add the corresponding CLI on top of that shared base image.

## Configuration

Config lives in this repo under `agents/<name>` and is symlinked into your home directory during install:

| Agent | Host config path |
| --- | --- |
| Claude | `~/.claude` |
| Codex | `~/.codex` |
| Gemini | `~/.gemini` |
| Kiro | `~/.kiro` |
| OpenCode | `~/.opencode` |

If a config path already exists and points somewhere else, `make install` leaves it alone and prints a `make move.<agent>` command.
Use that command when you want to copy the existing config into this repo and replace it with the symlink:

```bash
make move.claude
make move.codex
```

Agent-local secrets and generated files are ignored by the checked-in `.gitignore` files inside the config directories.

## Authentication

The wrapper forwards these environment variables into the container when they are set on the host:

- `ANTHROPIC_API_KEY`
- `GEMINI_API_KEY`
- `KIRO_API_KEY`
- `OPENAI_API_KEY`
- `OPENROUTER_API_KEY`

It also sets `BROWSER=echo`, which is useful for device-code or remote login flows because the CLI prints the URL instead of trying to open a browser inside the container.

Claude, Codex, and Gemini start their interactive login flow the first time you launch them without existing credentials.
Kiro needs an explicit login command.
OpenCode uses the local provider configured in this repo, so no auth is required for the default setup.

### Claude

Launch Claude and follow the first-run login prompts, or provide an API key:

```bash
export ANTHROPIC_API_KEY="YOUR_KEY"
claude
```

### Codex

Launch Codex and follow the first-run login prompts, or pipe in an API key:

```bash
export OPENAI_API_KEY="YOUR_KEY"
printenv OPENAI_API_KEY | codex login --with-api-key
```

### Gemini

Launch Gemini and follow the first-run login prompts, or provide an API key:

```bash
export GEMINI_API_KEY="YOUR_KEY"
gemini
```

### Kiro

Kiro needs an explicit login before use:

```bash
kiro login --use-device-flow
```

You can also provide a Kiro API key:

```bash
export KIRO_API_KEY="YOUR_KEY"
kiro chat
```

### OpenCode

OpenCode is configured in `agents/opencode/opencode.json`.
The default provider points at a local `llama.cpp`-compatible server on the host:

```text
http://localhost:8080/v1
```

No auth is required for that default local setup.
Because containers run with `--net host`, a local server on that port is visible from inside the container.
To use an OpenAI-compatible remote provider instead, set the relevant environment variable and update the OpenCode config:

```bash
export OPENAI_API_KEY="YOUR_KEY"
opencode
```

#### OpenRouter

OpenRouter is supported by OpenCode as a built-in provider.
The recommended setup is to let OpenCode store the credential:

```bash
opencode
```

Then run `/connect`, choose OpenRouter, and paste your OpenRouter API key.

## Mounted Host Paths

Each run mounts:

- `./` from your current directory to `/home/$USER/workspace`
- `~/.<agent>` to `/home/$USER/.<agent>`
- `~/.npm`
- `~/.cache/uv`
- `~/.cache/go-build`
- `~/.go/pkg/mod`

Kiro also mounts:

- `~/.aws`
- `~/.local/share/kiro-cli`

OpenCode also mounts:

- `~/.local/share/opencode`

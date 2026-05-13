FROM ubuntu:24.04 AS base

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt install -y \
        build-essential \
        bubblewrap \
        curl \
        file \
        fd-find \
        git \
        jq \
        python-is-python3 \
        python3 \
        python3-pip \
        python3-venv \
        ripgrep \
        unzip \
    && ln -s $(which fdfind) /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

COPY --from=golang:latest /usr/local/go /usr/local/go
COPY --from=node:current-slim /usr/local /usr/local/node
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/
COPY --from=ghcr.io/astral-sh/ruff:latest /ruff /usr/local/bin/

ENV PATH="/usr/local/go/bin:/usr/local/node/bin:$PATH"

RUN npm install -g npm@latest

ARG USERNAME=ubuntu
ARG UID=1000
ARG GID=1000
RUN groupadd -o -g $GID -o $USERNAME && useradd -m -u $UID -g $GID -o -s /bin/bash $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME/workspace

ENV USER="$USERNAME"
ENV HOME="/home/$USERNAME"
ENV GOROOT="/usr/local/go"
ENV GOPATH="$HOME/.go"
ENV PATH="$HOME/.local/bin:$HOME/.local/npm/bin:$GOPATH/bin:$GOROOT/bin:$PATH"

RUN mkdir -p ~/.local/npm ~/.cache ~/.go && npm config set prefix '~/.local/npm'

FROM base AS claude
ENV CLAUDE_CONFIG_DIR=/home/$USERNAME/.claude
RUN curl -fsSL https://claude.ai/install.sh | bash

FROM base AS codex
RUN npm install -g @openai/codex

FROM base AS gemini
RUN npm install -g @google/gemini-cli

FROM base AS kiro
RUN curl -fsSL https://cli.kiro.dev/install | bash && ln -s $(which kiro-cli) ~/.local/bin/kiro

FROM base AS opencode
RUN npm install -g opencode-ai

AGENTS=claude codex gemini kiro opencode
BIN?=$(HOME)/.local/bin

install: $(BIN)/agent $(addprefix install.,$(AGENTS))

$(BIN)/agent: agent
	@install -D -m 755 $< $@
	@sed -i 's|^CONTEXT=.*|CONTEXT="$(CURDIR)"|' $@

install.%: SOURCE=$(CURDIR)/agents/$*
install.%: $(BIN)/agent
	@test -d $(SOURCE)
	@ln -sf agent $(BIN)/$*
	@docker image inspect agent-cli:$* >/dev/null 2>&1 || $* --update latest --version || (echo "Failed to build $* agent"; exit 1)

.PHONY: install install.%

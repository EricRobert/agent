AGENTS=claude codex gemini kiro opencode
BIN?=$(HOME)/.local/bin

install: $(BIN)/agent $(addprefix install.,$(AGENTS))

$(BIN)/agent: agent
	@install -D -m 755 $< $@
	@sed -i 's|^CONTEXT=.*|CONTEXT="$(CURDIR)"|' $@

install.%: TARGET=$(HOME)/.$*
install.%: SOURCE=$(CURDIR)/agents/$*
install.%: $(BIN)/agent
	@test -d $(SOURCE)
	@ln -sf agent $(BIN)/$*
	@if [ ! -e "$(TARGET)" ]; then ln -s $(SOURCE) $(TARGET); elif [ "$$(readlink -f "$(TARGET)")" != "$(SOURCE)" ]; then echo "To move $* config: make move.$*"; fi
	@$* --version || (echo "Failed to rebuild $* agent"; exit 1)

move.%: TARGET=$(HOME)/.$*
move.%: SOURCE=$(CURDIR)/agents/$*
move.%:
	@test -d $(SOURCE)
	@cp -r $(TARGET)/. $(SOURCE)/
	@rm -rf $(TARGET)
	@ln -s $(SOURCE) $(TARGET)

.PHONY: install move.% install.%

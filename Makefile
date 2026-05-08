PREFIX ?= $(HOME)/.local
BINDIR := $(PREFIX)/bin
CONFDIR := $(HOME)/.config/crate

.PHONY: install uninstall test lint help

help:
	@echo "Targets:"
	@echo "  install    - install crate to $(BINDIR), copy config examples to $(CONFDIR)"
	@echo "  uninstall  - remove crate from $(BINDIR) (keeps config + library)"
	@echo "  test       - run bats smoke tests"
	@echo "  lint       - shellcheck binding examples, ruff bin/crate"

install:
	@install -Dm755 bin/crate $(BINDIR)/crate
	@mkdir -p $(CONFDIR) $(HOME)/.local/share/mpd/playlists $(HOME)/Audio/crate
	@for f in config/*.example; do \
		dest=$(CONFDIR)/$$(basename $$f .example); \
		if [ ! -e $$dest ]; then \
			install -Dm644 $$f $$dest; \
			echo "installed $$dest"; \
		else \
			echo "skipped $$dest (exists)"; \
		fi; \
	done
	@echo
	@echo "crate installed. Next steps:"
	@echo "  1. Set ANTHROPIC_API_KEY or GEMINI_API_KEY in your shell"
	@echo "  2. Source the bindings file from your compositor config"
	@echo "  3. systemctl --user enable --now mpd"
	@echo "  4. crate doctor"

uninstall:
	@rm -f $(BINDIR)/crate
	@echo "crate binary removed. Config + library preserved at:"
	@echo "  $(CONFDIR)"
	@echo "  ~/Audio/crate/  (or wherever you configured)"

test:
	@bats tests/bats/

lint:
	@ruff check bin/crate || true
	@shellcheck config/sxhkd.example || true

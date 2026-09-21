STOW = stow -d packages -t ~ --dotfiles --no-folding
PACKAGES = config local shell nvim-native

.PHONY: install uninstall reinstall update adopt check dry-run

dry-run:
	$(STOW) -n -v $(PACKAGES)

# zsh -n parses without executing, so a trailing negated pipeline such as
# `! pidof ... && exec ...` reports exit 1 even though the syntax is valid.
# Trust the diagnostics on stderr instead of the exit status.
check:
	@for f in \
		packages/config/dot-config/zsh/.zshrc \
		packages/config/dot-config/shell/profile \
		packages/config/dot-config/shell/functions/kitty-tools.zsh; do \
		echo "zsh -n $$f"; \
		err=$$(zsh -n "$$f" 2>&1) || true; \
		if [ -n "$$err" ]; then echo "$$err" >&2; exit 1; fi; \
	done
	nvim --headless -u NONE -i NONE -l scripts/check-native.lua

install:
	$(STOW) $(PACKAGES)

uninstall:
	$(STOW) -D $(PACKAGES)

reinstall: uninstall install

update:
	git pull
	$(STOW) --restow $(PACKAGES)

adopt:
	$(STOW) --adopt $(PACKAGES)

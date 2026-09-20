STOW = stow -d packages -t ~ --dotfiles --no-folding
PACKAGES = config local shell nvim-native

.PHONY: install uninstall reinstall update adopt check dry-run

dry-run:
	$(STOW) -n -v $(PACKAGES)

check:
	zsh -n packages/config/dot-config/zsh/.zshrc
	zsh -n packages/config/dot-config/shell/profile
	zsh -n packages/config/dot-config/shell/functions/kitty-tools.zsh
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

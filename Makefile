STOW = stow -d packages -t ~ --dotfiles --no-folding
PACKAGES = config local shell

.PHONY: install uninstall reinstall update

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

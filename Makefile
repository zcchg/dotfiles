help:
	@echo "install-dotfiles"
	@echo "overwrite-dotfiles-here"

install-dotfiles:
	@mkdir -p $$(grep '^!\.' .gitignore | grep -v '^!\.git' | sed 's/^!//' | grep '/' | grep -o '.*\/')
	@for f in $$(grep '^!\.' .gitignore | grep -v '^!\.git' | sed 's/^!//') ; do cp -v -a ./"$$f" ~/"$$f" ; done

overwrite-dotfiles-here:
	@for f in $$(grep '^!\.' .gitignore | grep -v '^!\.git' | sed 's/^!//') ; do cp -v -a ~/"$$f" ./"$$f" ; done

.PHONY:

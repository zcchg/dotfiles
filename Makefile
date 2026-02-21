help:
	@echo "install-dotfiles"
	@echo "overwrite-dotfiles-here"

install-dotfiles:
	@grep '^!' .gitignore | sed 's/^!//' | grep -v -E '^(\.gitignore|README\.md|LICENSE|Makefile)$$' | while read -r file ; do \
		if [ -f "$$file" ] ; then \
			mkdir -p "$(HOME)/$$(dirname "$$file")" ; \
			cp -v ./"$$file" "$(HOME)/$$file" ; \
		fi ; \
	done

overwrite-dotfiles-here:
	@grep '^!' .gitignore | sed 's/^!//' | grep -v -E '^(\.gitignore|README\.md|LICENSE|Makefile)$$' | while read -r file ; do \
		if [ -f "$$file" ] ; then \
			mkdir -p ./"$$(dirname "$$file")" ; \
			cp -v "$(HOME)/$$file" ./"$$file" ; \
		fi ; \
	done

.PHONY: help install-dotfiles overwrite-dotfiles-here

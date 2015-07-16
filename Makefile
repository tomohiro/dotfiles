# vim:set ft=make:

# Define build tools.
LN = ln -sf
RM = rm -f

# Define constants.
DEVELOPMENT = $(GOPATH)/src/github.com/$(USER)
DOTFILES    = $(DEVELOPMENT)/dotfiles
INSTALLTO   = $(HOME)
IGNORES     = bin bundle Makefile README.md


.PHONY: help test install bundle-show bundle-update

help:
	@echo "Please type: make [target]"
	@echo "  install         Install dotfiles $(DOTFILES) to $(INSTALLTO)"
	@echo "  bundle-show     Show git submodules"
	@echo "  bundle-update   Update git submodules"
	@echo "  help            Show this help messages"


install:
	@echo "Install dotfiles Start"
	$(LN) $(DOTFILES)/bin $(INSTALLTO)/
	@for file in `ls $(DOTFILES)`; do\
		for ignore in $(IGNORES); do\
			if [ $$ignore = $$file ]; then\
				continue 3;\
			fi;\
		done;\
		$(RM) $(INSTALLTO)/.$$file;\
		echo " [linkup] $(INSTALLTO)/.$$file";\
		$(LN) $(DOTFILES)/$$file $(INSTALLTO)/.$$file;\
	done;
	@echo "Finished."


bundle-show:
	@echo "Show git submodules."
	@git submodule status


bundle-update:
	@echo "Update git submodules."
	@git submodule foreach 'git pull origin master'
	@echo "Commit and push to the GitHub"
	@git commit -m 'Update submodules' bundle
	@git push origin master

# vim:set ft=make:

# Define build tools.
LN = ln -sf
RM = rm -f

# Define constants.
DOTFILES        = $(shell pwd)
INSTALLTO       = $(HOME)
XDG_CONFIG_HOME = $(HOME)/.config
IGNORES         = bin bundle Makefile README.md


.PHONY: help install bundle-show bundle-update symlinks setup-plugin-managers

help:
	@echo "Please type: make [target]"
	@echo "  install         Install dotfiles to $(INSTALLTO)"
	@echo "  bundle-show     Show git submodules"
	@echo "  bundle-update   Update git submodules"
	@echo "  help            Show this help messages"


install: symlinks setup-plugin-managers

symlinks:
	@echo "Create symlinks..."
	@echo " [linkup] $(INSTALLTO)/bin"
	@$(LN) $(DOTFILES)/bin $(INSTALLTO)/
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


setup-plugin-managers:
	@echo "Setup plugin managers..."
	@if [ ! -f $(INSTALLTO)/.vim/autoload/plug.vim ]; then\
		echo "===> Setup Vim plugins.";\
		curl -fLo $(INSTALLTO)/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;\
	fi
	@if [ ! -d $(INSTALLTO)/.zsh/repos/b4b4r07/zplug ]; then\
		echo "===> Setup Zsh plugins.";\
		git clone https://github.com/b4b4r07/zplug $(INSTALLTO)/.zsh/repos/b4b4r07/zplug;\
	fi
	@echo "Finished."

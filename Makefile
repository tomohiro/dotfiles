# vim:set ft=make:

# Define build tools.
LN = ln -sf
RM = rm -f

# Define constants.
DOTFILES        = $(shell pwd)
INSTALLTO       = $(HOME)
XDG_CONFIG_HOME = $(HOME)/.config
IGNORES         = bin Makefile README.md


.PHONY: help install symlinks setup-vim-plug

help:
	@echo "Please type: make [target]"
	@echo "  install         Install dotfiles to $(INSTALLTO)"
	@echo "  setup-vim-plug  Install vim-plug to $(INSTALLTO)/.vim"
	@echo "  help            Show this help messages"


install: symlinks setup-vim-plug

symlinks:
	@echo "Create symlinks..."
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

setup-vim-plugin-managers:
	@echo "Setup plugin managers..."
	@if [ ! -f $(INSTALLTO)/.vim/autoload/plug.vim ]; then\
		echo "===> Setup Vim plugins.";\
		curl -fLo $(INSTALLTO)/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;\
	fi
	@echo "Finished."

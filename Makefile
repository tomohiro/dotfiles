# vim:set ft=make:

# Define build tools.
LN = ln -sf
RM = rm -f

# Define constants.
DOTFILES  = $(shell pwd)
INSTALLTO = $(HOME)
IGNORES   = bin config Makefile README.md

XDG_CONFIG_HOME=$(HOME)/.config

.PHONY: help
help:
	@echo "Please type: make [target]"
	@echo "  install     Install dotfiles to $(INSTALLTO)"
	@echo "  setup-vim   Install vim-plug to $(INSTALLTO)/.vim"
	@echo "  setup-tmux  Install tpm to $(INSTALLTO)/.tmux"
	@echo "  help        Show this help messages"


.PHONY: install
install: symlinks setup-vim setup-tmux

.PHONY: symlinks
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
	@for file in `ls $(DOTFILES)/config`; do\
		$(RM) $(XDG_CONFIG_HOME)/$$file;\
		echo " [linkup] $(XDG_CONFIG_HOME)/$$file";\
		$(LN) $(DOTFILES)/config/$$file $(XDG_CONFIG_HOME)/$$file;\
	done;
	@echo "Finished.\n"

.PHONY: setup-vim
setup-vim:
	@if [ ! -f $(INSTALLTO)/.vim/autoload/plug.vim ]; then\
		echo "Setup Vim plugin manager.";\
		curl -fLo $(INSTALLTO)/.vim/autoload/plug.vim --create-dirs\
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;\
		echo "Finished.\n"; \
	fi

.PHONY: setup-tmux
setup-tmux:
	@if [ ! -d $(XDG_CONFIG_HOME)/tmux/plugins/tpm ]; then\
		echo "Setup Tmux plugin manager..."; \
		git clone https://github.com/tmux-plugins/tpm $(XDG_CONFIG_HOME)/tmux/plugins/tpm;\
		echo "Finished.\n"; \
	fi

dotfiles
================================================================================

[![Build Status](https://img.shields.io/travis/com/tomohiro/dotfiles.svg?style=flat-square)](https://travis-ci.com/tomohiro/dotfiles)


Installation
--------------------------------------------------------------------------------

```sh
$ make install
```


Usage
--------------------------------------------------------------------------------

```sh
$ make help
Please type: make [target]
  install     Install dotfiles to ${HOME}
  setup-vim   Install vim-plug to ${HOME}/.local/share/vim
  setup-tmux  Install tpm to ${HOME}/.local/share/tmux/plugins.tmux
  help        Show this help messages
```


Plugin Managers
--------------------------------------------------------------------------------

### Zsh

Update all plugins:

```
$ zplug update
```

### Vim

Update all plugins:

```
$ vi
:PlugUpdate  # Updates plugins
:PlugUpgrade # Upgrade vim-plug
```

### Tmux

Update all plugins:

```
$ (TMUX PREFFIX KEY) + U
all <ENTER>
```


Author
--------------------------------------------------------------------------------

Tomohiro Taira

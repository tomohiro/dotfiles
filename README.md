dotfiles [![Stillmaintained](http://stillmaintained.com/Tomohiro/dotfiles.png)](http://stillmaintained.com/Tomohiro/dotfiles)
================================================================================

[![Build Status](https://secure.travis-ci.org/Tomohiro/dotfiles.png)](https://secure.travis-ci.org/Tomohiro/dotfiles)


My terminal
--------------------------------------------------------------------------------

### iTerm2 on OS X Mountain Lion

![Terminal OS X](https://dl.dropbox.com/u/173097/junk/terminal-ss-20130220.png)


### Gnome Terminal on Ubuntu 12.04 LTS

![Terminal Ubuntu](http://dl.dropbox.com/u/173097/junk/terminal-ss-20120809.png)



Installation
--------------------------------------------------------------------------------

```sh
$ make install
```


Add submodules
--------------------------------------------------------------------------------

```sh
$ git submodule add git@github.com:johndoe/foo-command bundle/foo-command
$ git commit -m 'add foo-command' .gitmodules bundle/foo-command
```


Usage
--------------------------------------------------------------------------------

```sh
$ make help
Please type: make [target]
  install         Install dotfiles to /home/tomohiro
  test            Run tests
  bundle-show     Show git submodules
  bundle-update   Update git submodules
  clean           Cleanup
  help            Show this help messages
```

# vim: ft=zsh

# __is_installed checks install status the specified command
function __is_installed() {
  type $1 &> /dev/null
}

# Disable loading global profiles for OS X El Capitan.
#   - http://mattprice.me/2015/zsh-path-issues-osx-el-capitan/
setopt no_global_rcs

# Add Homebrew directories to the `$PATH`
PATH=/usr/local/bin:/usr/local/sbin:$PATH
[ -d /opt/X11/bin ] && PATH=/opt/X11/bin:$PATH

# Set XDG XDG Base Directory
#   - https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache


if [ -d $HOME/.bundlizer ]; then
  source $HOME/.bundlizer/etc/bashrc
  source $HOME/.bundlizer/completions/bundlizer.zsh
fi

if __is_installed rbenv; then
  export RBENV_ROOT=$XDG_DATA_HOME/rbenv
  eval "$(rbenv init -)"
fi

if __is_installed pyenv; then
  export PYENV_ROOT=$XDG_DATA_HOME/pyenv
  eval "$(pyenv init -)"
fi

if __is_installed nodenv; then
  export NODENV_ROOT=$XDG_DATA_HOME/nodenv
  eval "$(nodenv init -)"
fi

if __is_installed go; then
  export GOPATH=$HOME/Workspaces/Repositories
  export GOROOT=$(go env GOROOT)
  export CGO_CFLAGS=$CFLAGS
  export CGO_LDFLAGS=$LDFLAGS
  export PATH=$PATH:$GOPATH/bin
fi

if __is_installed rustc; then
  PATH=$PATH:$HOME/.cargo/bin
fi

XCODE_PATH=/Applications/Xcode.app
if [ -d $XCODE_PATH ]; then
  PATH=$PATH:$XCODE_PATH/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
fi

# For Google Cloud SDK
if [ -d /usr/local/Caskroom/google-cloud-sdk ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

# Default environment settings
export SHELL=$(which zsh)
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export EDITOR=$(which vim)
export SVN_EDITOR=$EDITOR
export PAGER=lv
export LISTMAX=10000
export TERM_256=xterm-256color
export TERM=$TERM_256
export LS_COLORS='di=01;36'


# Set `-U` option to remove duplicated paths
typeset -U path cdpath fpath manpath

# Export PATH
export PATH=$HOME/.private/bin:$HOME/bin:$PATH

# For Packer
if __is_installed packer; then
  export PACKER_CACHE_DIR=$XDG_CACHE_HOME/packer
fi

# Load some tools
__is_installed direnv && eval "$(direnv hook zsh)"
__is_installed thefuck && eval $(thefuck --alias)

# Starting keychain
if __is_installed keychain; then
  KEYCHAIN_HOME=$XDG_CACHE_HOME/keychain
  SSH_AGENT=$KEYCHAIN_HOME/$(hostname)-sh
  keychain -q $HOME/.ssh/id_rsa --dir $KEYCHAIN_HOME
  source $SSH_AGENT
fi

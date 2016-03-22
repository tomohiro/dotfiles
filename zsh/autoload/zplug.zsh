export ZPLUG_HOME=$HOME/.zsh
export ZPLUG_EXTERNAL=/dev/null
source $ZPLUG_HOME/repos/b4b4r07/zplug/zplug

zplug 'b4b4r07/zplug'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'

# zplug check return true if all plugins are installed
# Therefore, when it returns not true (thus false),
# run zplug install
if ! zplug check; then
    zplug install
fi

# Load Zsh plugins and which add to the PATH (Add `--verbose` to shows detail)
zplug load

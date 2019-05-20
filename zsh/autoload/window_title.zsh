# Eanble `addz-zsh-hook`
autoload -Uz add-zsh-hook

# Override auto-title when static titles are desired
# Example:
#   $ title 'some command | some title'
title() {
  export TITLE_OVERRIDDEN=1;
  echo -en "\e]0;$*\a"
}

# Turn off static titles
# Example:
#   $ autotitle
autotitle() {
  export TITLE_OVERRIDDEN=0
}

# Condition checking if title is overridden
__title_overridden() {
  [[ $TITLE_OVERRIDDEN == 1 ]]
}

# Echo asterisk if git state is dirty
__git_dirty() {
  if [[ $(git status 2> /dev/null | grep -o '\w\+' | tail -n 1) != (clean|) ]]; then
    echo '*'
  fi
}

# Show cwd when shell prompts for input.
__tabtitle_precmd() {
   if __title_overridden; then return; fi
   pwd=$(pwd) # Store full path as variable
   cwd=${pwd##*/} # Extract current working dir only
   print -Pn "\e]0;$cwd$(__git_dirty)\a" # Replace with $pwd to show full path
}
add-zsh-hook precmd __tabtitle_precmd

# Prepend command (w/o arguments) to cwd while waiting for command to complete.
__tabtitle_preexec() {
   if __title_overridden; then return; fi
   printf "\033]0;%s\a" "${1%% *} | $cwd$(__git_dirty)" # Omit construct from $1 to show args
}
add-zsh-hook preexec __tabtitle_preexec

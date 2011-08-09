# vim:ft=zsh:
#
#
# set Prompt
#
#
      chpwd() {
          if [[ -f Gemfile || -f .rvmrc ]]; then
              PROMPT="%F{red}[%n@%m]%F{blue}[%d]%F{magenta}[`rvm current`]%1(v|%F{green}%1v%f|)%F{yellow}
⚡ %F{white}"
          else
              PROMPT="%F{red}[%n@%m]%F{blue}[%d]%1(v|%F{green}%1v%f|)%F{yellow}
⚡ %F{white}"
          fi
      }

# vim:ft=zsh:
#
#
# functions
#
#

### set default prompt

      DEFAULT_PROMPT="%F{red}[%n@%m]%F{blue}[%d]%1(v|%F{green}%1v%f|)%F{yellow}
⚡ %F{white}"
      PROMPT=$DEFAULT_PROMPT


### precmd

      precmd() {
          # VCS info
          psvar=()
          LANG=en_US.UTF-8 vcs_info
          [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"

          # Check background process for Growl or notify-send
          check_background_process.rb `history -n -1 | head -1`

          # Check Ruby version and gemset at RVM
          if [[ -f Gemfile || -f .rvmrc ]]; then
              PROMPT="%F{red}[%n@%m]%F{blue}[%d]%F{magenta}[`rvm current`]%1(v|%F{green}%1v%f|)%F{yellow}
⚡ %F{white}"
          else
              PROMPT=$DEFAULT_PROMPT
          fi
      }


### if change directory

      chpwd() {
          _reg_pwd_screennum
          ls
      }

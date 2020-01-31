# vim: ft=zsh

# Set XDG Base Directory
#   - https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_LOCAL_HOME="${HOME}/.local"
export XDG_DATA_HOME="${XDG_LOCAL_HOME}/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"

# Set Zsh config directory
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
source "${ZDOTDIR}/.zshenv"

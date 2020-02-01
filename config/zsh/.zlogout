
# Remove .DS_Store
rm -f "${HOME}/.DS_Store"
find\
  "${HOME}/Applications"\
  "${HOME}/Desktop"\
  "${HOME}/Documents"\
  "${HOME}/Downloads"\
  "${HOME}/Movies"\
  "${HOME}/Pictures"\
  "${HOME}/Music"\
  "${HOME}/Public"\
  -name '.DS_Store'\
  -type f\
  -delete

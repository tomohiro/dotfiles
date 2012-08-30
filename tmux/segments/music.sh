#/bin/sh

if [ $KERNEL = 'Darwin' ]; then
  echo "$(emoji cd)  $(cat /tmp/last.fm_recent_track)  "
else
  echo "☊ $(cat /tmp/last.fm_recent_track)  "
fi

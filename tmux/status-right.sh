#!/usr/bin/env bash
# This script prints a string will be evaluated for text attributes (but not shell commands) by tmux. It consists of a bunch of segments that are simple shell scripts/programs that output the information to show. For each segment the desired foreground and background color can be specified as well as what separator to use. The script the glues together these segments dynamically so that if one script suddenly does not output anything (= nothing should be shown) the separator colors will be nicely handled.

LC_ALL=C

# The powerline root directory.
cwd=$(dirname $0)

# Source global configurations.
source "${cwd}/plugins/tmux-powerline/config.sh"

# Source lib functions.
source "${cwd}/plugins/tmux-powerline/lib.sh"

segments_path="${cwd}/plugins/tmux-powerline/${segments_dir}"

# Segment
# Comment/uncomment the register function call to enable or disable a segment.

declare -A load
load+=(["script"]="${segments_path}/load.sh")
load+=(["foreground"]="colour167")
load+=(["background"]="colour237")
load+=(["separator"]="${separator_left_bold}")
register_segment "load"

declare -A battery
if [ "$PLATFORM" == "mac" ]; then
	battery+=(["script"]="${segments_path}/battery_mac.sh")
else
	battery+=(["script"]="${segments_path}/battery.sh")
fi
battery+=(["foreground"]="colour127")
battery+=(["background"]="colour137")
battery+=(["separator"]="${separator_left_bold}")
register_segment "battery"

declare -A weather
weather+=(["script"]="${segments_path}/weather.sh")
weather+=(["foreground"]="colour255")
weather+=(["background"]="colour37")
weather+=(["separator"]="${separator_left_bold}")
register_segment "weather"

declare -A music
music+=(["script"]="$HOME/.tmux/segments/music.sh")
music+=(["foreground"]="colour255")
music+=(["background"]="colour88")
music+=(["separator"]="${separator_left_bold}")
register_segment "music"

# Print the status line in the order of registration above.
print_status_line_right

exit 0

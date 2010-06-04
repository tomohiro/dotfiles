#!/usr/bin/env ruby
#
# for Mac OS X on GeekTool
# ex.
#   ./irc_notify_check.rb
#

NOTIFY = "#{ENV['HOME']}/.irssi/fnotify" 
if File.exists? NOTIFY
  p File.open(NOTIFY).count
else
  p 0
end

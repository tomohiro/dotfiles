#!/usr/bin/env ruby

message = "'GNU screen notify' 'command done: #{ARGV}'"
notify = case %x{ uname }.chomp
         when 'Darwin' then "growlnotify -t #{message}"
         when 'Linux'  then "notify-send -i gtk-dialog-info -t 5000 -u critical #{message}" 
         end

current = ENV['WINDOW']
%x{ screen -Q windows; screen -X redisplay }.split('  ').each do |window|
  if window.include? '*' and current != window[/^(\d+)/]
    %x{ #{notify} }
  end
end

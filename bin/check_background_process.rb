#!/usr/bin/env ruby

title   = "'GNU screen notify'"
message = "'command done: #{ARGV.join(' ')}'"
notify = case %x{ uname }.chomp
         when 'Darwin' then "growlnotify -t #{title} -m #{message}"
         when 'Linux'  then "notify-send -i gtk-dialog-info -t 5000 -u critical #{title} #{message}" 
         end

current = ENV['WINDOW']
%x{ screen -Q windows; screen -X redisplay }.split('  ').each do |window|
  if window.include? '*' and current != window[/^(\d+)/]
    %x{ #{notify} }
    break
  end
end

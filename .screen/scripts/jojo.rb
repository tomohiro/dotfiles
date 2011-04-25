#!/usr/bin/env ruby
# -*- encoding:utf-8 -*-

loop do
  fortune = "#{`fortune jojo`.gsub("\n", '').gsub('  ', '').gsub('--', ' - ')}"
  if fortune.size < 80
    puts fortune
    exit
  end
end

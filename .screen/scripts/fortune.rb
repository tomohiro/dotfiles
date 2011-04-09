#!/usr/bin/env ruby

loop do
  fortune = "「#{`fortune jojo`.gsub("\n", '').gsub('  ', '').gsub('--', '」 - ')}"
  if fortune.size < 180
    puts fortune
    exit
  end
end

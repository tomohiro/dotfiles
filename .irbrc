require 'irb/ext/save-history'
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_PATH] = File::expand_path("~/.irb.history")

require 'pp'
require 'ostruct'
require 'yaml'
require 'open-uri'

# RubyGems
require 'rubygems'
require 'nokogiri'
#require 'mechanize'
#require 'rss'
#require 'json'
#require 'wirble'

#Wirble.init(:skip_prompt => :DEFAULT)
#Wirble.colorize

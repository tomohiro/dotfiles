# Initialize
if ENV['RUBY_DATA_HOME']
  IRB_HISTORY_FILE = "#{ENV['RUBY_DATA_HOME']}/irb-history"
else
  IRB_HISTORY_FILE = "#{ENV['HOME']}/.irb-history"
end

# Load Builtin gems to default
require 'pp'
require 'ostruct'
require 'yaml'
require 'open-uri'

# Load third-party gems to defualt
require 'rubygems'
require 'nokogiri'

# Load IRB options
require 'irb/completion'
require 'irb/ext/save-history'
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = IRB_HISTORY_FILE

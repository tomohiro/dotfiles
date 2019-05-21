# vim: ft=ruby

# Define path to IRB history file
if ENV['RUBY_DATA_HOME']
  IRB_HISTORY_FILE = "#{ENV['RUBY_DATA_HOME']}/irb-history"
else
  IRB_HISTORY_FILE = "#{ENV['HOME']}/.irb-history"
end

module IRB
  module Helpers
    def load_gem(name)
      puts "  - #{name}"
      require name
    end

    # Enable Rspec::Matchers
    # https://www.pluralsight.com/guides/playing-with-rspec-from-irb
    #
    # @example
    #   $ irb
    #   irb(main):001:0> enable_rspec_matchers!
    #   => Object
    #   irb(main):002:> expect(1 + 1).to eq 2
    #   => true
    def enable_rspec_matchers!
      require 'rspec/core'
      require 'rspec/expectations'
      include RSpec::Matchers
    rescue LoadError => e
      puts 'Failed to load. You should install `RSpec`'
      puts e
    end

    def override_irb_configuratoin!
      require 'irb/completion'
      require 'irb/ext/save-history'
      IRB.conf[:USE_READLINE] = true
      IRB.conf[:SAVE_HISTORY] = 1000
      IRB.conf[:HISTORY_FILE] = IRB_HISTORY_FILE
    end
  end
end

extend IRB::Helpers

# Initialize
begin
  puts "Ruby #{RUBY_VERSION}p#{RUBY_PATCHLEVEL} (##{RUBY_RELEASE_DATE})"
  puts "[#{RUBY_PLATFORM} - #{RUBY_COPYRIGHT}]\n"

  puts 'Load Builtin gems'
  load_gem 'pp'
  load_gem 'ostruct'
  load_gem 'yaml'
  load_gem 'open-uri'

  puts 'Load third-party gems'
  load_gem 'rubygems'
  load_gem 'nokogiri'

  puts 'Enable Bundler'
  load_gem 'bundler/setup'

  # Load IRB options
  override_irb_configuratoin!
rescue LoadError => e
  puts e
end

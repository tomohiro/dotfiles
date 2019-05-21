# vim: ft=ruby

# Define path to IRB history file
if ENV['RUBY_DATA_HOME']
  IRB_HISTORY_FILE = "#{ENV['RUBY_DATA_HOME']}/irb-history"
else
  IRB_HISTORY_FILE = "#{ENV['HOME']}/.irb-history"
end

module IRB
  module Helpers
    # https://docs.ruby-lang.org/ja/latest/library/irb.html
    # https://docs.ruby-lang.org/ja/latest/class/IRB=3a=3aContext.html
    def override_irb_configuratoin!
      require 'irb/completion'
      require 'irb/ext/save-history'
      IRB.conf[:AUTO_INDENT] = true
      IRB.conf[:ECHO] = true
      IRB.conf[:PROMPT_MODE] = :DEFAULT # Or :SIMPLE
      IRB.conf[:USE_READLINE] = true
      IRB.conf[:EVAL_HISTORY] = 1000
      IRB.conf[:SAVE_HISTORY] = 1000
      IRB.conf[:HISTORY_FILE] = IRB_HISTORY_FILE
    end

    def load_gem(name)
      puts "  - #{name}"
      require name
    rescue LoadError => e
      warn "  - Failed to load: #{e}"
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
      puts 'RSpec matchers load succeed.'
    rescue LoadError => e
      warn "Failed to load. #{e}"
    end

    def enable_awesome_print!
      puts '  - awesome_print'
      require 'awesome_print'
      AwesomePrint.irb!
    rescue LoadError => e
      warn "Failed to load. #{e}"
    end

    def enable_irbtools!
      puts '  - irbtools'
      require 'irbtools'
    rescue LoadError => e
      warn "Failed to load. #{e}"
    end
  end
end

extend IRB::Helpers

# Initialize
begin
  puts "IRB: Ruby #{RUBY_VERSION}p#{RUBY_PATCHLEVEL} (##{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM} - #{RUBY_COPYRIGHT}]"
  puts '---'

  puts 'Load Builtin gems'
  load_gem 'pp'
  load_gem 'ostruct'
  load_gem 'yaml'
  load_gem 'json'
  load_gem 'open-uri'
  load_gem 'rubygems'

  # Enable IRB plugins
  puts 'Enable IRB plugins'
  enable_awesome_print!

  # Load IRB options
  puts 'Override IRB configration'
  override_irb_configuratoin!

  puts 'Enable Bundler'
  load_gem 'bundler/setup'
rescue LoadError => e
  puts e
end

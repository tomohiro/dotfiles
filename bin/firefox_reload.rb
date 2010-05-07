#!/usr/bin/env ruby

require 'net/telnet'

config = {'Host' => 'localhost', 'Port' => 4242 }

begin
  telnet = Net::Telnet.new(config)
  telnet.puts 'content.location.reload(true)'
  telnet.close
rescue
  false
end

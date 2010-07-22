#!/usr/bin/env ruby

require 'net/telnet'

config = {'Host' => 'localhost', 'Port' => 4242 }

begin
  telnet = Net::Telnet.new(config)
  telnet.cmd 'x = content.window.pageXOffset'
  telnet.cmd 'y = content.window.pageYOffset'
  telnet.cmd 'BrowserReload()'
  telnet.cmd 'content.window.scrollTo(x, y)'
  telnet.close
rescue
  false
end

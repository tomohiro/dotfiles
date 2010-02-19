#!/usr/bin/env ruby
#
# ex.
#   ./openpne_check.rb -u your_username -p your_password -s openpne_uri
#

require 'optparse'

require 'rubygems'
require 'mechanize'
require 'nokogiri'

ARGV.options do |o|
  o.on('-u', '--username USERNAME', 'OpenPNE Username') { |v| @username = v }
  o.on('-p', '--password PASSWORD', 'OpenPNE Password') { |v| @password = v }
  o.on('-s', '--source SOURCE', 'OpenPNE URI') { |v| @source = v }
  o.parse!
end

agent = Mechanize.new

proxy = ENV['https_proxy'] || ENV['http_proxy']
if proxy
  proxy = URI.parse(proxy)
  agent.set_proxy(proxy.host, proxy.port)
end

agent.get @source do |login_page|
  login_page.form_with(:name => 'login') do |form|
    form.username = @username
    form.password = @password
  end.submit
end

puts (Nokogiri::HTML(agent.get(@source).body)/'span.caution').count

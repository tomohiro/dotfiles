#!/usr/bin/env ruby
#
# ex.
#   ./mixi_check.rb -e your_email -p your_password
#

require 'optparse'

require 'rubygems'
require 'mechanize'
require 'nokogiri'

ARGV.options do |o|
  o.on('-e', '--email Email', 'mixi Email') { |v| @email= v }
  o.on('-p', '--password PASSWORD', 'mixi Password') { |v| @password = v }
  o.parse!
end

agent = WWW::Mechanize.new

proxy = ENV['https_proxy'] || ENV['http_proxy']
if proxy
  proxy = URI.parse(proxy)
  agent.set_proxy(proxy.host, proxy.port)
end

agent.get 'http://mixi.jp' do |login_page|
  login_page.form 'login_form' do |form|
    form.email = @email
    form.password = @password
  end.submit
end

puts (Nokogiri::HTML(agent.get('http://mixi.jp').body)/'li.redTxt').count

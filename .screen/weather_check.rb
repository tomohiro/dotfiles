#!/usr/bin/env ruby
#
# ex.
#   ./weather_check.rb -s yahoo_weather_source
#

require 'optparse'

require 'rubygems'
require 'mechanize'
require 'nokogiri'

ARGV.options do |o|
  o.on('-s', '--source SOURCE', 'Yahoo Weather URI. ') { |v| @source = v }
  o.parse!
end

agent = Mechanize.new

proxy = ENV['https_proxy'] || ENV['http_proxy']
if proxy
  proxy = URI.parse(proxy)
  agent.set_proxy(proxy.host, proxy.port)
end

style = (Nokogiri::HTML(agent.get(@source).body)/'div.forecast-icon').first.attributes['style']
style.text.match(/background:url\('(.+?)'\)/)
image = $1

`wget "#{image}" -O /tmp/weather.png`

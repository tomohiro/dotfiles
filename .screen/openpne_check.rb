#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'pit'

config = Pit.get('openpne', :require => {
  :username => 'your username in openpne',
  :password => 'your password in openpne',
  :uri      => 'your openpne location'
})

agent = Mechanize.new

proxy = ENV['https_proxy'] || ENV['http_proxy']
if proxy
  proxy = URI.parse(proxy)
  agent.set_proxy(proxy.host, proxy.port)
end

agent.get config[:uri] do |login_page|
  login_page.form_with(:name => 'login') do |form|
    form.username = config[:username]
    form.password = config[:password]
  end.submit
end

puts (Nokogiri::HTML(agent.get(config[:uri]).body)/'span.caution').count

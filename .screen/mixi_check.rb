#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'pit'

config = Pit.get('mixi.jp', :require => {
  :email    => 'your email in mixi.jp',
  :password => 'your password in mixi.jp',
})

agent = Mechanize.new

proxy = ENV['https_proxy'] || ENV['http_proxy']
if proxy
  proxy = URI.parse(proxy)
  agent.set_proxy(proxy.host, proxy.port)
end

agent.get 'http://mixi.jp' do |login_page|
  login_page.form 'login_form' do |form|
    form.email = config[:email]
    form.password = config[:password]
  end.submit
end

puts (Nokogiri::HTML(agent.get('http://mixi.jp').body)/'li.redTxt').count

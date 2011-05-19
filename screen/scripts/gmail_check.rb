#!/usr/bin/env ruby

require 'net/https'
require 'rubygems'
require 'nokogiri'
require 'pit'

config = Pit.get('gmail.com', :require => {
  :email    => 'your email in gmail',
  :password => 'your password in gmail'
})


proxy = ENV['https_proxy'] || ENV['http_proxy']
if proxy
  https = Net::HTTP::Proxy(URI.parse(proxy).host, URI.parse(proxy).port).new('mail.google.com', 443)
else 
  https = Net::HTTP.new('mail.google.com', 443)
end
https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new('/mail/feed/atom')
request.basic_auth(config[:email], config[:password])
responce = https.request(request).body

xml = Nokogiri::XML(responce)
puts (xml/'fullcount').text
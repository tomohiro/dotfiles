#!/usr/bin/env ruby
#
# ex.
#   ./gmail_check.rb -a your_account -p your_password
#

require 'optparse'
require 'net/https'

require 'rubygems'
require 'nokogiri'

ARGV.options do |o|
  o.on('-a', '--account ACCOUNT', 'Gmail Account. ') { |v| @account = v }
  o.on('-p', '--password PASSWORD', 'Gmail Password') { |v| @password = v }
  o.parse!
end

proxy = ENV['https_proxy'] || ENV['http_proxy']
https = Net::HTTP::Proxy(URI.parse(proxy).host, URI.parse(proxy).port).new('mail.google.com', 443)
https.use_ssl = true
https.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new('/mail/feed/atom')
request.basic_auth(@account, @password)
responce = https.request(request).body

xml = Nokogiri::XML(responce)
puts (xml/'fullcount').text
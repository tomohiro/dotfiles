#!/usr/bin/env ruby

require 'net/http'
require 'rubygems'
require 'json'

Net::HTTP.version_1_2

def chirp(id, pass)
  uri   = URI.parse('http://chirpstream.twitter.com/2b/user.json')
  proxy = ENV['https_proxy'] || ENV['http_proxy']
  if proxy
    http = Net::HTTP::Proxy(URI.parse(proxy).host, URI.parse(proxy).port).start(uri.host, uri.port)
  else 
    http = Net::HTTP.start(uri.host, uri.port)
  end

  buf = ''
  request = Net::HTTP::Get.new(uri.request_uri)
  request.basic_auth id, pass
  http.request(request) do |response|
    response.read_body do |body|
      buf += body
      until (i = buf.index("\r\n")).nil?
        str =  buf.slice!(0, i + 2).chomp
        yield(JSON.parse(str)) unless str.size == 0
      end
    end
  end
end

if $0 == __FILE__
  chirp('Tomohiro', 'rules7189') do |h|
    puts "<@#{h['user']['screen_name']}> #{h['text']}" if h.key?('text')
    puts "#{h['event']}:#{h}" if h.key?('event')
  end
end

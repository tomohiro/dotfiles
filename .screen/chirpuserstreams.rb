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

def attribute c, s
  ss = s.to_s
  if ss.empty?
    ss
  else
    ["\c%{=", c, '}', ss, "\c%{= dd}"].join('')
  end
end

def showline(name, time, tweet, source)
  t = attribute(' dG', Time.parse(time).strftime('%H:%M:%S'))
  n = attribute ' dB', name
  tweet = /.{0,200}/.match tweet.chomp
  source = source[/>.+?</].gsub(/>|</, '') rescue source

  printf "(%s)[%s] %s - %s\n", t, n, tweet[0], source
end

loop do
  chirp(ENV['USER'], 'rules7189') do |h|
    event = h['event'] || 'tweet'
    case event
    when 'retweet'
      data = "#{event} to: @#{h['target_object']['user']['screen_name']}:#{h['target_object']['text']}"
      showline(h['source']['screen_name'], h['created_at'], data, h['target_object']['source'])
    when 'favorite'
      data = "#{event} to: @#{h['target_object']['user']['screen_name']} #{h['target_object']['text']}"
      showline(h['source']['screen_name'], h['created_at'], data, h['target_object']['source'])
    else
      showline(h['user']['screen_name'], h['created_at'], h['text'], h['source']) unless h['text'].nil?
    end
  end
end

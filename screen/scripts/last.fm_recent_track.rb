#!/usr/bin/env ruby

require 'open-uri'
require 'rubygems'
require 'nokogiri'

xml = Nokogiri::XML(open('http://ws.audioscrobbler.com/1.0/user/tomohiro-taira/recenttracks.rss').read)
#puts "#{[9834].pack('U')} #{(xml/'item/title').first.text}"
puts (xml/'item/title').first.text

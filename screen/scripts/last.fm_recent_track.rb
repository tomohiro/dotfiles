#!/usr/bin/env ruby

require 'open-uri'
require 'rubygems'
require 'nokogiri'

puts Nokogiri::XML(open('http://ws.audioscrobbler.com/1.0/user/tomohiro-taira/recenttracks.rss')).search('item/title').first.text

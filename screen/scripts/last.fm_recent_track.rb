#!/usr/bin/env ruby

require 'open-uri'
require 'rubygems'
require 'nokogiri'

xml = Nokogiri::XML(open('http://ws.audioscrobbler.com/1.0/user/tomohiro-taira/recenttracks.rss').read)
puts (xml/'item/title').first.text

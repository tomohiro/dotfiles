#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'nokogiri'

(Nokogiri::HTML(open('http://atmc.jp').read)/'table').each { |t| pref = (t/'tr')[0].text; puts pref.strip.gsub(/\n/, '') if /47\./ =~ pref }

#!/usr/bin/env ruby
# -*- encoding: UTF-8 -*-

require 'rubygems'
require 'open-uri'
require 'nokogiri'

((Nokogiri::HTML(open('http://atmc.jp').read))/'div/table').each { |t| pref = (t/'tr')[0].text; puts pref.strip.gsub(/\n/, '') if /沖縄/ =~ pref }

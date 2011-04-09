#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'kconv'

list = %w[
  http://proudyblood.nobody.jp/wryyyyyyy.html
]
=begin
  http://proudyblood.nobody.jp/wryyyyyyy2html
  http://proudyblood.nobody.jp/wryyyyyyy3.5html
  http://proudyblood.nobody.jp/wryyyyyyy4html
  http://proudyblood.nobody.jp/wryyyyyyy5html
  http://proudyblood.nobody.jp/wryyyyyyy5.5html
  http://proudyblood.nobody.jp/wryyyyyyy6html
  http://proudyblood.nobody.jp/wryyyyyyysbrhtml
]
=end

list.each do |url|
  html = Nokogiri::HTML(open(url, 'r:Windows-31J').read)
  puts (html/'table').count
  (html/'table').each do |data|
    s = data.text.split
    unless s[3].nil?
      puts s[3..99]
      puts "          -- #{s[1]}"
      puts '%'
    end
  end
end

#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'nokogiri'

URL = ARGV.first
if URL.nil? 
  puts 'usage. '
  puts '    $ hatena_fotolife_original_image_url.rb http://f.hatena.ne.jp/example/20100101/'
  exit
end

html = Nokogiri::HTML(open(URL).read)
(html/'div/ul.fotolist/li/a').each do |a|
  link = a.attributes['href'].text.split '/'
  user, prefix = link[1], link[1][0, 1]
  dir, file = link[2][0..7], link[2]
  puts "http://img.f.hatena.ne.jp/images/fotolife/#{prefix}/#{user}/#{dir}/#{file}_original.jpg"
end

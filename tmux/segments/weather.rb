#!/usr/bin/env ruby
# encoding : utf-8

require 'open-uri'
require 'uri'
require 'rubygems'
require 'nokogiri'

class GoogleWeather
  attr_reader :place, :temp, :condition, :wind, :symbol

  def search(location)
    location = URI.encode(location)
    url  = "https://www.google.co.jp/search?q=weather+#{location}&ie=utf-8&oe=utf-8&hl=en"
    node = Nokogiri::HTML(open(url)).search('.obcontainer')

    @place     = node.search('b')[1].text
    @temp      = node.search('div/table/tr[1]/td')[1].text
    @condition = node.search('div/table/tr[3]/td').text
    @wind      = node.search('div/table/tr[4]/td').text
    @symbol    = get_symbol(@condition)

    self
  rescue NoMethodError
    "Not found: #{location}"
  end

  def to_s
    "#{@symbol} #{@temp}"
  end

  def get_symbol(condition)
    case condition.downcase
    when /sunny|partly sunny|mostly sunny/
      hour = Time.now.hour
      (hour > 22 or hour < 5) ? '☾' : '☼'
    when /partly cloudy|mostly cloudy|cloudy|overcast/
      '☁'
    when /rain and snow|chance of rain|light rain|rain|heavy rain|freezing drizzle|flurries|showers|scattered showers|drizzle|rain showers/
      '☔'
    when /snow|light snow|scattered snow showers|icy|ice\/snow|chance of snow|snow showers|sleet/
      '❅'
    when /chance of storm|thunderstorm|chance of tstorm|storm|scattered thunderstorms/
      '⚡'
    when /dust|fog|smoke|haze|mist/
      '♨'
    when 'windy'
      '⚑'
    when 'clear'
      '✈'
    else
      condition
    end
  end
end


if $0 == __FILE__
  CACHE = '/tmp/weather'

  if File.exist?(CACHE) && (Time.now - File::Stat.new(CACHE).mtime) <= 2000
    puts File.read(CACHE)
    exit
  end

  location = ARGV.first || 'Naha'
  info = GoogleWeather.new.search(location)

  if info.nil?
    File.delete CACHE
  else
    open(CACHE, 'w') { |io| io.print info }
    puts info
  end
end

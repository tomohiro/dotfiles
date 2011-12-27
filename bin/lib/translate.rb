#!/usr/bin/env ruby
# encoding: utf-8

require 'open-uri'
require 'json'

require 'rubygems'
require 'nokogiri'

module Translate

  class << self

    # Google Trasnlate
    def google text
      api = 'http://ajax.googleapis.com/ajax/services/language'

      begin
        encoded = URI.encode text

        detect = JSON.parse(open("#{api}/detect?v=1.0&q=#{encoded}").read)
        from, to = detect['responseData']['language'] == 'en' ? %w[en ja] : %w[ja en]

        result = JSON.parse(open("#{api}/translate?v=1.0&q=#{encoded}&langpair=#{from}%7C#{to}").read)

        result['responseData']['translatedText']
      rescue Exception => e
        "Google: Translation Faild. #{e.to_s}."
      end
    end

    # 英辞郎 on the WEB
    def eijiro word
      ((Nokogiri::HTML(open("http://eow.alc.co.jp/#{URI.encode word}/UTF-8").read)/'#resultsList')/'ol').map { |n| n.text }
    end

  end
end

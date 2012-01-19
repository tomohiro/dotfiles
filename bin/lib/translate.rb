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
        puts detect
        return
        from, to = detect['responseData']['language'] == 'en' ? %w[en ja] : %w[ja en]

        result = JSON.parse(open("#{api}/translate?v=1.0&q=#{encoded}&langpair=#{from}%7C#{to}").read)

        result['responseData']['translatedText']
      rescue Exception => e
        "Google: Translation Faild. #{e.to_s}."
      end
    end

    # 英辞郎 on the WEB
    def eijiro word
      ((Nokogiri::HTML(open("http://eow.alc.co.jp/#{URI.encode word}/UTF-8"))/'#resultsList')/'ol').map { |n| n.text }
    end

    # Excite
    def excite text
      (Nokogiri::HTML(open("http://www.excite.co.jp/world/english/?before=#{URI.encode text}"))/'#after').text
    end

    # Microsoft Translator
    def microsoft text
      JSON.parse(open("http://api.microsofttranslator.com/v2/ajax.svc/TranslateArray?appId=%22TiXODCK2ZNJnf3TwvAbbBi92PTQQj7oR6nRVcmZRZFds*%22&texts=[%22#{URI.encode text}%22]&from=%22%22&to=%22ja%22").read)
    end

  end
end

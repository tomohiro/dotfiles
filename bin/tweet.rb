#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'rubygems'
require 'open-uri'
require 'nokogiri'

module Twitter
  module API

    class Error
      ERROR_API_LIMIT = '400 Bad Request'
      ERROR_PROTECTED = '401 Unauthorized'
      ERROR_NOT_FOUND = '404 Not Found'

      MESSAGES = {
        ERROR_API_LIMIT => 'Sorry, over API limit.',
        ERROR_PROTECTED => "@%s's tweet is protected.",
        ERROR_NOT_FOUND => "@%s is not found."
      }

      def self.message(error)
        MESSAGES[error]
      end
    end

    class UserTimeline
      URI = 'http://api.twitter.com/1/statuses/user_timeline.xml'
      attr_reader :screen_name

      def initialize(screen_name)
        begin
          param = "screen_name=#{screen_name}&count=1"
          xml = Nokogiri::XML(open("#{URI}?#{param}").read)
          @screen_name = (xml/'screen_name').text
        rescue Exception => e
          raise Exception.new(sprintf(Error.message(e.to_s), screen_name))
        end
      end

      def tweets(count = 1)
        if count.instance_of? Range
          offset, limit = count.first, count.end
          count = limit
        else
          offset = count - 1
        end

        param  = "screen_name=#{@screen_name}&count=#{count}&include_rts=true"
        tweets = Nokogiri::XML(open("#{URI}?#{param}").read)/'status'

        if limit and offset
          tweets[offset.to_i, (limit.to_i - offset.to_i)]
        else
          tweets[offset, 1]
        end
      end
    end
  end
end

class Tweet
  def main(message)
    channel = 'hoge'
    if /^@(.+?)(| .+?)$/  =~ message
      user = $1.strip
      count = $2.strip
      if count =~ /-/
        offset, limit= count.split(/-/)
        count = offset..limit
      else
        count = count.to_i
      end

      begin
        user = Twitter::API::UserTimeline.new user
        screen_name = user.screen_name
        (user.tweets(count)).each do |t|
          notice(channel, "#{screen_name}: #{(t/'text').text} (#{Time.parse((t/'created_at').first.text).strftime('%m月%d日 %H時%I分')})")
        end
      rescue Exception => e
        notice(channel, e)
      end
    end
  end
end

def notice(channel, message)
  puts message
end

tw = Tweet.new

messages = ['@warajimusichan', '@fogegeelglelgka']
messages.each do |m|
  begin
    tw.main(m)
  rescue
    next
  end
end

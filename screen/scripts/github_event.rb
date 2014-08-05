#!/usr/bin/env ruby
# Inspired by https://github.com/cho45/net-irc/blob/master/examples/gig.rb

require 'open-uri'
require 'time'
require 'nokogiri'

module GitHub
  class Event
    def initialize(user, token)
      @last  = Time.now
      @feeds = [
        "https://github.com/#{user}.private.atom?token=#{token}",
        "https://github.com/#{user}.atom"
      ]
    end

    def monitoring
      display 'Waiting new event'

      loop do
        events = []
        @feeds.each do |uri|
          events.concat(parse_event_feed(uri))
        end

        events.reverse_each do |event|
          next if event[:datetime] <= @last
          type = event[:id][/\d+:(.+)\//, 1]
          display "#{type} ⮁ #{event[:title]} #{event[:link]}"
        end

        @last = events.first[:datetime]
        sleep 60
      end
    end

    private
      def parse_event_feed(uri)
        Nokogiri::XML(open(uri)).search('entry').map do |event|
          {
            id:       event.at('id').text,
            title:    event.at('title').text,
            author:   event.at('author/name').text,
            link:     event.at('link').attributes['href'].text,
            datetime: Time.parse(event.at('published').text)
          }
        end
      end

      def display(message)
        puts "⭠ GitHub ⮁ #{message}"
        sleep 10
      end
  end
end

if __FILE__ == $0
  require 'pit'
  config = Pit.get('github.com', require: {
    user:  'Your account in GitHub',
    token: 'Your private feed atom token in GitHub'
  })

  STDOUT.sync = true
  GitHub::Event.new(config[:user], config[:token]).monitoring
end

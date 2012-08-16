#!/usr/bin/env ruby
# encoding: utf-8
# Inspired by https://github.com/cho45/net-irc/blob/master/examples/gig.rb

require 'open-uri'
require 'time'
require 'rubygems'
require 'nokogiri'

module GitHub
  class Activity
    def initialize(user, token)
      @feeds = [
        "https://github.com/#{user}.private.atom?token=#{token}",
        "https://github.com/#{user}.private.actor.atom?token=#{token}"
      ]
      @last  = Time.now
    end

    def monitoring
      display 'Waiting new activities'

      loop do
        activities = []
        @feeds.each do |uri|
          Nokogiri::XML(open(uri)).search('entry').each do |activity|
            activities << {
              :id       => activity.at('id').text,
              :title    => activity.at('title').text,
              :author   => activity.at('author/name').text,
              :link     => activity.at('link').attributes['href'].text,
              :datetime => Time.parse(activity.at('published').text)
            }
          end
        end

        activities.reverse_each do |activity|
          next if activity[:datetime] <= @last
          type = activity[:id][/\d+:(.+)\//, 1]
          display "#{type} ⮁ #{activity[:title]} #{activity[:link]}"
        end

        @last = activities.first[:datetime]
        sleep 60
      end
    end

    private
      def display(message)
        puts "⭠ GitHub ⮁ #{message}"
        sleep 10
      end
  end
end

if __FILE__ == $0
  require 'pit'
  config = Pit.get('github.com', :require => {
    :user  => 'your account in GitHub',
    :token => 'your private feed atom token in GitHub'
  })

  STDOUT.sync = true
  GitHub::Activity.new(config[:user], config[:token]).monitoring
end

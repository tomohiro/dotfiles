#!/usr/bin/env ruby
# encoding: utf-8

require 'open-uri'
require 'time'
require 'rubygems'
require 'nokogiri'

module GitHub
  class Activity
    def initialize(user, token)
      @user  = user
      @token = token
      @last  = Time.now
    end

    def streaming
      display 'GitHub Activity streaming...'

      STDOUT.sync = true
      display 'Waiting new activities'

      feeds = [
        "https://github.com/#{@user}.private.atom?token=#{@token}",
        "https://github.com/#{@user}.private.actor.atom?token=#{@token}"
      ]

      loop do
        begin
          activities = []
          feeds.each do |uri|
            feed = Nokogiri::XML(open(uri))
            feed.css('entry').each do |activity|
              activities << {
                :id       => activity.at('id').text,
                :datetime => Time.parse(activity.at('published').text),
                :title    => activity.at('title').text,
                :author   => activity.at('author/name').text,
                :link     => activity.at('link').attributes['href'].text
              }
            end
          end

          activities.reverse_each do |activity|
            next if activity[:datetime] <= @last
            type = activity[:id][%r|tag:github.com,2008:(.+?)/\d+|, 1]
            display "#{type} ⮁ #{activity[:title]} #{activity[:link]}"
            sleep 10
          end

          @last = activities.first[:datetime]
          sleep 30
        rescue Exception => e
          display e.inspect
          e.backtrace.each { |l| puts "\t#{l}" }
          sleep 10
        end
      end
    end

    private
      def display(activity)
        puts "⭠ GitHub ⮁ #{activity}"
        sleep 5
      end
  end
end

if __FILE__ == $0
  require 'pit'
  config = Pit.get('github.com', :require => {
    :user  => 'your account in GitHub',
    :token => 'your private feed atom token in GitHub'
  })

  GitHub::Activity.new(config[:user], config[:token]).streaming
end

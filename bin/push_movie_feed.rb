#!/usr/bin/env ruby

require 'Date'

Dir.chdir "#{ENV['HOME']}/Development/okinawa_movie"

`ruby cron/okinawa_movies.rb > public/feed.xml`
`git commit -a -m 'gen #{Date.today.to_s} feed.'`
`git push origin master`
`git push heroku master`

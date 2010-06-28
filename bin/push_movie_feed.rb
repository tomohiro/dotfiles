#!/usr/bin/env ruby

require 'date'

Dir.chdir "#{ENV['HOME']}/Development/okinawa_movie"

`ruby cron/okinawa_movies.rb > public/feed.xml`
`git commit -a -m 'gen #{Date.today.to_s} feed, & sqlite3 database'`
`git push origin master`
`git push heroku master`

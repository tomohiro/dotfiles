#!/usr/bin/env ruby

require 'net/pop'
require 'rubygems'
require 'pit'

config = Pit.get('pop_mail', :require => {
  :pop_server => 'your pop server',
  :account    => 'your account',
  :password   => 'your password'
})


pop = Net::POP.new(config[:pop_server], 110)
pop.start(config[:account], config[:password])

puts pop.mails.count

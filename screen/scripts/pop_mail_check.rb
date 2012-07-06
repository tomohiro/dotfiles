#!/usr/bin/env ruby
# encoding: utf-8

require 'net/pop'
require 'nkf'
require 'rubygems'
require 'pit'

config = Pit.get('pop_mail', :require => {
  :pop_server => 'your pop server',
  :account    => 'your account',
  :password   => 'your password'
})

begin
  pop = Net::POP.start(config[:pop_server], 110, config[:account], config[:password])
  puts pop.mails.count

  header = pop.mails.reverse.first.header
  info = []
  if /Subject: (?<subject>.+)/ =~ NKF::nkf('-mw', header)
    info << subject.chomp
  end
  if /From: (?<from>.+)/ =~ NKF::nkf('-mw', header)
    info << from.chomp
  end
  puts info.join ' - '
rescue Exception => e
  puts e.to_s
end

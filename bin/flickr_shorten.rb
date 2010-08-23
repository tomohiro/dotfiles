#!/usr/bin/env ruby

def flickr_shorten( uri )
  i = %r|^http://(?:www\.)?flickr\.com/photos/.+?/(\d+)| =~ uri && $1.to_i
  return unless i
  s = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"
  l = s.length
  r = ''
  while i >= l do
    m = i % l
    r << s[m]
    i = (i - m) / l
  end
  r << s[i]
  'http://flic.kr/p/' + r.reverse
end

if __FILE__ == $0
  puts flickr_shorten(ARGV.first)
end

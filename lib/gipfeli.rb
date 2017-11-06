# frozen_string_literal: true
require 'dalli'

class Gipfeli
  def self.cache
    Dalli::Client.new((ENV['MEMCACHIER_SERVERS'] || '').split(','),
                      username: ENV['MEMCACHIER_USERNAME'],
                      password: ENV['MEMCACHIER_PASSWORD'],
                      failover: true,
                      socket_timeout: 1.5,
                      socket_failure_delay: 0.2)
  end

  def self.format_wish(wish)
    wish.to_s.sub(/^.*?add\s?/, '')
  end

  def self.add(wish)
    if !wish.empty?
      cache.set('list', "#{cache.get('list')}\n#{wish}", 36_000)
      "Your order of #{wish} has been added to the list."
    else
      'You need to tell me your order! (e.g. \'add gipfeli\')'
    end
  end

  def self.format_wish(wish)
    wish.to_s.sub(/^.*?add\s?/, '')
  end

  def self.clear
    list = cache.get('list')
    cache.set('list', nil) if list
    list
  end
end

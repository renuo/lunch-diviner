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

  def self.cache_get
    cache.get('list')
  end

  def self.cache_set(content)
    cache.set('list', content, 36_000)
  end

  def self.add(wish)
    if !wish.empty?
      cache_set("#{cache_get}\n#{wish}")
      "Your order of #{wish} has been added to the list."
    else
      'You need to tell me your order! (e.g. \'add gipfeli\')'
    end
  end

  def self.clear
    list = list
    cache_set(nil) if list
    list
  end
end

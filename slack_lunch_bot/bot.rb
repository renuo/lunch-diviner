# frozen_string_literal: true
require 'slack-ruby-bot'
require_relative '../lib/lunch_diviner'
require_relative '../lib/reishauer_diviner'
require_relative '../lib/siemens_diviner'
require_relative '../lib/andulino_diviner'

module SlackLunchBot
  class Bot < SlackRubyBot::Bot
    command 'reishauer?' do |client, data, _match|
      a = ReishauerDiviner.new
      client.message text: a.slack_formatted_menu, channel: data.channel
    end

    command 'siemens?' do |client, data, _match|
      a = SiemensDiviner.new
      client.message text: a.slack_formatted_menu, channel: data.channel
    end

    command 'andulino?' do |client, data, _match|
      a = AndulinoDiviner.new
      client.message text: a.slack_formatted_menu, channel: data.channel
    end

    command 'where?' do |client, data, _match|
      a = LunchDiviner.new
      client.message text: a.slack_formatted_menu, channel: data.channel
    end
  end
end

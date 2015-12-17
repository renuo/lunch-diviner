require 'Lunch_Diviner.rb'
require 'slack-ruby-bot'

ENV.update YAML.load_file('config/application.yml') rescue {}

module LunchBot
  class App < SlackRubyBot::App
  end

  class Lunch < SlackRubyBot::Commands::Base
    command 'reishauer?' do |client, data, _match|
      a = LunchDiviner.new
      client.message text: a.get_menu, channel: data.channel
    end
  end
end

LunchBot::App.instance.run
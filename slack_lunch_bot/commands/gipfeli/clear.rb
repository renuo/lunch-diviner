# frozen_string_literal: true

module SlackLunchBot
  module Commands
    class Clear < SlackRubyBot::Commands::Base
      command 'clear' do |client, data, _match|
        list = Gipfeli.show
        info_text = Gipfeli.clear
        client.say(channel: ENV['SLACK_FOOD_CHANNEL_ID'],
                   text: 'Someone is on their way to buy gipfeli. Your order should arrive '\
                         'in the breakroom or the kitchen sometime within the next minutes.') if list
        client.say(channel: data.channel,
                   text: info_text)
      end
    end
  end
end
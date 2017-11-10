# frozen_string_literal: true
require_relative '../../../lib/gipfeli'

module SlackLunchBot
  module Commands
    class Add < SlackRubyBot::Commands::Base
      command 'add' do |client, data, match|
        wish = Gipfeli.format_wish match
        client.say(channel: data.channel, text: Gipfeli.add(wish))
      end
    end
  end
end

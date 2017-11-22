# frozen_string_literal: true
require_relative '../../../lib/gipfeli'

module SlackLunchBot
  module Commands
    class Add < SlackRubyBot::Commands::Base
      command 'add' do |client, data, match|
        wish = Gipfeli.format_wish match
        info_text = Gipfeli.add(wish)
        client.say(channel: data.channel, text: info_text)
      end
    end
  end
end

# frozen_string_literal: true
require_relative '../../../lib/gipfeli'

module SlackLunchBot
  module Commands
    class Show < SlackRubyBot::Commands::Base
      command 'show' do |client, data, _match|
        info_text = Gipfeli.show
        client.say(channel: data.channel,
                   text: info_text)
      end
    end
  end
end

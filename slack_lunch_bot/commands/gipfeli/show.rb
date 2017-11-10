# frozen_string_literal: true
require_relative '../../../lib/gipfeli'

module SlackLunchBot
  module Commands
    class Show < SlackRubyBot::Commands::Base
      command 'remind' do |client, data, _match|
        list = Gipfelic.cache_get
        info_text = if list
                      "*Here is the current list:*\n#{list}"
                    else
                      'There are currently no orders.'
                    end
        client.say(channel: data.channel,
                   text: info_text)
      end
    end
  end
end

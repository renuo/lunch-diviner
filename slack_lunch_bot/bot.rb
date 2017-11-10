# frozen_string_literal: true
module SlackLunchBot
  class Bot < SlackRubyBot::Bot
    help do
      title 'Lunchbot'
      desc 'The bot for all your food needs.'

      command 'reishauer?' do
        desc 'Gives you todays menu at Reishauer.'
        long_desc 'Shows you the 3 meals available at Reishauer today.'
      end

      command 'add [wish]' do
        desc 'Adds [wish] to the shopping list.'
        long_desc 'Adds [wish] to the shopping list. The shopping list gets reset every day at night.'
      end

      command 'show' do
        desc 'Shows you the current shopping list.'
        long_desc 'Shows you everything currently in the shopping list.'
      end

      command 'remind' do
        desc 'Reminds people in #lunch to place their orders soon.'
        long_desc 'Sends a reminder to #lunch to place your orders within 5~ minutes. '\
                  'You will get a notification once the wait is over and you should then go shopping.'
      end

      command 'clear' do
        desc 'Clears the shopping list and notifies people in #lunch that you\'re going to buy food.'
        long_desc 'Empties the shopping list, showing you the contents and sending a notification to '\
                  '#lunch to tell people you\'re going shopping.'
      end
    end
  end
end

require './Lunch_Diviner.rb'
require 'sinatra'

config = {
    'channel'          => '#lunch',
    'name'             => 'lunchbot',
    'incoming_webhook' =>  ENV['slack_incoming_webhook'],
    'outgoing_token'   =>  ENV['slack_outgoing_token']
}

bot = Slackbotsy::Bot.new(config) do

  hear /reishauer\?/i do
    a = LunchDiviner.new
    post_message a.get_menu, channel: '#lunch'
  end

end

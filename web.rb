require 'sinatra/base'

module SlackLunchBot
  class Web < Sinatra::Base
    get '/' do
      'yay it works'
    end
  end
end


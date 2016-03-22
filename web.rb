require 'sinatra/base'
require_relative 'lib/lunch_diviner'
require 'tilt/erb'

set :public_folder, '#{settings.root}/public'

module SlackLunchBot
  class Web < Sinatra::Base
    get '/' do
      erb :main
    end
  end
end


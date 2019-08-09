# frozen_string_literal: true
require 'sinatra'
require_relative 'lib/reishauer_diviner'
require 'tilt/erb'

configure do
  set :public_folder, '#{settings.root}/public'
end

module SlackLunchBot
  class Web < Sinatra::Base
    get '/' do
      headers({ 'X-Frame-Options' => 'ALLOWALL' })
      erb :main
    end
  end
end

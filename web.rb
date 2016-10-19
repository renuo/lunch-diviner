# frozen_string_literal: true
require 'sinatra'
require_relative 'lib/lunch_diviner'
require 'tilt/erb'

configure do
  set :public_folder, '#{settings.root}/public'
end

module SlackLunchBot
  class Web < Sinatra::Base
    get '/' do
      erb :main
    end
  end
end

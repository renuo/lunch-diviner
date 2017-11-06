# frozen_string_literal: true
require 'slack-ruby-bot'
require 'slack_lunch_bot/commands/lunch'
require 'slack_lunch_bot/commands/gipfeli/add'
require 'slack_lunch_bot/bot'

begin
  ENV.update YAML.load_file('config/application.yml')
rescue
  {}
end

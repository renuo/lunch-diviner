require 'slack-ruby-bot'
require 'slack-lunch-bot/commands/lunch'
require 'slack-lunch-bot/bot'

ENV.update YAML.load_file('config/application.yml') rescue {}

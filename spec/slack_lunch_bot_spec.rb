# frozen_string_literal: false
require 'spec_helper'

describe SlackLunchBot::Bot do
  subject { SlackLunchBot::Bot.instance }

  it_behaves_like 'a slack ruby bot'

  before { mock_gipfeli }

  describe 'command add' do
    context 'with no order given' do
      it 'responds with a how' do
        expect(message: "#{SlackRubyBot.config.user} add")
          .to respond_with_slack_message('You need to tell me your order! (e.g. \'add gipfeli\')')
      end
    end

    context 'with an order given' do
      it 'responds with a confirmation' do
        expect(message: "#{SlackRubyBot.config.user} add gipfeli")
          .to respond_with_slack_message('Your order of \'gipfeli\' has been added to the list.')
      end
    end
  end

  describe 'command show' do
    it 'gives you the list of orders' do
      expect(message: "#{SlackRubyBot.config.user} show")
        .to respond_with_slack_message("*Here is the current list:*\ngipfeli")
    end
  end

  # There isn't really a way to test the messages seperately, or even test what channel the message is sent to, so
  #   the following 2 tests all send in the lunch channel so that both messages appear in the same place.
  describe 'command clear' do
    it 'shows list of orders and notifies lunch chat' do
      expect(message: "#{SlackRubyBot.config.user} clear", channel: ENV['SLACK_FOOD_CHANNEL_ID'])
        .to respond_with_slack_messages(['Someone is on their way to buy gipfeli. Your order should arrive '\
                                          'in the breakroom or the kitchen sometime within the next minutes.',
                                         "*Here is the current list:*\ngipfeli"])
    end
  end

  # I do not know how to sensibly test it, it being in a thread, or how to rewrite the command
  #   itself to be more test friendly
  describe 'command remind' do
    xit 'tells lunch to order and then reminds you' do
      allow(SlackLunchBot::Commands::Remind).to receive(:sleep) { true }
      expect(message: "#{SlackRubyBot.config.user} remind", channel: ENV['SLACK_FOOD_CHANNEL_ID'])
        .to respond_with_slack_messages(["Someone is about to go buy gipfeli!\nPlace your orders in "\
                                          "the next ~5 minutes or it'ts too late!",
                                         "You waited long enough, you can go buy them now! (Don\'t forget to clear!)"])
    end
  end

  def mock_gipfeli
    allow(Gipfeli).to receive(:cache) { true }
    allow(Gipfeli.cache).to receive(:get) { 'gipfeli' }
    allow(Gipfeli.cache).to receive(:set) { true }
  end
end

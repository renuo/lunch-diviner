# frozen_string_literal: true
require 'spec_helper'
require 'lunch_diviner'

describe LunchDiviner do
  let(:reishauer_diviner_mock) { instance_double('ReishauerDiviner', slack_formatted_menu: 'REISHAUER_MENU') }
  let(:siemens_diviner_mock) { instance_double('ReishauerDiviner', slack_formatted_menu: 'SIEMENS_MENU') }
  let(:andulino_diviner_mock) { instance_double('ReishauerDiviner', slack_formatted_menu: 'ANDULINO_MENU') }

  before(:each) do
    allow(ReishauerDiviner).to receive(:new).and_return(reishauer_diviner_mock)
    allow(SiemensDiviner).to receive(:new).and_return(siemens_diviner_mock)
    allow(AndulinoDiviner).to receive(:new).and_return(andulino_diviner_mock)
  end

  subject { LunchDiviner.new.slack_formatted_menu }

  let(:menu) { "```REISHAUER```\nREISHAUER_MENU\n\n```SIEMENS MENSA```\nSIEMENS_MENU\n\n```ANDULINO```\nANDULINO_MENU" }

  it { is_expected.to eq(menu) }
end

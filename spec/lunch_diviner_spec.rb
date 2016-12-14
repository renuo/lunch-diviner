# frozen_string_literal: true
require 'spec_helper'

def mock_request_body
  mocked_result = File.open('spec/data/sample_request.html')
  expect_any_instance_of(LunchDiviner).to receive(:html_menu_content).and_return(mocked_result)
end

describe LunchDiviner do
  before(:each) { mock_request_body }

  let(:monday_menu) do
    { title: 'Akropolis Burger',
      price: '9.80',
      description: 'Rindfleisch (CH) im  Pita Brot mit Tzatziki, Feta und Tomatenscheib Country Fries und Tagessalat' }
  end

  let(:tuesday_menu) do
    { title: 'Rippli und Würstli (CH)',
      price: '9.80',
      description: 'Senf Petersilienkartoffeln Sauerkraut' }
  end

  it 'returns menu of weekdays' do
    lunch_deviner = LunchDiviner.new
    expect(lunch_deviner.meal(LunchDiviner::MENU, 1)).to eq(monday_menu)
    expect(lunch_deviner.meal(LunchDiviner::MENU, 2)).to eq(tuesday_menu)
  end

  it 'returns a formatted slack message' do
    lunch_deviner = LunchDiviner.new
    lunch_deviner.slack_formatted_menu(1)
    expect(lunch_deviner).to receive(:slack_formatted_meal).exactly(3).times.and_return('MEAL')
    expect(lunch_deviner.slack_formatted_menu(1)).to eq("MEAL\n\nMEAL\n\nMEAL")
  end

  it 'returns a slack_formatted_meal' do
    formatted_meal = LunchDiviner.new.send(:slack_formatted_meal,
                                           title: 'title', price: 'price', description: 'description')
    expect(formatted_meal).to eq("*title* (price)\ndescription")
  end

  it 'returns a html_formatted_meal' do
    formatted_meal = LunchDiviner.new.send(:html_formatted_meal,
                                           title: 'title', price: 'price', description: 'description')
    expect(formatted_meal).to eq('<h3 class="title"><span class="menu-name">title</span> '\
    '<span class="price">(price)</span></h3><p class="description">description</p>')
  end
end

# frozen_string_literal: true
require 'spec_helper'
require 'reishauer_diviner'

def mock_request_body(mock_file)
  mocked_result = File.open(mock_file)
  expect_any_instance_of(ReishauerDiviner).to receive(:html_menu_content).and_return(mocked_result)
end

describe ReishauerDiviner do
  let(:mock_file) { 'spec/data/reishauer_sample_request.html' }
  before(:each) { mock_request_body(mock_file) }

  let(:todays_menu) do
    { title: 'Schweinshalsbraten(CH)',
      price: '9.80',
      description: 'Thymianjus, Kartoffelstock, Gemüse oder Menusalat' }
  end

  it 'returns menu of actual day' do
    lunch_deviner = ReishauerDiviner.new
    expect(lunch_deviner.meal(ReishauerDiviner::MENU, 4)).to eq(todays_menu)
  end

  it 'returns a formatted slack message' do
    lunch_deviner = ReishauerDiviner.new
    lunch_deviner.slack_formatted_menu(4)
    expect(lunch_deviner).to receive(:slack_formatted_meal).exactly(3).times.and_return('MEAL')
    expect(lunch_deviner.slack_formatted_menu(4)).to eq("MEAL\n\nMEAL\n\nMEAL")
  end

  it 'returns a slack_formatted_meal' do
    formatted_meal = ReishauerDiviner.new.send(:slack_formatted_meal,
                                           title: 'title', price: 'price', description: 'description')
    expect(formatted_meal).to eq("*title* (price)\ndescription")
  end

  it 'returns a html_formatted_meal' do
    formatted_meal = ReishauerDiviner.new.send(:html_formatted_meal,
                                           title: 'title', price: 'price', description: 'description')
    expect(formatted_meal).to eq('<h3 class="title"><span class="menu-name">title</span> '\
    '<span class="price">(price)</span></h3><p class="description">description</p>')
  end

  context 'when has not all menus' do
    let(:mock_file) { 'spec/data/reishauer_sample_request_missing_menu.html' }
    let(:missing_menu) { { description: '', price: '', title: '' } }
    let(:tuesday_menu) do
      { description: 'Champignonsauce, Nudeln, Gemüse oder Menusalat',
        price: '9.80',
        title: 'Schweinsrahmschnitzel(CH)' }
    end

    it 'returns an empty menu' do
      lunch_deviner = ReishauerDiviner.new
      expect(lunch_deviner.meal(ReishauerDiviner::MENU, 1)).to eq(missing_menu)
    end
  end
end

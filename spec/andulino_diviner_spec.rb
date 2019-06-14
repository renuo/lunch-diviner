# frozen_string_literal: true
require 'andulino_diviner'
require 'spec_helper'

def mock_request_body(mock_file)
  mocked_result = File.open(mock_file)
  expect_any_instance_of(AndulinoDiviner).to receive(:html_menu_content).and_return(mocked_result)
end

describe AndulinoDiviner do
  let(:mock_file) { 'spec/data/andulino_sample_request.html' }
  before(:each) { mock_request_body(mock_file) }

  it 'returns menu of weekdays' do
    lunch_deviner = AndulinoDiviner.new
    expect(lunch_deviner.menu_image_url).to eq('https://andulino.ch/wp-content/uploads/2019/06/TAGES-MENU-2019-06-11-06-14.jpg')
  end
end

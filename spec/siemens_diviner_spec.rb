# frozen_string_literal: true
require 'siemens_diviner'
require 'spec_helper'

def mock_request_body(mock_file)
  mocked_result = File.open(mock_file)
  expect_any_instance_of(SiemensDiviner).to receive(:html_menu_content).and_return(mocked_result)
end

describe SiemensDiviner do
  let(:mock_file) { 'spec/data/siemens_sample_request.html' }
  before(:each) { mock_request_body(mock_file) }

  let(:chefs_choice) do
    { title: 'Schweins Cordon Bleu',
      price: '17.90',
      description: 'mit Bratensauce dazu Country Cuts und Grillgemüse' }
  end

  let(:season_market) do
    { title: 'Gedämpftes MSC Seelachsfilet',
      price: '14.50',
      description: 'Kerbelsauce Pilaw Reis Streifengemüse' }
  end

  let(:free_choice) do
    { title: 'Käse-, Zwiebel- oder Karotten - Ingwerwähe',
      price: '12.90',
      description: 'mit Käsemischung dazu bunte Blattsalate' }
  end

  let(:dailys) do
    { title: 'Pizza dello chef',
      price: '17.90',
      description: 'Tomaten, Büffel-Mozzarella, Peperoncini, Schinken, Champignons und Oliven' }
  end

  it 'returns menu of weekdays' do
    lunch_deviner = SiemensDiviner.new
    expect(lunch_deviner.meal(SiemensDiviner::CHEFS_CHOICE)).to eq(chefs_choice)
    expect(lunch_deviner.meal(SiemensDiviner::SEASON_MARKET)).to eq(season_market)
    expect(lunch_deviner.meal(SiemensDiviner::FREE_CHOICE)).to eq(free_choice)
    expect(lunch_deviner.meal(SiemensDiviner::DAILYS)).to eq(dailys)
  end
end

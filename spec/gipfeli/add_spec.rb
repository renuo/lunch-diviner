require 'spec_helper'

describe Gipfeli do
  let(:normal_wish) { 'gipfeli add gipfeli' }
  let(:wish_with_at) { '@gipfeli add gipfeli' }
  let(:empty_wish) { 'gipfeli add' }
  let(:empty_wish_with_space) { 'gipfeli add ' }

  let(:failure) { 'You need to tell me your order! (e.g. \'add gipfeli\')' }
  let(:success) { "Your order of #{wish} has been added to the list." }

  it 'formats the wish correctly' do
    expect(Gipfeli.format_wish(normal_wish)).to eq('gipfeli')
    expect(Gipfeli.format_wish(wish_with_at)).to eq('gipfeli')
    expect(Gipfeli.format_wish(empty_wish)).to eq('')
    expect(Gipfeli.format_wish(empty_wish_with_space)).to eq('')
  end

  context 'With a valid wish' do
    let(:wish) { Gipfeli.format_wish normal_wish }
    it 'returns the success message' do
      mock_gipfeli
      expect(Gipfeli.add(wish)).to eq(success)
    end
    context 'sent with @' do
      let(:wish) { Gipfeli.format_wish wish_with_at }
      it 'returns the success message' do
        mock_gipfeli
        expect(Gipfeli.add(wish)).to eq(success)
      end
    end
  end

  context 'With an invalid wish' do
    let(:wish) { Gipfeli.format_wish empty_wish }
    it 'returns the failure message' do
      expect(Gipfeli.add(wish)).to eq(failure)
    end
    context 'with a trailing space' do
      let(:wish) { Gipfeli.format_wish empty_wish_with_space }
      it 'returns the failure message' do
        expect(Gipfeli.add(wish)).to eq(failure)
      end
    end
  end

  def mock_gipfeli
    allow(Gipfeli).to receive(:cache) { true }
    allow(Gipfeli.cache).to receive(:get) { '' }
    allow(Gipfeli.cache).to receive(:set) { true }
  end
end

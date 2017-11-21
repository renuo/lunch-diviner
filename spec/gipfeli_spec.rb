# frozen_string_literal: true
require 'spec_helper'

describe Gipfeli do
  let(:normal_wish) { 'gipfeli add gipfeli' }
  let(:wish_with_at) { '@gipfeli add gipfeli' }
  let(:empty_wish) { 'gipfeli add' }
  let(:empty_wish_with_space) { 'gipfeli add ' }

  let(:failure) { 'You need to tell me your order! (e.g. \'add gipfeli\')' }
  let(:success) { "Your order of '#{wish}' has been added to the list." }

  let(:list) { "*Here is the current list:*\nwish" }
  let(:empty_list) { '*There are currently no orders.*' }

  before { mock_gipfeli }

  describe '#format_wish' do
    it 'formats the wish correctly' do
      expect(described_class.format_wish(normal_wish)).to eq('gipfeli')
      expect(described_class.format_wish(wish_with_at)).to eq('gipfeli')
      expect(described_class.format_wish(empty_wish)).to eq('')
      expect(described_class.format_wish(empty_wish_with_space)).to eq('')
    end
  end

  describe '#add' do
    subject { described_class.add(wish) }

    context 'With a valid wish' do
      let(:wish) { described_class.format_wish normal_wish }
      it { is_expected.to eq(success) }

      context 'sent with @' do
        let(:wish) { described_class.format_wish wish_with_at }
        it { is_expected.to eq(success) }
      end
    end

    context 'With an invalid wish' do
      let(:wish) { described_class.format_wish empty_wish }
      it { is_expected.to eq(failure) }

      context 'with a trailing space' do
        let(:wish) { described_class.format_wish empty_wish_with_space }
        it { is_expected.to eq(failure) }
      end
    end
  end

  describe '#show' do
    subject { described_class.show }
    context 'with a list containing items' do
      it { is_expected.to eq(list) }
    end

    context 'with an empty list' do
      before { allow(described_class.cache).to receive(:get) { nil } }
      it { is_expected.to eq(empty_list) }
    end
  end

  describe '#clear' do
    subject { described_class.clear }
    context 'with a list containing items' do
      it { is_expected.to eq(list) }
    end

    context 'with an empty list' do
      before { allow(described_class.cache).to receive(:get) { nil } }
      it { is_expected.to eq(empty_list) }
    end
  end

  def mock_gipfeli
    allow(described_class).to receive(:cache) { true }
    allow(described_class.cache).to receive(:get) { 'wish' }
    allow(described_class.cache).to receive(:set) { true }
  end
end

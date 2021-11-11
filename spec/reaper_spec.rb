# frozen_string_literal: true

RSpec.describe Parodikos::Reaper do
  let(:reaper) do
    described_class.new(screen_name: 'nikosfertakis', before: Date.new(2021, 10, 10))
  end

  describe '#reap!' do
    context 'when dry run' do
      it 'returns the number of tweets to be deleted' do
        allow(reaper).to receive(:dry!).and_return(10)
        allow(reaper).to receive(:destroy!)

        expect(reaper.reap!(dry: true)).to eq(10)
      end
    end

    context 'when for real' do
      let(:tweet1) do
        { 'id' => 1, 'text' => 'a tweet' }
      end

      let(:tweet2) do
        { 'id' => 2, 'text' => 'another tweet' }
      end

      it 'calls destroy accordingly' do
        allow(Parodikos::Timeline).to receive(:each_tweet_before).and_yield(tweet1).and_yield(tweet2)
        expect(reaper).to receive(:destroy!).with(1)
        expect(reaper).to receive(:destroy!).with(2)
        expect(reaper.reap!(dry: false)).to eq(2)
      end
    end
  end
end

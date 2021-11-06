RSpec.describe Parodikos::StatusFinder do
  let(:statuses) { double }
  let(:screen_name) { 'username' }

  let(:status_finder) do
    described_class.new(screen_name: screen_name, statuses: statuses)
  end

  let(:tweets) do
    [{
      'created_at' => 'Thu Apr 06 15:28:43 +0000 2017',
      'id' => 850_007_368_138_018_817,
      'text' => 'RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP'
    },
     {
       'created_at' => 'Thu Apr 06 18:28:43 +0000 2017',
       'id' => 850_007_368_138_018_818,
       'text' => 'this is a test'
     },
     {
       'created_at' => 'Thu Apr 07 15:28:43 +0000 2017',
       'id' => 850_007_368_138_018_819,
       'text' => 'this is a test'
     }]
  end

  let(:older_tweets) do
    [{
      'created_at' => 'Thu Apr 03 15:28:43 +0000 2017',
      'id' => 850_007_368_138_018_814,
      'text' => 'RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP'
    },
     {
       'created_at' => 'Thu Apr 05 18:28:43 +0000 2017',
       'id' => 850_007_368_138_018_815,
       'text' => 'this is a test'
     },
     {
       'created_at' => 'Thu Apr 06 13:28:43 +0000 2017',
       'id' => 850_007_368_138_018_816,
       'text' => 'this is a test'
     }]
  end

  describe '#max_before' do
    context 'when there is none' do
      it 'returns nil' do
        allow(statuses).to receive(:fetch).and_return(tweets)
        expect(status_finder.max_before(Date.new(2017, 4, 6)))
          .to be_nil
      end
    end

    context 'when a tweet exists' do
      it 'returns the maximum tweet id before the 5th of April' do
        allow(statuses).to receive(:fetch).and_return(tweets, older_tweets)
        expect(status_finder.max_before(Date.new(2017, 4, 5)))
          .to eq(850_007_368_138_018_814)
      end

      it 'returns the maximum tweet id before the 6th of April' do
        allow(statuses).to receive(:fetch).and_return(tweets, older_tweets)
        expect(status_finder.max_before(Date.new(2017, 4, 6)))
          .to eq(850_007_368_138_018_815)
      end

      it 'returns the maximum tweet id before the 7th of April' do
        allow(statuses).to receive(:fetch).and_return(tweets, older_tweets)
        expect(status_finder.max_before(Date.new(2017, 4, 7)))
          .to eq(850_007_368_138_018_818)
      end

      it 'returns the maximum tweet id before the 8th of April' do
        allow(statuses).to receive(:fetch).and_return(tweets, older_tweets)
        expect(status_finder.max_before(Date.new(2017, 4, 8)))
          .to eq(850_007_368_138_018_819)
      end
    end
  end
end

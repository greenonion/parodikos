# frozen_string_literal: true

RSpec.describe Parodikos::Timeline do
  let(:timeline) do
    described_class.new(screen_name: 'nikosfertakis')
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

  describe '#each' do
    it 'passes through all tweets exactly once' do
      allow(timeline).to receive(:tweets_before).with(nil).and_return(tweets)
      allow(timeline).to receive(:tweets_before).with(850_007_368_138_018_816).and_return(older_tweets)
      allow(timeline).to receive(:tweets_before).with(850_007_368_138_018_813).and_return([])

      expect { |b| timeline.each(&b) }.to yield_successive_args(*(tweets + older_tweets))
    end
  end
end

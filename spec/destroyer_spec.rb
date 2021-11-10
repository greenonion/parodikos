# frozen_string_literal: true

RSpec.describe Parodikos::Destroyer do
  describe '#destroy!' do
    let(:destroyer) { described_class.new(tweet_id: 123_456) }

    context 'when the request was unsuccessful' do
      let(:response) { double('response', status: 403) }

      it 'returns the http status' do
        allow(destroyer).to receive(:response).and_return(response)

        expect(destroyer.destroy!).to eq(403)
      end
    end

    context 'when the request was successful' do
      let(:body) do
        <<~TXT
          {
            "created_at": "Thu Apr 06 15:28:43 +0000 2017",
            "id": 850007368138018817,
            "text": "RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP"
          }
        TXT
      end

      let(:response) { double('response', status: 200, body: body) }

      let(:parsed_body) do
        {
          'created_at' => 'Thu Apr 06 15:28:43 +0000 2017',
          'id' => 850_007_368_138_018_817,
          'text' => 'RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP'
        }
      end

      it 'parses the response body' do
        allow(destroyer).to receive(:response).and_return(response)

        expect(destroyer.destroy!).to eq(parsed_body)
      end
    end
  end
end

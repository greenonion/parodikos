# frozen_string_literal: true

RSpec.describe Parodikos::Statuses do
  describe '#data' do
    let(:statuses) { described_class.new(screen_name: 'nikosfertakis', count: 10) }

    context 'when the request was unsuccessful' do
      let(:response) { double('response', status: 404) }

      it 'returns an empty string' do
        allow(statuses).to receive(:response).and_return(response)

        expect(statuses.data).to eq('')
      end
    end

    context 'when the request was successful' do
      let(:body) do
        <<~TXT
          [
                {
                "created_at": "Thu Apr 06 15:28:43 +0000 2017",
                "id": 850007368138018817,
                "text": "RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP"
                },
                {
                "created_at": "Thu Apr 07 15:28:43 +0000 2017",
                "id": 850007368138018818,
                "text": "this is a test"
                }
          ]
        TXT
      end

      let(:response) { double('response', status: 200, body: body) }

      let(:parsed_body) do
        [{
          'created_at' => 'Thu Apr 06 15:28:43 +0000 2017',
          'id' => 850_007_368_138_018_817,
          'text' => 'RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP'
        },
         {
           'created_at' => 'Thu Apr 07 15:28:43 +0000 2017',
           'id' => 850_007_368_138_018_818,
           'text' => 'this is a test'
         }]
      end

      it 'parses the response body' do
        allow(statuses).to receive(:response).and_return(response)

        expect(statuses.data).to eq(parsed_body)
      end
    end
  end
end

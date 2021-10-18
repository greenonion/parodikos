# frozen_string_literal: true

RSpec.describe Parodikos::Headers do
  let(:method) { 'POST' }
  let(:url) { 'https://api.twitter.com/1.1/statuses/update.json' }
  let(:consumer_secret) { 'kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw' }
  let(:token_secret) { 'LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE' }
  let(:consumer_key) { 'xvz1evFS4wEEPTGEFPHBog' }
  let(:nonce) { 'kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg' }
  let(:signature) { 'tnnArxj06cWHq44gCs1OSKk/jLY=' }
  let(:timestamp) { '1318622958' }
  let(:token) { '370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb' }
  let(:headers) do
    described_class.new(method, url, consumer_key: consumer_key, token: token,
                        consumer_secret: consumer_secret, token_secret: token_secret,
                        params: {}, body: nil)
  end

  describe '#authorization' do
    let(:authorization) do
      'OAuth oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog", oauth_nonce="kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg", oauth_signature="tnnArxj06cWHq44gCs1OSKk%2FjLY%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1318622958", oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb", oauth_version="1.0"'
    end

    it 'builds the authorization header' do
      allow(headers).to receive(:nonce).and_return(nonce)
      allow(headers).to receive(:signature).and_return(signature)
      allow(headers).to receive(:timestamp).and_return(timestamp)
      expect(headers.authorization).to eq(authorization)
    end
  end

  describe '#signed_parameters' do
    it 'has the authorization parameters plus signature' do
      signed_parameters = headers.signed_parameters
      signed_parameters.delete('oauth_signature')
      expect(signed_parameters).to eq(headers.authorization_parameters)
    end
  end
end

# frozen_string_literal: true

RSpec.describe Parodikos::Signer do

  let(:params) do
    {
      'status' => 'Hello Ladies + Gentlemen, a signed OAuth request!',
      'include_entities' => 'true',
      'oauth_consumer_key' => 'xvz1evFS4wEEPTGEFPHBog',
      'oauth_nonce' => 'kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg',
      'oauth_signature_method' => 'HMAC-SHA1',
      'oauth_timestamp' => '1318622958',
      'oauth_token' => '370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb',
      'oauth_version' => '1.0'
    }
  end

  let(:method) { 'POST' }
  let(:url) { 'https://api.twitter.com/1.1/statuses/update.json' }
  let(:consumer_secret) { 'kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw' }
  let(:oauth_token_secret) { 'LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE' }

  let(:signer) do
    described_class.new(method, url, consumer_secret: consumer_secret,
                        params: params, oauth_token_secret: oauth_token_secret)
  end

  describe '#signature' do
    let(:signature) { 'hCtSmYh+iHYCEqBWrE7C7hYmtUk=' }

    it 'calculates the signature' do
      expect(signer.signature).to eq(signature)
    end
  end

  describe '#parameter_string' do
    let(:param_string) do
      'include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21'
    end

    it 'builds the parameter string' do
      expect(signer.parameter_string).to eq(param_string)
    end
  end

  describe '#signature_base_string' do
    let(:signature_base_string) do
      'POST&https%3A%2F%2Fapi.twitter.com%2F1.1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521'
    end

    it 'creates the signature base string' do
      expect(signer.signature_base_string).to eq(signature_base_string)
    end
  end

  describe '#signing_key' do
    context 'when the token secret is known' do
      let(:signing_key) do
        'kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE'
      end

      it 'creates the signing key' do
        expect(signer.signing_key).to eq(signing_key)
      end
    end

    context 'when the token secret is not known' do
      let(:oauth_token_secret) {}
      let(:signing_key) do
        'kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&'
      end

      it 'creates the signing key' do
        expect(signer.signing_key).to eq(signing_key)
      end
    end
  end
end

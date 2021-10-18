# frozen_string_literal: true

require 'erb'
require 'openssl'
require 'securerandom'

module Parodikos
  class Headers
    attr_reader :method, :url, :consumer_key, :token, :consumer_secret, :token_secret,
                :params, :body

    def initialize(method, url, consumer_key:, token:, consumer_secret:, token_secret: nil, params: nil, body: nil)
      @method = method
      @url = url
      @consumer_key = consumer_key
      @token = token
      @consumer_secret = consumer_secret
      @token_secret = token_secret
      @params = params
      @body = body
    end

    def authorization
      "OAuth #{serialized_parameters}"
    end

    def serialized_parameters
      signed_parameters.sort_by { |k, _| ERB::Util.url_encode(k) }.map do |k, v|
        str = ERB::Util.url_encode(k)
        str << '="'
        str << ERB::Util.url_encode(v)
        str << '"'
      end.join(', ')
    end

    def authorization_parameters
      # Only calculate these once to ensure nonce and timestamp don't change
      @authorization_parameters ||= {
        'oauth_consumer_key' => consumer_key,
        'oauth_nonce' => nonce,
        'oauth_signature_method' => signature_method,
        'oauth_timestamp' => timestamp,
        'oauth_token' => token,
        'oauth_version' => version
      }
    end

    def signed_parameters
      authorization_parameters.merge('oauth_signature' => signature)
    end

    def signature
      sig_params = params.merge(authorization_parameters)
      Signer.new(method, url, consumer_secret: consumer_secret, params: sig_params,
                 body: body, token_secret: token_secret).signature
    end

    def nonce
      OpenSSL::Random.random_bytes(16).unpack('H*')[0]
    end

    def signature_method
      'HMAC-SHA1'
    end

    def timestamp
      Time.now.to_i.to_s
    end

    def version
      '1.0'
    end
  end
end

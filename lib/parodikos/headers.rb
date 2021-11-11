# frozen_string_literal: true

require 'erb'
require 'openssl'
require 'securerandom'

module Parodikos
  # Class responsible for creating the headers needed for interaction with the
  # Twitter API
  class Headers
    attr_reader :method, :url, :consumer_key, :token, :consumer_secret, :token_secret,
                :params, :body, :credentials

    def initialize(method, url, credentials:, params: nil, body: nil)
      @method = method
      @url = url
      @credentials = credentials
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
        'oauth_consumer_key' => credentials.api_key,
        'oauth_nonce' => nonce,
        'oauth_signature_method' => signature_method,
        'oauth_timestamp' => timestamp,
        'oauth_token' => credentials.access_token,
        'oauth_version' => version
      }
    end

    def signed_parameters
      authorization_parameters.merge('oauth_signature' => signature)
    end

    def signature
      sig_params = params.merge(authorization_parameters)
      Signer.new(method, url, consumer_secret: credentials.api_secret_key, params: sig_params,
                              body: body, token_secret: credentials.access_token_secret).signature
    end

    def nonce
      OpenSSL::Random.random_bytes(16).unpack1('H*')
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

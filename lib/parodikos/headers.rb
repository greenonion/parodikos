# frozen_string_literal: true

require 'erb'
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
      params = authorization_parameters.map do |k, v|
        str = ERB::Util.url_encode(k)
        str << '="'
        str << ERB::Util.url_encode(v)
        str << '"'
      end.join(', ')

      "OAuth #{params}"
    end

    def authorization_parameters
      [['oauth_consumer_key', consumer_key],
       ['oauth_nonce', nonce],
       ['oauth_signature', signature],
       ['oauth_signature_method', signature_method],
       ['oauth_timestamp', timestamp],
       ['oauth_token', token],
       ['oauth_version', version]]
    end

    def signature
      Signer.new(method, url, consumer_secret: consumer_secret, params: params,
                 body: body, token_secret: token_secret).signature
    end

    def nonce
      SecureRandom.urlsafe_base64
    end

    def signature_method
      'HMAC-SHA1'
    end

    def timestamp
      Time.now.to_i
    end

    def version
      '1.0'
    end
  end
end

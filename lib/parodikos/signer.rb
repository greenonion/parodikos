# frozen_string_literal: true
require 'base64'
require 'erb'
require 'openssl'

require 'pry'

module Parodikos
  class Signer
    attr_reader :params, :method, :url, :consumer_secret, :oauth_token_secret

    def initialize(method, url, consumer_secret:, params: nil, body: nil, oauth_token_secret: nil)
      @method = method
      @url = url
      @consumer_secret = consumer_secret
      @params = params
      @body = body
      @oauth_token_secret = oauth_token_secret
    end

    def signature
      hmac = OpenSSL::HMAC.digest('sha1', signing_key, signature_base_string)
      Base64.strict_encode64(hmac)
    end

    # Sorts and url encodes all params according to RFC 3986.
    def parameter_string
      sorted_params = params.sort_by { |k, _| ERB::Util.url_encode(k) }
      percent_encode_form(sorted_params)
    end

    def signature_base_string
      str = method.upcase
      str << '&'
      str << ERB::Util.url_encode(url)
      str << '&'
      str << ERB::Util.url_encode(parameter_string)
      str
    end

    def signing_key
      str = ERB::Util.url_encode(consumer_secret)
      str << "&"
      str << ERB::Util.url_encode(oauth_token_secret) if oauth_token_secret
      str
    end

    # This is just URI.encode_www_form but altered to use ERB::Util.url_encode
    # in order to be compatible with RFC 3986.
    #
    # @param enum [Array] the form to encode
    # @return [String] the encoded form
    def percent_encode_form(enum)
      enum.map do |k,v|
        if v.nil?
          ERB::Util.url_encode(k)
        elsif v.respond_to?(:to_ary)
          v.to_ary.map do |w|
            str = ERB::Util.url_encode(k)
            unless w.nil?
              str << '='
              str << ERB::Util.url_encode(w)
            end
          end.join('&')
        else
          str = ERB::Util.url_encode(k)
          str << '='
          str << ERB::Util.url_encode(v)
        end
      end.join('&')
    end
  end
end

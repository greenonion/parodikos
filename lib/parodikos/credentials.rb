# frozen_string_literal: true

require 'yaml'

module Parodikos
  # Twitter API credentials handling.
  class Credentials
    attr_reader :api_key, :api_secret_key, :access_token, :access_token_secret

    def initialize(api_key: nil, api_secret_key: nil, access_token: nil, access_token_secret: nil)
      @api_key = api_key
      @api_secret_key = api_secret_key
      @access_token = access_token
      @access_token_secret = access_token_secret
    end

    def self.from_file!(filename:)
      credentials = YAML.safe_load(File.read(filename))
      new(api_key: credentials['api-key'],
          api_secret_key: credentials['api-secret-key'],
          access_token: credentials['access-token'],
          access_token_secret: credentials['access-token-secret'])
    end
  end
end

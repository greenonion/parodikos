# frozen_string_literal: true

require 'faraday'
require 'yaml'

module Parodikos
  # Client class for the Twitter API
  class Client
    attr_reader :method, :url, :credentials, :params, :client

    def initialize(method, url, params: {}, body: {}, client: Faraday)
      @method = method
      @url = url
      @params = params
      @body = body
      @credentials = credentials!
      @client = client
    end

    def perform
      case method
      when 'get'
        perform_get
      when 'post'
        perform_post
      end
    end

    def self.perform!(method, url, params: {}, body: {})
      new(method, url, params: params, body: body).perform
    end

    private

    def headers
      Headers.new(@method, @url,
                  consumer_key: credentials['api-key'],
                  consumer_secret: credentials['api-secret-key'],
                  token: credentials['access-token'],
                  token_secret: credentials['access-token-secret'],
                  params: params)
    end

    def credentials!
      YAML.safe_load(File.read('credentials.yml'))
    end

    def perform_get
      client.get(url) do |req|
        req.params = params
        req.headers['Authorization'] = headers.authorization
        req.headers['Accept'] = '*/*'
      end
    end

    def perform_post
      client.post(url) do |req|
        req.params = params
        req.headers['Authorization'] = headers.authorization
        req.headers['Accept'] = '*/*'
      end
    end
  end
end

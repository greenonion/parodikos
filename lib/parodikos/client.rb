# frozen_string_literal: true

require 'faraday'
require 'yaml'

# GET https://api.twitter.com/1.1/favorites/list.json?count=200&screen_name=twitterdev
module Parodikos
  class Client
    attr_reader :method, :url, :credentials, :params

    def initialize(method, url, params: {}, body: {})
      @method = method
      @url = url
      @params = params
      @body = body
      @credentials = credentials!
    end

    def perform
      case method
      when 'get'
        perform_get
      when 'post'
        perform_post
      end
    end

    private

    def headers
      Headers.new(@method, @url,
                  consumer_key: credentials['api-key'],
                  consumer_secret: credentials['api-secret-key'],
                  token: credentials['access-token'],
                  token_secret: credentials['access-token-secret'],
                  params: params )
    end

    def credentials!
      YAML.safe_load(File.read('credentials.yml'))
    end

    def perform_get
      Faraday.get(url) do |req|
        req.params = params
        req.headers['Authorization'] = headers.authorization
        req.headers['Accept'] = '*/*'
      end
    end

    def perform_post
      Faraday.post(url) do |req|
        req.params = params
        req.headers['Authorization'] = headers.authorization
        req.headers['Accept'] = '*/*'
      end
    end
  end
end

# frozen_string_literal: true

require 'faraday'

module Parodikos
  # Client class for the Twitter API
  class Client
    attr_reader :method, :url, :params

    def initialize(method, url, params: {}, body: {})
      @method = method
      @url = url
      @params = params
      @body = body
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
      Headers.new(@method, @url, credentials: credentials, params: params)
    end

    def credentials
      @credentials ||= Credentials.from_file!(filename: 'credentials.yml')
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

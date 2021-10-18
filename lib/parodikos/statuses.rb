# frozen_string_literal: true

require 'json'

module Parodikos
  # Resposible for interacting with the GET statues endpoint
  class Statuses
    attr_reader :method, :url, :params

    def initialize(screen_name:, count:, since_id: nil, max_id: nil)
      @params = {
        'screen_name' => screen_name,
        'count' => count,
        'exclude_replies' => true,
        'trim_user' => true,
        'since_id' => since_id,
        'max_id' => max_id
      }.compact
      @method = 'get'
      @url = 'https://api.twitter.com/1.1/statuses/user_timeline.json'
    end

    def fetch
      data
    end

    def self.fetch(screen_name:, count:)
      new(screen_name: screen_name, count: count).fetch
    end

    private

    def response
      @response ||= Client.new(method, url, params: params).perform
    end

    def ok?
      response.status == 200
    end

    def data
      ok? ? JSON.parse(response.body) : ''
    end
  end
end

# frozen_string_literal: true

require 'json'

module Parodikos
  # Resposible for interacting with the GET statues endpoint
  class Statuses
    attr_reader :method, :url, :client, :screen_name, :count, :since_id, :max_id

    def initialize(screen_name:, count:, since_id: nil, max_id: nil, client: Client)
      @screen_name = screen_name
      @count = count
      @since_id = since_id
      @max_id = max_id
      @method = 'get'
      @url = 'https://api.twitter.com/1.1/statuses/user_timeline.json'
      @client = client
    end

    def fetch
      data
    end

    def self.fetch(screen_name:, count:, since_id: nil, max_id: nil)
      new(screen_name: screen_name,
          count: count,
          since_id: since_id,
          max_id: max_id).fetch
    end

    def data
      ok? ? JSON.parse(response.body) : ''
    end

    private

    def response
      @response ||= client.perform!(method, url, params: params)
    end

    def ok?
      response.status == 200
    end

    def params
      @params ||= {
        'screen_name' => screen_name,
        'count' => count,
        'exclude_replies' => true,
        'trim_user' => true,
        'since_id' => since_id,
        'max_id' => max_id,
        'include_rts' => true
      }.compact
    end
  end
end

# frozen_string_literal: true

require 'json'

module Parodikos
  # Responsible for utilizing the destroy status endpoint and deleting tweets
  class Destroyer
    attr_reader :method, :url, :tweet_id

    def initialize(tweet_id:)
      @tweet_id = tweet_id
      @method = 'post'
      @url = "https://api.twitter.com/1.1/statuses/destroy/#{tweet_id}.json"
    end

    def destroy!
      data || response.status
    end

    def self.destroy!(tweet_id:)
      new(tweet_id: tweet_id).destroy!
    end

    private

    def data
      JSON.parse(response.body) if ok?
    end

    def ok?
      response.status == 200
    end

    def response
      @response ||= Client.perform!(method, url)
    end
  end
end

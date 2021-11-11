# frozen_string_literal: true

module Parodikos
  # Responsible for traversing the timeline of a user.
  # Essentially implements #each and relies on the Enumberable mixin for
  # additional functionality.
  class Timeline
    include Enumerable

    MAX_COUNT = 200

    attr_reader :screen_name

    def initialize(screen_name:)
      @screen_name = screen_name
    end

    # Iterates over a timeline, yielding to a block tweets older by `date`.
    # @see https://developer.twitter.com/en/docs/twitter-api/v1/tweets/timelines/guides/working-with-timelines
    def each(&block)
      max_id = nil

      100.times do
        tweets = tweets_before(max_id)
        break if tweets.empty?

        tweets.each(&block) if block_given?

        max_id = tweets.map { |tweet| tweet['id'] }.min - 1 # Don't fetch the same tweet again
      end
    end

    def self.number_of_tweets_before(screen_name:, date:)
      new(screen_name: screen_name).number_of_tweets_before(date)
    end

    def self.each_tweet_before(screen_name:, date:, &block)
      new(screen_name: screen_name).each_tweet_before(date, &block)
    end

    def number_of_tweets_before(date)
      count { |tweet| DateTime.parse(tweet['created_at']) < date }
    end

    def each_tweet_before(date, &block)
      select { |tweet| DateTime.parse(tweet['created_at']) < date }.each(&block)
    end

    private

    def tweets_before(max_id, batch_size: MAX_COUNT)
      Statuses.fetch(screen_name: screen_name, count: batch_size, max_id: max_id)
    end
  end
end

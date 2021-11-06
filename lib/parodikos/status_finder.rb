# frozen_string_literal: true

module Parodikos
  # Responsible for finding status tweets based on various criteria
  class StatusFinder
    MAX_COUNT = 200

    attr_reader :statuses, :screen_name

    def initialize(screen_name:, statuses: Statuses)
      @screen_name = screen_name
      @statuses = statuses
    end

    def self.max_before(screen_name:, date:)
      new(screen_name: screen_name).max_before(date)
    end

    # Returns the number of tweets before a certain date
    def number_of_tweets_before(date)
      # Twitter API bases everything around ids, so we first need to find our
      # id and then travel backwards in time.
      max_id = max_before(date)

      # Let's not really do an infinite loop here, 20k tweets should cover it
      total = 1
      100.times do
        tweets = sorted_tweets_before(max_id)
        break if tweets.size == 1

        total += tweets.size - 1 # max id is overlapping
        max_id = tweets.first['id']
      end

      total
    end

    # Finds the maximum tweet id that should be deleted.
    # Three options:
    # - We have tweets both before and after the requested date, which means
    #   we can find the min_id to start deleting
    # - All tweets are newer so we have to look further back
    # - There aren't any tweets before the requested date
    def max_before(date)
      max_id = nil

      # Let's not really do an infinite loop here, 20k tweets should cover it
      100.times do
        tweets = sorted_tweets_before(max_id)
        return nil if tweets.empty?

        tweet = youngest_before(date, tweets)
        return tweet['id'] if tweet

        max_id = tweets.first['id']
      end

      nil
    end

    private

    def sorted_tweets_before(max_id)
      statuses.fetch(screen_name: screen_name, count: MAX_COUNT, max_id: max_id)
              .sort_by { |status| DateTime.parse(status['created_at']) }
    end

    def youngest_before(date, tweets)
      tweets
        .select { |tweet| date > DateTime.parse(tweet['created_at']) }
        .last
    end
  end
end
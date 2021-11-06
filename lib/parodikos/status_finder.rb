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

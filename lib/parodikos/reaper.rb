# frozen_string_literal: true

require 'pry'

module Parodikos
  class Reaper
    MAX_COUNT = 200

    attr_reader :screen_name, :before, :dry

    def initialize(screen_name:, before:, dry: true)
      @screen_name = screen_name
      @before = before
      @dry = dry
    end

    def reap!
      min_id
    end

    def self.reap!(screen_name:, before:, dry: true)
      new(screen_name: screen_name, before: before, dry: dry).reap!
    end

    private

    # Finds the minimum tweet id that should not be deleted.
    # Three options:
    # - We have tweets both before and after the requested date, which means
    #   we can find the min_id to start deleting
    # - All tweets are newer so we have to look further back
    # - There aren't any tweets before the requested date
    def min_id
      id = nil
      max_id = nil

      # Let's not really do an infinite loop here, 20k tweets should cover it
      100.times do
        tweets = tweets_before(max_id)
        return nil if tweets.empty?

        id = oldest_after(tweets)
        return id if id

        max_id = tweets.last['id']
      end
    end

    def tweets_before(max_id)
      Statuses.fetch(screen_name: screen_name, count: MAX_COUNT, max_id: max_id)
              .sort_by { |status| DateTime.parse(status['created_at']) }
              .reverse
    end

    def oldest_after(tweets)
      oldest = tweets.select do |tweet|
        before > DateTime.parse(tweet['created_at'])
      end.last

      oldest.nil? ? nil : oldest['id']
    end
  end
end

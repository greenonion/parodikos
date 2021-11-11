# frozen_string_literal: true

module Parodikos
  # Deletes all tweets before a certain date for a certain user.
  # Allows for dry runs.
  class Reaper
    attr_reader :screen_name, :before

    def initialize(screen_name:, before:)
      @screen_name = screen_name
      @before = before
    end

    def dry!
      Timeline.number_of_tweets_before(screen_name: screen_name, date: before)
    end

    def reap!(dry: true)
      return dry! if dry

      total = 0

      Timeline.each_tweet_before(screen_name: screen_name, date: before) do |tweet|
        destroy!(tweet['id'])
        total += 1
      end
      total
    end

    def self.reap!(screen_name:, before:, dry: true)
      new(screen_name: screen_name, before: before).reap!(dry: dry)
    end

    private

    def destroy!(tweet_id)
      Destroyer.destroy!(tweet_id: tweet_id)
    end
  end
end

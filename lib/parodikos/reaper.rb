# frozen_string_literal: true

module Parodikos
  # Deletes all tweets before a certain date for a certain user.
  # Allows for dry runs.
  class Reaper
    attr_reader :screen_name, :before, :status_finder

    def initialize(screen_name:, before:, status_finder: StatusFinder)
      @screen_name = screen_name
      @before = before
      @status_finder = status_finder
    end

    def dry!
      StatusFinder.number_of_tweets_before(screen_name: screen_name, date: before)
    end

    def self.dry_run(screen_name:, before:)
      new(screen_name: screen_name, before: before).dry!
    end

    def self.reap!(screen_name:, before:, dry: true)
      if dry
        dry_run(screen_name: screen_name, before: before)
      else
        false
      end
    end

    private

    # The maximum id that should be deleted
    def max_id
      @max_id ||= StatusFinder.max_before(screen_name: screen_name, date: before)
    end
  end
end

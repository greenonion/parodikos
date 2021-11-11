# frozen_string_literal: true

require_relative 'parodikos/version'
require_relative 'parodikos/headers'
require_relative 'parodikos/signer'
require_relative 'parodikos/client'
require_relative 'parodikos/destroyer'
require_relative 'parodikos/statuses'
require_relative 'parodikos/timeline'
require_relative 'parodikos/reaper'

module Parodikos
  class Error < StandardError; end
  # Your code goes here...
end

# frozen_string_literal: true

module Parodikos
  class Client
    attr_reader :name

    # TODO We need to collect the following parameters
    # - oauth_consumer_key (copy paste from web) TODO
    # - oauth_nonce (generate randomly) TODO
    # - oauth_signature (generate) TODO
    # - oauth_signature_method HMAC-SHA1 TODO
    # - oauth_timestamp (generate) TODO
    # - token (copy paste from web) TODO
    # - oauth_version 1.0 TODO
    def initialize(name)
      @name = name
    end
  end
end

require 'logger'

module PDC
  class << self
    attr_writer :logger

    def logger
      @logger ||= ::Logger.new($stdout).tap do |log|
        log.progname = name
      end
    end
  end

  module Logging
    def logger
      PDC.logger
    end
  end
end

module PDC
  # Base for all PDC generated errors
  # Wrap other Errors like Curl's and Faraday's
  class Error < StandardError
    attr_reader :wrapped_exception

    def initialize(ex)
      @wrapped_exception = nil

      if ex.respond_to?(:backtrace)
        super(ex.message)
        @wrapped_exception = ex
      else
        super(ex.to_s)
      end
    end

    def backtrace
      if @wrapped_exception
        @wrapped_exception.backtrace
      else
        super
      end
    end
  end

  class ConfigError < Error; end

  class InvalidPathError < Error; end

  class HostResolutionError < Error; end

  class ConnectionFailed < Error; end
end

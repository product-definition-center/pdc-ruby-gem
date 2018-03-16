module PDC::Resource
  module Finder
    extend ActiveSupport::Concern

    # returns the contents for the current scope without any pagination as
    # an +Array+ of +Resources+
    def contents!
      return @contents if @contents
      @contents = result.data.map { |result| new(result) }
    end

    def find_one!
      raise(PDC::ResourceNotFound, params) if result.data.empty?
      raise(PDC::MultipleResultsError, params) if result.data.length > 1
      @find_one ||= new(result.data.first)
    end

    private

    def result
      @result ||= fetch(clone)
    rescue Faraday::ConnectionFailed => e
      raise PDC::ConnectionFailed, e
    rescue Curl::Err::HostResolutionError => e
      raise PDC::HostResolutionError, e
    rescue StandardError => e
      raise e unless e.class.parent != PDC
      raise PDC::Error, e
    end
  end
end

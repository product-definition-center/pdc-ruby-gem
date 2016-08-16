require 'forwardable'

module PDC
  class JsonParseError < Error; end

  class ResponseError < Error
    extend Forwardable

    def_instance_delegators :response, :status, :body
    attr_reader :response

    def initialize(args = {})
      @response = args[:response]
      @args = args
    end
  end

  class JsonError < ResponseError
    def message
      summary = detail || response.body
      "Error: #{status} - #{summary}"
    end

    private

    # returns details in json response if any, else nil
    def detail
      @detail ||= json[:detail]
    end

    # tries to parse response body as a json
    def json
      @json ||= begin
                  MultiJson.load(response.body, symbolize_keys: true)
                rescue MultiJson::ParseError
                  {}
                end
    end
  end

  class ResourceNotFound < JsonError; end
  class TokenFetchFailed < JsonError; end
end

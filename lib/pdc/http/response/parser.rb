require 'multi_json'

module PDC::Response
  # Converts body into JSON data, metadata and errors
  class Parser < Faraday::Response::Middleware
    include PDC::Logging

    Faraday::Response.register_middleware pdc_json_parser: self

    def parse(body)
      logger.debug "\n.....parse to json ....................................."
      logger.debug self.class

      logger.debug '... parsing' + body.to_s.truncate(55)
      begin
        json = MultiJson.load(body, symbolize_keys: true)
      rescue MultiJson::ParseError => e
        raise PDC::JsonParseError, e
      end

      {
        data:     extract_data(json),     # Always an Array
        errors:   extract_errors(json),   #
        metadata: extract_metadata(json)  # a hash
      }
    end

    private

    def extract_data(json)
      return [] if error?(json)
      return json[:results] if metadata_present?(json)
      Array.wrap(json)
    end

    def extract_errors(json)
      error?(json) ? json[:details] : []
    end

    def extract_metadata(json)
      return json.except(:details, :results) if metadata_present?(json)
      data_only?(json) ? { count: json.length, next: nil, previous: nil } : {}
    end

    def metadata_present?(json)
      return false if data_only?(json) || error?(json)

      json[:results].is_a?(Array) &&
        json[:count].is_a?(Numeric) &&
        json.key?(:next) &&
        json.key?(:previous)
    end

    def error?(json)
      json.is_a?(Hash) && json.keys == [:detail]
    end

    def data_only?(json)
      json.is_a? Array
    end
  end
end

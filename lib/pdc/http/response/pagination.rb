module PDC::Response
  class Paginator < Faraday::Response::Middleware
    include PDC::Logging

    Faraday::Response.register_middleware pdc_paginator: self

    def parse(json)
      logger.debug "\n.....paginate json ....................................."

      metadata = json[:metadata]
      logger.debug metadata
      return json unless paginated?(metadata)

      metadata[PDC::Resource::PAGINATION] = {
        resource_count:   metadata.delete(:count),
        # TODO: decide if this is okay to discard the
        # schema://host:port/ of the next and previous
        next_page:        request_uri(metadata.delete(:next)),
        previous_page:    request_uri(metadata.delete(:previous))
      }

      logger.debug '... after parsing pagination data:'
      logger.debug metadata
      json
    end

    private

    def request_uri(uri)
      return unless uri
      URI(uri).request_uri
    end

    def paginated?(metadata)
      metadata[:count].is_a?(Numeric) &&
        metadata.key?(:next) &&
        metadata.key?(:previous)
    end
  end
end

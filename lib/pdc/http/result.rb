module PDC::Http
  # encapsulates +http+ response
  class Result
    attr_reader :url, :body, :status

    def initialize(response)
      @body = HashWithIndifferentAccess.new(response.body)
      @status = response.status
      @url = response.env.url
    end

    def data
      body[:data]
    end

    def metadata
      body[:metadata] || {}
    end

    def pagination
      metadata[PDC::Resource::PAGINATION] || {}
    end

    def errors
      body[:errors] || []
    end
  end
end

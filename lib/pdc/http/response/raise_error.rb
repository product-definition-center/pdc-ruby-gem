module PDC
  class Response::RaiseError < Faraday::Response::Middleware
    Faraday::Response.register_middleware pdc_raise_error: self

    def on_complete(env)
      raise PDC::ResourceNotFound, response_values(env) if env[:status] == 404
    end

    def response_values(env)
      { response: env.response, request: env.request }
    end
  end
end

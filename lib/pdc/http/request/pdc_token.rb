module PDC
  class Request::PDCToken < Faraday::Middleware
    include PDC::Logging
    include PDC::TokenFetcher

    Faraday::Request.register_middleware :pdc_token => self

    def call(env)
      logger.debug "\n..... put token to header .........................................."
      logger.debug self.class
      logger.debug env.request_headers

      env.request_headers['Token'] = fetch_token
      @app.call(env)
    end
  end
end

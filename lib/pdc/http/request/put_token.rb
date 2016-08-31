module PDC
  class Request::PutTokenToHeader < Faraday::Middleware
    include PDC::Logging

    Faraday::Request.register_middleware :put_token_to_header => self

    def call(env)
      logger.debug "\n..... put token to header ..........................................".green
      logger.debug self.class
      logger.debug env.request_headers

      env.request_headers['Token'] = PDC.token
      @app.call(env)
    end
  end
end

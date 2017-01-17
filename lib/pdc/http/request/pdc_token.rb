module PDC::Request
  # Adds TokenAuthentication to request header. Uses the token if passed
  # else fetches token using the TokenFetcher to get the token once
  class Token < Faraday::Middleware
    include PDC::Logging

    Faraday::Request.register_middleware pdc_token: self

    def initialize(app, options = {})
      @options = options
      super(app)
    end

    def call(env)
      env.request_headers['Token'] = token
      logger.debug "Token set, headers: #{env.request_headers}"
      @app.call(env)
    end

    private

    attr_reader :options

    # uses the token passed or fetches one only once
    def token
      @token ||= options[:token] || TokenFetcher.fetch
    end
  end
end

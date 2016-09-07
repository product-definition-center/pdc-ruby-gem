module PDC
  class Request::AppendSlashToPath < Faraday::Middleware
    include PDC::Logging

    Faraday::Request.register_middleware :append_slash_to_path => self

    def call(env)
      logger.debug "\n..... append slash .........................................."
      logger.debug self.class
      logger.debug env.url

      path = env.url.path
      env.url.path = path + '/' unless path.ends_with?('/')

      logger.debug "...  after adding / #{env.url.path}: #{env.url}"
      @app.call(env)
    end
  end
end

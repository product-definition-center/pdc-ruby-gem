require 'faraday-http-cache'

module PDC
  # This class is the main access point for all PDC::Resource instances.
  #
  # The client must be initialized with an options hash containing
  # configuration options.  The available options are:
  #
  #   :site               => 'http://localhost:2990',
  #   :ssl_verify_mode    => OpenSSL::SSL::VERIFY_PEER,
  #   :use_ssl            => true,
  #   :username           => nil,
  #   :password           => nil,
  #   :auth_type          => :oauth
  #   :proxy_address      => nil
  #   :proxy_port         => nil
  #
  # See the PDC::Base class methods for all of the available methods on these accessor
  # objects.

  class << self
    include PDC::TokenFetcher
    Config = Struct.new(
      :site,
      :api_root,

      :use_ssl,
      :ssl_verify_mode,

      :requires_token,
      :token_obtain_path,
      :token,

      :log_level,
      :enable_logging,
      :logger,

      :cache_store,
      :disable_caching,
    ) do
      def initialize
        # site config
        self.site                = 'http://localhost:8000'
        self.api_root            = 'rest_api/'
        self.use_ssl             = true
        self.ssl_verify_mode     = OpenSSL::SSL::VERIFY_PEER

        # token and authentication
        self.requires_token      = true
        self.token_obtain_path   = 'v1/auth/token/obtain/'
        self.token               = nil

        # logger config
        self.log_level           = :warn
        self.enable_logging      = true
        self.logger              = PDC.logger

        self.cache_store         = nil
        self.disable_caching     = false
      end
    end

    def configure
      @config = Config.new
      begin
        yield(@config) if block_given?
      rescue NoMethodError => e
        raise ConfigError, e
      end

      apply_config
    end

    def config
      @config ||= Config.new
    end

    def config=(new_config)
      @config = new_config
      apply_config
      @config
    end

    def token_url
      URI.join(api_url, config.token_obtain_path)
    end

    def api_url
      URI.join(config.site, config.api_root)
    end

    def token
      set_token(config.token)
      fetch_token
    end

    private

      def apply_config
        reset_logger
        reset_base_connection
      end

      def reset_logger
        PDC.logger = Logger.new(nil) unless config.enable_logging
        logger.level = Logger.const_get(config.log_level.upcase)
      end

      # resets and returns the +Faraday+ +connection+ object
      def reset_base_connection
        headers = PDC::Request.default_headers
        PDC::Base.connection = Faraday.new(url: api_url, headers: headers) do |c|
          c.request   :append_slash_to_path
          if config.requires_token
            set_token(config.token)
            set_token_url(token_url)
            c.request   :pdc_token
          end

          c.response  :logger, config.logger
          c.response  :pdc_paginator
          c.response  :pdc_json_parser
          c.response  :raise_error
          c.response  :pdc_raise_error

          c.use       FaradayMiddleware::FollowRedirects

          unless config.disable_caching
            c.use       Faraday::HttpCache, store: cache_store,
                          logger: PDC.logger,
                          instrumenter: ActiveSupport::Notifications
          end
          c.adapter   Faraday.default_adapter
        end
      end

      def cache_store
        config.cache_store || ActiveSupport::Cache.lookup_store(:memory_store)
      end

  end
end

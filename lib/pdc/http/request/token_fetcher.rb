require 'curb'
require 'json'

module PDC::Request
  module TokenFetcher
    module Configuration
      VALID_KEYS = [:ssl_verify_mode, :url].freeze

      attr_accessor(*VALID_KEYS)

      def options
        Hash[*VALID_KEYS.map { |k| [k, send(k)] }.flatten]
      end

      def configure
        yield self
      end
    end
    extend Configuration

    # uses kerberos token to obtain token from pdc
    def self.fetch
      PDC.logger.debug "Fetch token from: #{url}"

      curl = curl_easy
      curl.perform
      if curl.response_code != 200
        PDC.logger.info "Obtain token from #{url} failed: #{curl.body_str}"
        error = { url: url, body: curl.body, code: curl.response_code }
        raise PDC::TokenFetchFailed, error
      end
      result = JSON.parse(curl.body_str)
      curl.close
      result['token']
    end

    def self.curl_easy
      Curl::Easy.new(url.to_s) do |request|
        request.ssl_verify_peer    = ssl_verify_mode != OpenSSL::SSL::VERIFY_NONE
        request.headers['Accept']  = 'application/json'
        request.http_auth_types    = :gssnegotiate

        # The curl man page (http://curl.haxx.se/docs/manpage.html)
        # specifes setting a fake username when using Negotiate auth,
        # and use ':' in their example.
        request.username = ':'
      end
    end
  end
end

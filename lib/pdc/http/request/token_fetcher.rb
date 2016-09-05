require 'curb'
require 'json'

module PDC::Request
  module TokenFetcher

    # uses kerberos token to obtain token from pdc
    def self.fetch(token_url)
      PDC.logger.debug  "Fetch token from: #{token_url}"
      curl = Curl::Easy.new(token_url.to_s) do |request|
        request.headers['Accept'] = 'application/json'
        request.http_auth_types = :gssnegotiate

        # The curl man page (http://curl.haxx.se/docs/manpage.html)
        # specifes setting a fake username when using Negotiate auth,
        # and use ':' in their example.
        request.username = ':'
      end

      curl.perform
      if curl.response_code != 200
        PDC.logger.info "Obtain token from #{token_url} failed: #{curl.body_str}"
        error = { token_url: token_url, body: curl.body, code: curl.response_code }
        raise PDC::TokenFetchFailed, error
      end
      result = JSON.parse(curl.body_str)
      curl.close
      result['token']
    end

  end
end

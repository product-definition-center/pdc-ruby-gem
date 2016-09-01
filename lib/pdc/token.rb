require 'curb'

module PDC
  module TokenFetcher

    @@token = nil
    @@token_url = nil

    def fetch_token
      unless @@token
        curl = Curl::Easy.new(@@token_url.to_s) do |request|
          request.headers['Accept'] = 'application/json'
          request.http_auth_types = :gssnegotiate

          # The curl man page (http://curl.haxx.se/docs/manpage.html)
          # specifes setting a fake username when using Negotiate auth,
          # and use ':' in their example.
          request.username = ':'
        end
        curl.perform
        if curl.response_code != 200
          logger.info "Obtain token from #{@@token_url} failed: #{curl.body_str}"
          error = { token_url: @@token_url, body: curl.body, code: curl.response_code }
          raise PDC::TokenFetchFailed, error
        end
        result = JSON.parse(curl.body_str)
        curl.close
        @@token = result['token']
      end
      @@token
    end

    def set_token(in_token)
      @@token = in_token
    end

    def set_token_url(in_url)
      @@token_url = in_url
    end
  end
end

require 'pdc/http/request/append_slash'
require 'pdc/http/request/pdc_token'

module PDC
  module Request
    def self.default_headers
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    end
  end
end

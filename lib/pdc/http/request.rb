require 'pdc/http/request/append_slash'

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

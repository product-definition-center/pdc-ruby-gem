require 'webmock/minitest'

class WebMock::RequestStub
  def to_return_json(hash, options = {})
    options[:body] = MultiJson.dump(hash)
    to_return(options)
  end

end


# Don't raise but report uncaught net connections
WebMock.allow_net_connect!

WebMock.stub_request(:any, /.*/).to_return do |request|
  puts "UNSTUBBED REQUEST:" + " #{request.method.upcase} #{request.uri}"
  { body: nil }
end

module PDC
  module Minitest
    module WebMockExtentions
      def stub_get(path)
        uri = URI.join(Fixtures::Base::SITE, 'fixtures/', path).to_s
        puts "    stubbing: #{uri}"
        stub_request(:get, uri)
      end
    end
  end
end

class Minitest::Spec
  include PDC::Minitest::WebMockExtentions
end

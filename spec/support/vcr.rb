require 'vcr'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = File.dirname(__FILE__) + "/../fixtures/vcr"
  c.hook_into :faraday, :webmock

  # To enable debug logs
  # c.debug_logger = File.open('tmp/vcr.log', 'w')
end

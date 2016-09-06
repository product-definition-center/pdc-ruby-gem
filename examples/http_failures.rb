require 'ap'
require './lib/pdc'

PDC.configure do |config|
  # invalid
  config.site = 'http://localhost:8000/foo/bar/baz'
  config.enable_logging = true
  config.auth_type = :basic
  config.use_ssl = false
end

begin
  release = PDC::V1::Release.all
  release.to_a
rescue PDC::Error::ResourceNotFound => e
  ap e
  puts "Got resource not found as expected: #{e.response[:status]}"
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
SimpleCov.start { add_filter 'test' }

require 'ap'
require 'pry'

require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/focus'
require 'webmock/minitest'

require 'pdc'

reporter_options = {
  :color => true,
  :slow_count => 3
}

Minitest::Reporters.use! [
  # Minitest::Reporters::DefaultReporter.new(reporter_options),
  Minitest::Reporters::SpecReporter.new(reporter_options)
]

# require all support files
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

PDC.configure do |config|
  config.site = 'https://pdc.host.dev.eng.pek2.redhat.com/'
  config.requires_token = false
  config.disable_caching = true
###  config.log_level = :debug   # enable to see details log
end

# TODO: decide if this is okay to do
include Fixtures

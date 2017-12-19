$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start { add_filter 'test' }

require 'ap'
require 'pry'

require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/focus'
require 'webmock/minitest'

require 'pdc'

reporter_options = {
  color: true,
  slow_count: 3
}

Minitest::Reporters.use! [
  # Minitest::Reporters::DefaultReporter.new(reporter_options),
  Minitest::Reporters::SpecReporter.new(reporter_options)
]

# require all support files
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

PDC_SITE = 'https://example.com/'.freeze

PDC.configure do |config|
  config.site = PDC_SITE
  config.requires_token = false
  config.disable_caching = true
  ###  config.log_level = :debug   # enable to see details log
end

# TODO: decide if this is okay to do
include Fixtures

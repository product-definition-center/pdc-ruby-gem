$LOAD_PATH << File.expand_path(__dir__)

module PDC
  require 'pdc/version'
  require 'active_support'
  require 'active_model'
  require 'active_support/core_ext' # delegate

  require 'faraday'
  require 'faraday_middleware'

  require 'pdc/errors'
  require 'pdc/logger'
  require 'pdc/http'
  require 'pdc/resource'

  require 'pdc/associations'
  require 'pdc/config'
  require 'pdc/base'
  require 'pdc/v1'
end

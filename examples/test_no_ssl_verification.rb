$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'ap'
require 'pdc'

def main
  PDC.configure do |config|
    config.site = 'https://pdc.engineering.redhat.com/'
    config.log_level = :debug
    config.ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  puts "Release count: #{PDC::V1::Release.count}"
end

main if $PROGRAM_NAME == __FILE__

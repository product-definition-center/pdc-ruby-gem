require 'ap'
require_relative '../lib/pdc'

def main
  PDC.configure do |config|
    config.site = 'http://localhost:8000'
    config.requires_token = false
    config.log_level = :debug
  end

  releases = PDC::V1::Release.all!.to_a
  ap releases
end

main if __FILE__ == $PROGRAM_NAME

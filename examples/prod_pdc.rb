require './lib/pdc'
require 'ap'

def main
  PDC.configure do |config|
    config.site = 'https://pdc.engineering.redhat.com'
    config.log_level = :debug
  end

  releases = PDC::V1::Release.all!.to_a
  ap releases
end

main if $PROGRAM_NAME == __FILE__

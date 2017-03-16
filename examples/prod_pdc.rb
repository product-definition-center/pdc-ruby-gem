require './lib/pdc'
require 'ap'

def main
  PDC.configure do |config|
    config.site = 'https://pdc.engineering.redhat.com'
    config.log_level = :debug
  end

  #releases = PDC::V1::Release.all!.to_a
  #ap releases

  ap PDC::V1::ReleaseVariant.where(:release => 'ceph-1.3@rhel-7', :uid => 'Calamari').first
end

main if __FILE__ == $PROGRAM_NAME
a = 'dfdfdfdf'
'dfdfdf'
'dfdfdf'

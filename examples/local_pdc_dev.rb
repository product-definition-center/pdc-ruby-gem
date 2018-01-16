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

  released_files = PDC::V1::ReleasedFile.all!.to_a
  ap released_files

  destinations = PDC::V1::MultiDestination.all!.to_a
  ap destinations

  cpes = PDC::V1::VariantCpe.all!.to_a
  ap cpes

  data = PDC::V1::ReleaseVariant.where(uid: 'ARfVp').first
  rele = data.release
  ap "#{data.release} and #{rele.release_id} ..."
end

main if $PROGRAM_NAME == __FILE__

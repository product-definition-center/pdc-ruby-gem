require_relative '../lib/pdc'
require 'ap'

class PDC::V1::NonExistingResource < PDC::Base
end

def main
  PDC.configure do |config|
    config.site = 'https://pdc.engineering.redhat.com/'
    # don't even bother fetching the token, this has to
    # fail anyway
    config.requires_token = false
    config.log_level = :debug
  end

  begin
    resources = PDC::V1::NonExistingResource.all.to_a
    ap resources
  rescue PDC::ResourceNotFound => e
    ap e
    puts "Got resource not found as expected: #{e.response.status}"
    ap e.message
  end
end

main if $PROGRAM_NAME == __FILE__

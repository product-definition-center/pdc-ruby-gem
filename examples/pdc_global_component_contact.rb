#!/usr/bin/env ruby

require './lib/pdc'

def main
  PDC.configure do |config|
    config.site = 'https://pdc.engineering.redhat.com'
    config.log_level = :debug
    config.disable_caching = true
  end

  comp_contact = PDC::V1::GlobalComponentContact.where(
    component: 'vlgothic-fonts'
  ).find_one!
  puts comp_contact.contact
end

main if $PROGRAM_NAME == __FILE__

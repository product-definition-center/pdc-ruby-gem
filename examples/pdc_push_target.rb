#!/usr/bin/env ruby

require './lib/pdc'

def main
  PDC.configure do |config|
    config.site = 'https://example.com/'
    config.log_level = :debug
    config.disable_caching = true
    config.requires_token = false
  end

  push_target = PDC::V1::PushTarget.where(
    name: 'cdn-qa'
  ).find_one!
  puts push_target.description
end

main if $PROGRAM_NAME == __FILE__

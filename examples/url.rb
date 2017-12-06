require_relative '../lib/pdc'

PDC.configure do |config|
  # dev server
  config.site = 'https://pdc.engineering.redhat.com/'
  config.log_level = :info
end

def main
  rhel71 = PDC::V1::Release.find('rhel-7.1')
  puts "release url : #{rhel71.url}"
  rhel71.variants.all.each do |v|
    puts "release variant url : #{v.url}"
  end
end

main if $PROGRAM_NAME == __FILE__

require 'benchmark'
require_relative '../lib/pdc'
require_relative '../spec/spec_helper'

WebMock.disable!
PDC.configure do |config|
  # dev server
  config.site = 'https://pdc.host.dev.eng.pek2.redhat.com/'
  config.cache_store = ActiveSupport::Cache.lookup_store(
    :file_store, [File.join(ENV['TMPDIR'] || '/tmp', 'cache')])
  config.log_level = :info
end

ActiveSupport::Notifications.subscribe "http_cache.faraday" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  puts " >>> " + "cache: #{event.payload[:cache_status]}"
  ap event.payload
end

def benchmark(description, opts = {}, &block)
  puts "Running: #{description}"

  initial = Benchmark.measure(&block)
  repeat = Benchmark.measure(&block)

  puts "Initial :  #{initial.to_s.chomp} >> #{initial.real.round(2)}"
  puts "Repeat  :  #{repeat.to_s.chomp} >> #{repeat.real.round(2)} \n"
end

def main
  benchmark "fetch all" do
    PDC::V1::Release.all
  end

  benchmark "fetch with page number" do
    PDC::V1::Release.page(2).contents!
  end

  benchmark "fetch with page number and size" do
    PDC::V1::Release.page(2).page_size(30).contents!
  end

  benchmark "fetch with page number and size and query condition" do
    PDC::V1::Release.page(2).page_size(30).where(active: true).contents!
  end
end

main if __FILE__ == $PROGRAM_NAME

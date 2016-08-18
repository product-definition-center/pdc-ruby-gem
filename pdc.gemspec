# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdc/version'

Gem::Specification.new do |s|
  s.name          = 'pdc'
  s.version       = PDC::VERSION
  s.authors       = ['Sunil Thaha']
  s.email         = ['sthaha@redhat.com']

  s.summary       = 'Ruby gem for use with Product-Definition-Center'
  s.description   = 'API for PDC'
  s.homepage      = 'https://github.com/product-definition-center/pdc-ruby-gem'
  s.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', '~> 3.2.22.2'
  s.add_dependency 'activemodel', '~> 3.2.22.2'
  s.add_dependency 'uri_template', '~> 0.7.0'
  s.add_dependency 'multi_json', '~> 1.12.1'
  s.add_dependency 'faraday', '~> 0.9.2'
  s.add_dependency 'faraday_middleware', '~> 0.10.0'
  s.add_dependency 'faraday-http-cache', '~> 1.3.0'
  s.add_dependency 'curb', '~> 0.9.3'
end

source 'https://rubygems.org'

group :tools do
  gem 'guard', '<= 2.12.0'
  gem 'guard-minitest', '~> 2.4.4'
  gem 'guard-shell'
end

group :development do
  gem 'awesome_print'
  gem 'colorize'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rake', '~> 10.0'
  gem 'rake-notes'
end

group :test do
  gem 'coveralls'
  gem 'minitest-focus'
  gem 'minitest-reporters', '~> 1.1.9'
  gem 'mocha'
  gem 'simplecov'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock', '~> 1.18.0'
end

group :development, :test do
  # Pronto
  gem 'pronto'
  gem 'pronto-flay', require: false
  gem 'pronto-rubocop', require: false
end

# Specify your gem's dependencies in pdc-ruby.gemspec
gemspec

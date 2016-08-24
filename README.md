# PDC

Ruby `PDC` library that maps `PDC` json api to ActiveRecord like objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdc

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake test` to run the tests. You can also run `bin/console` for
an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and
then run `bundle exec rake release`, which will create a git tag for the
version, push git commits and tags, and push the `.gem` file to [rubygems][]

## Contributing

Bug reports and pull requests are welcome on GitHub at
[product-definition-center/pdc-ruby-gem][pdc-github] . This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant][coc] code of conduct.


## License

The gem is available as open source under the terms of the [MIT License][mit-license]

## Credits

This gem is heavily influenced by the [spyke][] gem which requires
`activesupport 4.0` or above where as the `pdc` gem needs to run against
`activesupport 3.2.22`. If you are using `activesupport 4` (rails 4) or above
and is looking for json api to ORM framework please consider using [spyke][] instead.


[rubygems]: https://rubygems.org
[mit-license]: http://opensource.org/licenses/MIT
[coc]: http://contributor-covenant.org
[pdc-github]: https://github.com/product-definition-center/pdc-ruby-gem
[spyke]: https://github.com/balvig/spyke

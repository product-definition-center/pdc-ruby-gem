require 'spec_helper'

describe PDC do
  before do
    @old_config = PDC.config
  end
  after do
    PDC.config = @old_config
  end

  describe '##configure' do
    let(:site) { 'https://pdc.production.site.org' }

    let(:token_url) do
      pdc = PDC.config
      URI.join(site, pdc.api_root, pdc.token_obtain_path)
    end

    let(:releases_url) do
      URI.join(site, PDC.config.api_root, 'v1/releases/')
    end

    it 'wont accept invalid config' do
      assert_raises PDC::ConfigError do
        PDC.configure do |config|
          config.invalid_option = 'foobar'
        end
      end
    end

    it 'returns Faraday' do
      ret = PDC.configure do |config|
        config.site = 'http://foobar'
        config.token = 'foo'
      end
      ret.must_be_instance_of Faraday::Connection
    end

    it 'must not fetch token during configure step' do
      token = stub_request(:get, token_url).to_return_json(token: 'foobar')
      PDC.configure { |pdc| pdc.site = site }

      assert_not_requested token
    end

    it 'fetches token on first request' do
      token = stub_request(:get, token_url).to_return_json(token: 'foobar')

      PDC.configure { |pdc| pdc.site = site }
      assert_not_requested token

      releases = stub_request(:get, releases_url).to_return_json(count: 0)
      3.times { PDC::V1::Release.count }

      # the releases will be requested n times but the token will be reused
      assert_requested token, times: 1
      assert_requested releases, times: 3
    end

    it 'will not cache PDC.token call' do
      token = stub_request(:get, token_url).to_return_json(token: 'foobar')

      PDC.configure { |pdc| pdc.site = site }
      assert_not_requested token

      PDC.token.must_equal 'foobar'
      PDC.token.must_equal 'foobar'

      assert_requested token, times: 2
    end

    it 'will not fetch token if already set' do
      token = stub_request(:get, token_url).to_return_json(token: 'foobar')

      PDC.configure do |pdc|
        pdc.site = site
        pdc.token = :a_known_token
      end

      PDC.token.must_equal :a_known_token
      assert_not_requested token
    end

    it 'raises TokenFetchFailed when fails' do
      token = stub_request(:get, token_url).to_return_json(
        { detail: 'Not found' },
        status: [404, 'NOT FOUND']
      )

      PDC.configure { |pdc| pdc.site = site }
      assert_raises PDC::TokenFetchFailed do
        PDC.token
      end
      assert_requested token
    end
  end

  describe '#config' do
    before do
      @config = PDC.config
      @config.requires_token = false
    end

    after do
      PDC.config = @config
    end

    it 'allows default site to be overridden ' do
      PDC.configure do |config|
        config.site = 'http://localhost:8888'
      end
      PDC.config.site.must_equal 'http://localhost:8888'
    end

    it 'preserves default values of items not overridden ' do
      default_api_root = PDC.config.api_root
      site = PDC.config.site
      token = PDC.config.token

      new_site = 'http://localhost:8888'
      new_token = :foobar
      PDC.configure do |config|
        config.site = new_site
        config.token = new_token
      end
      PDC.config.site.must_equal  new_site
      PDC.config.token.must_equal new_token

      PDC.config.api_root.must_equal default_api_root
      PDC.config.site.wont_equal site
      PDC.config.token.wont_equal token
    end

    it 'creates a new Config' do
      old_config = PDC.config
      PDC.configure do |config|
        config.site = 'https://foobar'
        config.token = :foobar
      end
      PDC.config.wont_equal old_config
      PDC.config.must_equal PDC.config
    end

    it 'resets connection when changed' do
      old_connection = PDC::Base.connection
      # assert that calling it again returns the same
      PDC::Base.connection.must_equal old_connection

      new_connection = PDC.configure do |config|
       config.site = 'http://localhost:8888'
       config.token = :foobar
      end
      PDC::Base.connection.must_equal new_connection
      new_connection.wont_equal old_connection
    end
  end
end

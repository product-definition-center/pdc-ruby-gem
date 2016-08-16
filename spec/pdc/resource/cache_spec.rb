require 'spec_helper'
require 'timecop' # for  Timecop.freeze

# How it works
#
# The test records http response using +vcr+ as fixtures which are
# stored under spec/fixtures/vcr directory. After the response is
# stored as fixtures, vcr will start replaying those requests when
# same url is accessed by faraday.
#
# To deal with the cache expiry, the cache_store is set to in-memory so
# that the first fetch will be missed and handled by vcr. Time is
# frozen to 2016 which makes the cache valid/fresh after it is
# fetched/played once by vcr.

# NOTE: disable webmock to record a new test
# WebMock.disable!

# returns http cache status for all http calls made
# using faraday in the +&block+ passed
def record_cache_access(&block)
  cache_access = []
  record_status = lambda do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    cache_access << event.payload[:cache_status]
  end
  ActiveSupport::Notifications.subscribed(record_status, 'http_cache.faraday', &block)
  cache_access
end


describe 'Caching' do
  before do
    @old_config = PDC.config
    config = @old_config.clone
    config.disable_caching = false
    config.cache_store = ActiveSupport::Cache.lookup_store(:memory_store)

    PDC.config = config

    VCR.insert_cassette fixture_name
    Timecop.travel(Time.local(2016)) #   based on fixtures
  end

  after do
    Timecop.return
    VCR.eject_cassette
    PDC.config = @old_config
  end

  it 'caches response without query' do
    cache = record_cache_access { PDC::V1::Release.scoped.contents! }
    cache.must_equal [:miss]

    cache = record_cache_access { PDC::V1::Release.scoped.contents! }
    cache.must_equal [:fresh]

    cache = record_cache_access { PDC::V1::Release.scoped.contents! }
    cache.must_equal [:fresh]
  end

  it 'caches response with a query' do
    cache = record_cache_access { PDC::V1::Release.page(2).contents! }
    cache.must_equal [:miss]

    cache = record_cache_access { PDC::V1::Release.page(2).contents! }
    cache.must_equal [:fresh]
  end

  it 'caches response with multiple query' do
    cache = record_cache_access do
      PDC::V1::Release.page(2).page_size(30).contents!
      PDC::V1::Release.page(2).page_size(30).contents!
    end
    cache.must_equal [:miss, :fresh]
  end

  it 'caches multiple response' do
    cache = record_cache_access { PDC::V1::Release.where(active: true).all }

    # must paginate so at least 2 pages
    cache.length.must_be :>=, 2
    cache.must_equal [:miss] * cache.length

    second_time = record_cache_access { PDC::V1::Release.where(active: true).all }
    second_time.must_equal [:fresh] * cache.length
  end
end

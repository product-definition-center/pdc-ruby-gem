require 'spec_helper'

# WebMock.disable!  # enable to re-record

describe PDC::V1::MultiDestination do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:multi_destinations) { PDC::V1::MultiDestination }

  describe 'simple test case' do
    it 'destination returns count' do
      count = multi_destinations.count
      count.must_equal 1
    end

    it 'destination works with where' do
      count = multi_destinations.where(active: false).count
      count.must_equal 0
    end

    it 'return empty data for specific global component and origin repo release' do
      multi_destinations.where(active: true, global_component: 'ceph', origin_repo_release_id: 'ceph-1.3').all!.must_equal []
    end

    it 'return real data with query params' do
      mappings = multi_destinations.where(active: true, global_component: 'ceph', origin_repo_release_id: 'rhceph-2.1@rhel-7').all!
      mappings.map(&:destination_repo).map(&:release_id).uniq.sort.must_equal ['ceph-2.0@rhel-7', 'rhceph-2.1-updates@rhel-7']
    end
  end
end

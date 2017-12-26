require 'spec_helper'

# WebMock.disable!  # enable to re-record

describe PDC::V1::MultiDestination do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:multi_destonations) { PDC::V1::MultiDestination }

  describe 'count' do
    it 'destination returns count' do
      count = multi_destonations.count
      count.must_equal 1
    end

    it 'destination works with where' do
      count = multi_destonations.where(active: false).count
      count.must_equal 0
    end
  end
end

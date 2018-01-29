require 'spec_helper'

describe PDC::V1::PushTarget do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:push_target) { PDC::V1::PushTarget }

  describe 'count' do
    it 'push_target returns count' do
      count = push_target.count
      count.must_equal 2
    end

    it 'push_target works with where' do
      count = push_target.where(name: 'cdn-qa').count
      count.must_equal 1
    end

    it 'can find push_target by description' do
      count = push_target.where(description: 'CDN qa').count
      count.must_equal 1
    end

    it 'can find push_target by service' do
      count = push_target.where(service: %w[pulp rhn]).count
      count.must_equal 2
    end
  end

  describe '#push_target' do
    it 'returns push_target for name' do
      pt = push_target.where(name: 'cdn-qa')
      pt.wont_be_nil
    end
  end
end

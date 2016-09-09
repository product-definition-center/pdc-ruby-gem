require 'spec_helper'

#WebMock.disable!  # enable to re-record

describe PDC::V1::Release do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:release) { PDC::V1::Release }

  describe 'count' do
    it 'must return number of resources' do
      count = release.count
      count.must_equal 54
    end

    it 'works with where' do
      count = release.where(active: false).count
      count.must_equal 0
    end
  end #  count

  describe '#brew' do
    it 'brew can be nil' do
      first = release.first
      first.brew?.must_equal false
      first.brew.try(:default_target).must_be_nil
    end

    it 'brew may be present' do
      rhel_6_sat = release.find('satellite-6.2-updates@rhel-6')
      rhel_6_sat.brew.wont_be_nil
      rhel_6_sat.brew.default_target.must_be_nil

      allowed_tags = rhel_6_sat.brew.allowed_tags
      allowed_tags.first.must_equal 'satellite-6.2.0-rhel-6'
    end
  end #  brew

  describe '#variants' do
    it 'fetches variants of a release' do
      rhel7_1 = release.find('rhel-7.1')
      variants = rhel7_1.variants.all
      variants.length.must_equal 12
      releases = variants.map {|v| v.release }
      releases.must_equal [rhel7_1] * variants.length
    end
  end

  describe '#url' do
    it 'fetched release must have correct url' do
      rhel7_1 = release.find('rhel-7.1')
      rhel7_1.url.must_equal 'https://pdc.host.dev.eng.pek2.redhat.com/rest_api/v1/releases/rhel-7.1'
    end

    it 'fetched release variants must have correct url' do
      rhel7_1 = release.find('rhel-7.1')
      rhel7_1.variants.all.each do |v|
        v.url.must_equal ('https://pdc.host.dev.eng.pek2.redhat.com/rest_api/v1/release%2Dvariants/rhel-7.1/' + v.uid)
      end
    end
  end
end

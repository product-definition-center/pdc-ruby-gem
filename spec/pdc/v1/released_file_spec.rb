require 'spec_helper'

# WebMock.disable!  # enable to re-record

describe PDC::V1::ReleasedFile do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:released_file) { PDC::V1::ReleasedFile }

  describe 'count' do
    it 'returns number of released files' do
      count = released_file.count
      count.must_equal 2
    end

    it 'get released files by file primary key' do
      count = released_file.where(file_primary_key: 5).count
      count.must_equal 1
    end

    it 'get released files by release id' do
      count = released_file.where(release_id: 'rhel-6.8').count
      count.must_equal 1
    end

    it 'returns release file by retrieve' do
      rf = released_file.find(39)
      rf.url.must_equal(PDC_SITE + 'rest_api/v1/released%2Dfiles/39')
    end
  end
end

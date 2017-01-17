require 'spec_helper'

# WebMock.disable!  # enable to re-record

describe PDC do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  describe 'count' do
    let(:release) { PDC::V1::Release }
    let(:arch) { PDC::V1::Arch }

    it 'must return number of resources' do
      count = release.count
      count.must_equal 54
    end

    it 'works with where' do
      count = release.where(active: false).count
      count.must_equal 0
    end

    it 'returns the total count and not items in page' do
      total_count = arch.count
      page_count = arch.page(2).count
      page_count.must_equal total_count

      arch_in_page = arch.page(2).contents!
      arch_in_page.length.must_be :<, page_count
    end

    it '.page.count returns total count' do
      pg2 = arch.page(2)
      pg2_count = pg2.all.length

      arches_count = pg2.count # must return all arches count
      arches_count.wont_equal pg2_count
    end
  end
end

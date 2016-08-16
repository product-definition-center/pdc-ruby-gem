require 'spec_helper'

describe PDC do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:arch) { PDC::V1::Arch }

  it 'has an attribute name' do
    arch.attributes.must_equal ['name']
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

    arches_count = pg2.count      # must return all arches count
    arches_count.wont_equal pg2_count
  end
end

require 'spec_helper'

# WebMock.disable!  # enable to re-record

describe PDC::V1::VariantCpe do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:cpe) { PDC::V1::VariantCpe }

  describe 'count' do
    it 'cpe returns number' do
      count = cpe.count
      count.must_equal 1
    end

    it 'cpe works with where' do
      count = cpe.where(cpe: 'cpe:test').count
      count.must_equal 1
      count = cpe.where(variant_uid: 'Calamari').count
      count.must_equal 1
    end
  end
end

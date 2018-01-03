require 'spec_helper'

describe PDC::V1::ReleaseVariant do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:release_variant) { PDC::V1::ReleaseVariant.first }
  let(:cpe_variant) { PDC::V1::ReleaseVariant }

  it 'must has version_ attributes' do
    attributes = release_variant.attributes
    attributes.must_include :variant_version, :variant_release
  end

  it 'returns cpe' do
    variant = cpe_variant.first
    cpe = variant.cpe
    cpe.variant_uid.must_equal 'Calamari'
    cpe.cpe.must_equal 'cpe:test'
  end
end

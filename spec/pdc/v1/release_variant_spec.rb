require 'spec_helper'

describe PDC::V1::ReleaseVariant do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:release_variant) { PDC::V1::ReleaseVariant.first }

  it 'must has version_ attributes' do
    attributes = release_variant.attributes
    attributes.must_include :variant_version, :variant_release
  end
end

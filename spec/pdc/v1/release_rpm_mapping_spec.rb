require 'spec_helper'

describe PDC::V1::ReleaseRpmMapping do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:mapping) {PDC::V1::ReleaseRpmMapping.where(:release_id => 'rhel-7.1', :package => 'tuned').first}
  it 'must has compose' do
    mapping.mapping.must_be_instance_of OpenStruct
  end
end

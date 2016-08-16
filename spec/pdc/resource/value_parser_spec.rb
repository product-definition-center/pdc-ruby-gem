require 'spec_helper'

describe PDC::Resource::ValueParser do
  subject { PDC::Resource::ValueParser }

  it 'must respond_to? parse' do
    subject.must_respond_to :parse
  end

  describe '#parse' do
    it 'must return value for plain types' do
      subject.parse(:foobar).must_equal :foobar
    end
  end
end

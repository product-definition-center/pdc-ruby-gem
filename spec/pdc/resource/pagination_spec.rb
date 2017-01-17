require 'spec_helper'

describe PDC do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  describe 'pagination' do
    let(:arch) { PDC::V1::Arch }
    let(:release_variant) { PDC::V1::ReleaseVariant }

    it 'can iterate using each' do
      count = arch.count # makes single call

      all = arch.scoped.each_with_object([]) do |a, o|
        o << a
      end
      count.must_equal all.length
    end

    it 'preserves the filters' do
      variants = release_variant.where(type: 'variant', name: 'rh-common')
      count = variants.count

      all = variants.each_with_object([]) do |a, o|
        o << a
      end
      count.must_equal all.length
    end
  end

  describe 'page' do
    subject { PDC::V1::Arch }
    it 'returns resources on that page' do
      pg2 = subject.page(2)
      resources = pg2.contents!
      resources.length.must_equal 20
    end

    it 'should not be in the list of attributes' do
      pg2 = subject.page(2)
      arch = pg2.all.first
      arch.attributes.wont_include :page
      arch.attributes.wont_include 'page'
    end
  end
end

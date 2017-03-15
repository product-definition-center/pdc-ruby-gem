require_relative '../lib/pdc'
require_relative '../spec/spec_helper'

WebMock.disable! # this uses real server

#### service config ####
def token
  script_path = File.expand_path(File.dirname(__FILE__))
  token_path = File.join(script_path, '.token', 'pdc.prod')
  File.read(token_path).chomp.tap { |x| puts "Using token :#{x}" }
rescue Errno::ENOENT => e
  puts "Hey! did you forget to create #{token_path} \n"
  raise e
end

#### server config ####

server = {
  local: {
    site: 'http://localhost:8000',
    token: nil
  },

  prod: {
    site: 'https://pdc.engineering.redhat.com',
    token: ->() { token } # read token only if needed
  }
}

# server to use
pdc = server[:prod]
pdc = server[:local]

PDC.configure do |config|
  config.site = pdc[:site]
  auth_token = pdc[:token]
  config.token = pdc[:token].call if auth_token
  config.requires_token = auth_token.present? # to_bool
end

#### product ####

describe PDC::V1::Product do
  let(:product_class) { PDC::V1::Product }
  it 'has_many product_versions' do
    p1 = product_class.scoped.first
    p1.product_versions.must_be_instance_of Array
    # TODO: continue the after release and release-variants
  end
end

#### Arch ####

describe PDC::V1::Arch do
  let(:arch_class) { PDC::V1::Arch }

  describe 'contents!' do
    it 'only returns contents of a page' do
      arches = arch_class.scoped.contents!
      (0..arch_class.count).must_include arches.length

      arches_pg1 = arch_class.page(1).contents!
      arches_pg1.must_equal arches

      arches_pg2 = arch_class.page(2).contents!
      arches_pg1.wont_equal arches_pg2
    end
  end

  describe '#page' do
    it 'can access page(2)' do
      arch_class.page(2).must_be_instance_of PDC::Resource::Relation
    end

    it 'must return resource on page(2).to_a' do
      arches = arch_class.page(2).to_a
      arches.first.must_be_instance_of arch_class
    end
  end

  describe '#each_page' do
    it 'must be able to iterate using map' do
      resource_count = arch_class.count

      arches = arch_class.scoped.map(&:name)
      arches.must_be_instance_of Array
      arches.first.must_be_instance_of String

      arches.count.must_equal resource_count
    end
  end

  describe '#page_size' do
    it 'must return all records when page_size is -1' do
      all_arches = arch_class.page_size(-1).to_a
      all_arches_count = arch_class.count
      all_arches.must_be_instance_of Array
      all_arches.length.must_equal all_arches_count
    end

    it 'all! is the same as page_size(-1)' do
      all_arches = arch_class.all!
      all_arches_count = arch_class.count
      all_arches.must_be_instance_of Array
      all_arches.length.must_equal all_arches_count
    end
  end

  describe '#find' do
  end
end

### TODO: debug - remove this
A = PDC::V1::Arch
R = PDC::V1::Release
RV = PDC::V1::ReleaseVariant
###

describe PDC::V1::Release do
  let(:release_class) { PDC::V1::Release }
  let(:existing_release) { release_class.all!.first }

  describe '#find' do
    it 'must return a record' do
      found = release_class.find(existing_release.release_id)
      found.must_be_instance_of release_class
      found.release_id.must_equal existing_release.release_id
    end
  end

  describe '#variants' do
    let(:sat_6_at_rhel_7) { release_class.find('satellite-6.0.4@rhel-7') }
    let(:release_variant_class) { PDC::V1::ReleaseVariant }

    it 'must be a HasMany association' do
      skip 'TODO implement Assocations'
      variants_relation = sat_6_at_rhel_7.variants
      variants_relation.must_be_instance_of PDC::Resource::HasManyAssociation
    end

    it 'must be able to call all! to return all variants ' do
      variants_relation = sat_6_at_rhel_7.variants
      ap variants_relation.params
      release_id = variants_relation.params[:release]
      release_id.must_equal sat_6_at_rhel_7.id

      all_variants = variants_relation.all!
      expected = variants_relation.where(page_size: -1).to_a

      all_variants.must_equal expected
    end

    it 'must return release variants for a release' do
      variants_relation = sat_6_at_rhel_7.variants
      variants = variants_relation.to_a
      variants.must_be_instance_of Array
      variants.length.must_be :>=, 1
      variants.first.must_be_instance_of release_variant_class
    end
  end
end

describe PDC::V1::ReleaseVariant do
  let(:release_class) { PDC::V1::Release }
  let(:release_variant_class) { PDC::V1::ReleaseVariant }
  let(:a_variant) { release_variant_class.all!.first }

  describe '#release' do
    it 'must fetch the release it belongs to' do
      a_variant.release.must_be_instance_of release_class
    end
  end
end

describe PDC::V1::ContentDeliveryRepo do
  let(:repo_class) { PDC::V1::ContentDeliveryRepo }
  let(:existing_repo) { repo_class.all!.first }

  describe '#find' do
    it 'must return a record' do
      found = repo_class.find(existing_repo.id)
      found.must_be_instance_of repo_class
      found.name.must_equal existing_repo.name
    end
  end
end

# using prod server to test PDC::V1::ReleaseRpmMapping
pdc = server[:prod]

PDC.configure do |config|
  config.site = pdc[:site]
  auth_token = pdc[:token]
  config.token = pdc[:token].call if auth_token
  config.requires_token = auth_token.present? # to_bool
end

describe PDC::V1::ReleaseRpmMapping do
  let(:mapping) do
    PDC::V1::ReleaseRpmMapping.where(
      release_id: 'ceph-2.1-updates@rhel-7',
      package: 'ceph'
    ).first
  end
  it 'must has compose' do
    mapping.mapping.must_be_instance_of OpenStruct
  end
end

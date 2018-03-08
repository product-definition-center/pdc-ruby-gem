require 'spec_helper'

describe PDC::Resource::Associations do
  subject { PDC::Resource::Associations }

  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  let(:site) { 'https://example.com' }

  let(:releases_url1) do
    URI.join(site, PDC.config.api_root, 'v1/releases/?product_version=ceph-1&release_id=ceph-1.3@rhel-7')
  end

  let(:releases_url2) do
    URI.join(site, PDC.config.api_root, 'v1/releases/?product_version=ceph-1')
  end

  describe 'association' do
    it 'association independence' do
      assert_kind_of subject::HasMany, Fixtures::ProductVersion.new.releases
      assert_raises NoMethodError do
        Fixtures::ProductVersion.new.non_existings
      end
    end

    it 'has many association' do
      releases = Fixtures::ProductVersion.new(product_version_id: 'dp-1').releases.to_a
      assert_equal 'dp-1.0', releases.first.release_id
    end

    it 'find on has many association' do
      release = Fixtures::ProductVersion.new(product_version_id: 'dp-1').releases.find('dp-1.0')
      assert_equal 'dp-1.0', release.release_id
    end

    it 'scopes on associations' do
      releases = Fixtures::ProductVersion.new(product_version_id: 'dp-1').releases.where(release_id: 'dp-1.0').to_a
      assert_equal 'dp-1.0', releases.first.release_id
    end
  end

  describe 'array like' do
    it 'behaves like an array' do
      product_version = Fixtures::ProductVersion.new(product_version_id: 'ceph-1')
      assert_equal %w[ceph-1.3@rhel-7 ceph-1.3-updates@rhel-7], product_version.releases[0..1].map(&:release_id)
      assert_equal 'ceph-1.3@rhel-7', product_version.releases.first.release_id
      assert_equal 'ceph-1.3-updates@rhel-7', product_version.releases.last.release_id
    end
  end

  describe 'cache' do
    it 'cached result for associations' do
      product_version = Fixtures::ProductVersion.new(product_version_id: 'ceph-1')
      releases = product_version.releases.where(release_id: 'ceph-1.3@rhel-7')
      all_releases = product_version.releases.to_a
      assert_equal releases.first.data[0].name, 'Red Hat Ceph Storage'
      assert_equal all_releases[0]['data'].count, 2
    end
  end

  describe 'reflect' do
    it 'reflect on association' do
      assert_equal Fixtures::Release, Fixtures::ProductVersion.reflect_on_association(:release).klass
    end

    it 'custom class name' do
      assert_equal Fixtures::Release, Fixtures::ProductVersion.reflect_on_association(:active_release).klass
    end
  end
end

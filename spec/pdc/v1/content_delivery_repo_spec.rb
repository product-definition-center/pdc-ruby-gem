require 'spec_helper'

describe PDC::V1::ContentDeliveryRepo do
  before do
    VCR.insert_cassette fixture_name
  end

  after do
    VCR.eject_cassette
  end

  describe 'count' do
    it 'has serveral cdn content delivery repos' do
      content_delivery_repos = PDC::V1::ContentDeliveryRepo
				.where(release_id: 'ceph-2.1-updates@rhel-7', service: 'pulp')
      assert_equal 18, content_delivery_repos.count
    end
  end

  describe 'find' do
    it 'content delivery repos must return a record' do
      repo_class = PDC::V1::ContentDeliveryRepo
      existing_repo = PDC::V1::ContentDeliveryRepo
			.where(release_id: 'ceph-2.1-updates@rhel-7', service: 'pulp')
			.first
      found = repo_class.find(existing_repo.id)
      found.must_be_instance_of repo_class
      found.name.must_equal existing_repo.name
    end
  end
end


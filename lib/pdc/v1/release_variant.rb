module PDC::V1
  class ReleaseVariant < PDC::Base
    self.primary_key = :id

    attributes :release, :uid, :name, :type, :arches,
               :variant_version, :variant_release,
               :allowed_push_targets

    def release
      Release.find(attributes[:release])
    end

    ### NOTE
    # ReleaseVariant is different from other resources in the way
    # its url is created so it requires special handling
    def initialize(attrs = {})
      super

      instance_uri = self.class.resource_path + '/(:release)/(:uid)'
      instance_path = PDC::Resource::Path.new(instance_uri, attrs).expanded
      @url = connection.build_url(instance_path).to_s
    end

    # attribute_rename :release, :release_id

    # belongs_to :release, class_name: 'PDC::V1::Release',
    # uri: "#{api_path}/releases/:release_id"
  end
end

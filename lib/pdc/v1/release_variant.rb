module PDC::V1
  class ReleaseVariant < PDC::Base

    attributes :release, :uid, :name, :type, :arches

    def release
      Release.find(attributes[:release])
    end

    def url
      URI.join(PDC.config.site, PDC.config.api_root,
               PDC::Resource::Path.new(self.class.resource_path + '/(:release)/(:uid)', attributes).expanded).to_s
    end


    # attribute_rename :release, :release_id

    # belongs_to :release, class_name: 'PDC::V1::Release',
               # uri: "#{api_path}/releases/:release_id"
  end
end


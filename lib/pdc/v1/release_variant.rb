module PDC::V1
  class ReleaseVariant < PDC::Base
    self.primary_key = :id

    attributes :release, :uid, :name, :type, :arches

    def release
      Release.find(attributes[:release])
    end

    # attribute_rename :release, :release_id

    # belongs_to :release, class_name: 'PDC::V1::Release',
               # uri: "#{api_path}/releases/:release_id"
  end
end


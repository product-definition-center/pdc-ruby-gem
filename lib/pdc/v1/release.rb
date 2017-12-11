module PDC
  module V1
    class Release < PDC::Base
      attributes :short, :version, :name, :base_product,
                 :active, :product_version, :release_type,
                 :compose_set, :integrated_with, :bugzilla,
                 :dist_git, :brew, :product_pages, :errata,
                 :sigkey, :allow_buildroot_push,
                 :allowed_debuginfo_services, :allowed_push_targets

      def variants
        @variants ||= ReleaseVariant.where(release: id)
      end

      # TODO: implement using has_many association
      # has_many :variants, class_name: 'PDC::V1::ReleaseVariant',
      # uri: "#{api_path}/release-variants/?release=:release_id"
    end
  end
end

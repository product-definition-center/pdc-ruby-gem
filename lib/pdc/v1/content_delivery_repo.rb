module PDC
  module V1
    class ContentDeliveryRepo < PDC::Base
      attributes :arch, :content_category, :content_format,
                 :name, :product_id, :release_id, :repo_family,
                 :service, :shadow, :variant_uid
    end
  end
end

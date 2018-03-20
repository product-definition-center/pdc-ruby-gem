module PDC::V1
  class Product < PDC::Base
    attributes :name, :short, :active, :product_versions, :internal, :allowed_push_targets
  end
end

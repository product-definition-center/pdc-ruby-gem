module PDC
  module V1
    class MultiDestination < PDC::Base
      attributes :id, :destination_repo, :global_component,
                 :base_product, :active, :origin_repo, :subscribers
    end
  end
end

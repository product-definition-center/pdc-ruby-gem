module PDC::V1
  class ReleaseRpmMapping < PDC::Base
    attributes :compose, :mapping

    def self.uri
      @uri = '/rest_api/v1/releases/(:release_id)/rpm-mapping/(:package)/'
    end
  end
end

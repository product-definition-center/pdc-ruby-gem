module PDC::Resource
  module RestApi
    extend ActiveSupport::Concern

    included do
      class_attribute :connection, instance_accessor: false
    end

    module ClassMethods
      def request(method, path, query = {})
        PDC.logger.debug '  >>>'.yellow + " : #{path.ai} #{query.ai}"
        ActiveSupport::Notifications.instrument('request.pdc', method: method) do |payload|
          response = connection.send(method) do |request|
            request.url path, query
          end
          payload[:url], payload[:status] = response.env.url, response.status
          PDC::Http::Result.new(response)
        end
      end

      def fetch(relation)
        # TODO: handle v1/release-variant/(:release)/(:variant)
        # attributes won't contain (:release) and (:variant_id)
        params = relation.params
        resource_path = Path.new(relation.uri, params)

        uri = resource_path.expanded
        query = params.except(*resource_path.variables)
        request(:get, uri, query)
      end
    end # classmethod
  end
end


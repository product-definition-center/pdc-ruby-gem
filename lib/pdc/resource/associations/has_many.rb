require 'pdc/resource/associations/association'

module PDC::Resource
  module Associations
    class HasMany < Association
      def initialize(*args)
        super
        # This is the default uri. It can be overrided when defining a has_many association
        # if the uri is different with the default one.
        # E.g: has_many :releases, uri: 'rest_api/v1/releases/?product_version=:product_version_id'
        @options.reverse_merge!(uri: "#{parent_path}/:#{foreign_key}/#{@name}/(:#{primary_key})")
        @params[foreign_key] = parent.id
      end

      def load
        self
      end

      private

      def parent_path
        parent.class.model_name.element.pluralize
      end
    end
  end
end

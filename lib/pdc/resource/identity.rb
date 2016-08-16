require 'pdc'
require_relative 'path'

module PDC::Resource
  # handles id, primary_key and uri of a Resource
  module Identity
    extend ActiveSupport::Concern

    module ClassMethods
      def primary_key
        @primary_key ||= default_primary_key
      end

      def primary_key=(value)
        @primary_key = value
      end

      def uri(value = nil)
        @uri ||= Path.new(value || default_uri).to_s
      end

      # returns <version>/<resource-name> from the class.name
      def resource_path
        @resource_path ||= model_name.collection.sub(%r{^pdc\/}, '').tr('_', '-')
      end

      private

      def default_uri
        resource_path + "/(:#{primary_key})"
      end

      # default pkey for FooBar is foo_bar_id
      def default_primary_key
        model_name.foreign_key.to_s
      end
    end #  ClassMethods

    def id?
      attributes[primary_key].present?
    end

    def id
      attributes[primary_key]
    end

    def id=(value)
      attributes[primary_key] = value if value.present?
    end

    def hash
      id.hash
    end

    def ==(other)
      other.instance_of?(self.class) && id? && id == other.id
    end
    alias :eql? :==

    def as_json(options = nil)
      attributes.as_json(options)
    end

    def uri
      Path.new(self.class.uri.to_s, attributes).expanded
    end

    private
      # helper method so that primary_key can be called directly
      # from an instance
      def primary_key
        self.class.primary_key
      end
  end
end

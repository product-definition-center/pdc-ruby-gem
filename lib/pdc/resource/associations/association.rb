require 'pdc/resource/relation'

module PDC::Resource
  module Associations
    class Association < Relation
      attr_reader :parent, :name

      def initialize(klass, parent, name, options = {})
        super(klass, options)
        @parent = parent
        @name = name
      end

      private

      def foreign_key
        (@options[:foreign_key] || "#{parent.class.model_name.element}_id").to_sym
      end
    end
  end
end

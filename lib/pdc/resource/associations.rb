require 'pdc/resource/associations/association'
require 'pdc/resource/associations/builder'
require 'pdc/resource/associations/belongs_to'

module PDC::Resource
  module Associations
    extend ActiveSupport::Concern

    included do
      class_attribute :associations
      self.associations = {}.freeze
    end

    module ClassMethods
      def belongs_to(name, options = {})
        create_association(name, BelongsTo, options)
      end

      private

      def create_association(name, type, options)
        self.associations = associations.merge(name => Builder.new(self, name, type, options))
      end
    end
  end
end

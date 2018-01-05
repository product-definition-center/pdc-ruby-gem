require 'pdc/associations/association'
require 'pdc/associations/builder'
require 'pdc/associations/belongs_to'

module PDC
  module Associations
    extend ActiveSupport::Concern

    included do
      class_attribute :associations
      self.associations = {}.freeze
    end

    module ClassMethods
      def belongs_to(name, options = {})
        create_association(name, BelongsTo, options)

        # define_method "build_#{name}" do |attributes = nil|
        #   puts "...... add new attr into association ................................"
        #   association(name).build(attributes)
        # end
      end

      private

      def create_association(name, type, options)
        puts "...... #{self} creates association belongs to ............................"
        self.associations = associations.merge(name => Builder.new(self, name, type, options))
      end
    end
  end
end

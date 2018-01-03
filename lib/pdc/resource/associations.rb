require 'pdc/resource/associations/has_many'
require 'pdc/resource/associations/association'
require 'pdc/resource/associations/builder'

module PDC::Resource
  module Associations
    extend ActiveSupport::Concern

    included do
      class_attribute :associations
      self.associations = {}.freeze
    end

    module ClassMethods
      def has_many(name, options = {})
        create_association(name, HasMany, options)

        define_method "#{name.to_s.singularize}_ids=" do |ids|
          attributes[name] = []
          ids.reject(&:blank?).each { |id| association(name).build(id: id) }
        end

        define_method "#{name.to_s.singularize}_ids" do
          association(name).map(&:id)
        end
      end

      def reflect_on_association(name)
        associations[name] || associations[name.to_s.pluralize.to_sym]
      end

      private

      def create_association(name, type, options)
        self.associations = associations.merge(name => Builder.new(self, name, type, options))
      end
    end
  end
end

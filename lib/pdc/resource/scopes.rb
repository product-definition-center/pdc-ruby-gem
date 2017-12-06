module PDC::Resource
  module Scopes
    extend ActiveSupport::Concern

    module ClassMethods
      delegate :find, :count, :where, :first, :all!, :all, to: :scoped

      def scoped
        current_scope || Relation.new(self, uri: uri)
      end

      def scope(name, code)
        define_singleton_method name, code
      end

      def current_scope=(value)
        ScopeRegistry.set_value_for(:current_scope, name, value)
      end

      def current_scope
        ScopeRegistry.value_for(:current_scope, name)
      end
    end

    def scoped
      self.class.scoped
    end
  end
end

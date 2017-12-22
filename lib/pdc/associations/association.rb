require 'pdc/http/result'

module PDC
  module Associations
    class Association < PDC::Resource::Relation
      attr_reader :parent, :name

      def initialize(klass, parent, name, options = {})
        super(klass, options)
        @parent, @name = parent, name
      end

      def load
        find_one! # Override for plural associations that return an association object
      end

      def assign_nested_attributes(attributes)
        update_parent new(attributes)
      end

      def create(attributes = {})
        add_to_parent super
      end

      def new(*args)
        add_to_parent super
      end

      alias :build :new

      private

        def add_to_parent(record)
          update_parent record
        end

        def fetch
          fetch_embedded || super
        end

        def fetch_embedded
          if embedded
            PDC::HTTP::Result.new(data: embedded)
          elsif !uri
            PDC::HTTP::Result.new(data: nil)
          end
        end

        def embedded
          parent.attributes[name]
        end

        def update_parent(value)
          parent.attributes[name] = value
        end
    end
  end
end

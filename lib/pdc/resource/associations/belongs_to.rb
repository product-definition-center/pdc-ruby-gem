module PDC::Resource
  module Associations
    class BelongsTo < Association
      def initialize(*args)
        super
      end

      def load
        klass.find(parent.attributes[foreign_key])
      end
    end
  end
end

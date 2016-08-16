require 'active_support'

module PDC::Resource
  module AttributeModifier
    extend ActiveSupport::Concern

    module ClassMethods
      # rename an existing attribute `from` to `to`
      # NOTE from must exist and to must not
      def attribute_rename(from, to)
        attribute_modifications << [:rename, from, to]
      end

      def attribute_modifications
        @attribute_modifications ||= []
      end
    end

    def initialize(attrs = {})
      super
      self.class.attribute_modifications.each do |what, *args|
        case what
        when :rename
          apply_attr_rename(*args)
        else
          PDC.logger.warn "Invalid attribute transformation #{what}: #{from} #{to}"
        end
      end

      yield self if block_given?
    end

    private

    def apply_attr_rename(from, to)
      if attributes.key?(from) && !attributes.key?(to)
        attributes[to] = attributes.delete(from)
      else
        PDC.logger.info "rename: not applied for from: #{from}, to: #{to} | #{attributes}"
      end
    end
  end
end

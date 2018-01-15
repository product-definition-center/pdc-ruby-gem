module PDC::Resource
  module Attributes
    extend ActiveSupport::Concern

    included do
      attr_reader :attributes
      delegate :[], to: :attributes
    end

    # :nodoc:
    module ClassMethods
      # define attributes on Model using
      # attributes :attribute_name, attribute_name_2 ...
      #
      def attributes(*names)
        return attributes_metadata.keys if names.empty?
        names.each { |n| attributes_metadata[n] ||= default_metadata }
        define_methods_in_container(names)
      end

      def attribute(name, metadata)
        attr_exists = attributes_metadata.key?(name)
        attributes_metadata[name] ||= default_metadata
        attributes_metadata[name].merge!(metadata)

        define_methods_in_container(name) unless attr_exists
      end

      def attributes_metadata
        @attributes_metadata ||= HashWithIndifferentAccess.new(primary_key => default_metadata)
      end

      def attribute_parser(name)
        # do not add to attributes of the class if not already present
        metadata = attributes_metadata.fetch(name, default_metadata)
        metadata[:parser]
      end

      private

      def default_metadata
        { parser: ValueParser }
      end

      def define_methods_in_container(names)
        instance_method_container.module_eval do
          Array.wrap(names).each do |name|
            define_method(name) do
              attribute(name)
            end
          end
        end
      end

      # By adding instance methods via an included module, they become
      # overridable with "super".
      # see: http://thepugautomatic.com/2013/07/dsom/
      def instance_method_container
        unless @instance_method_container
          @instance_method_container = Module.new
          include @instance_method_container
        end
        @instance_method_container
      end
    end

    def initialize(attributes = {})
      self.attributes = attributes
      @uri_template = scoped.uri
      yield(self) if block_given?
    end

    def attributes=(new_attributes)
      @attributes ||= AttributeStore.new
      use_setters(new_attributes) if new_attributes
    end

    def []=(name, value)
      set_attribute(name, value)
    end

    def inspect
      "#<#{self.class}(#{@uri_template}) id: #{id.inspect} #{inspect_attributes}>"
    end

    private

    def use_setters(attributes)
      attributes.each { |key, value| public_send "#{key}=", value }
    end

    def method_missing(name, *args, &block)
      if association?(name) then association(name).load
      elsif attribute?(name) then attribute(name)
      elsif predicate?(name)   then predicate(name)
      elsif setter?(name)      then set_attribute(name, args.first)
      else super
      end
    end

    def respond_to_missing?(name, include_private = false)
      attribute?(name) || predicate?(name) || setter?(name) || super
    end

    def association?(name)
      associations.key?(name)
    end

    def association(name)
      associations[name].build(self)
    end

    def attribute?(name)
      # raise if associations.key?(name)
      attributes.key?(name) || self.class.attributes_metadata.key?(name)
    end

    def attribute(name)
      attributes[name]
    end

    def predicate?(name)
      name.to_s.end_with?('?') && attributes.key?(name[0..-2])
    end

    def predicate(name)
      attribute(depredicate(name)).present?
    end

    def depredicate(name)
      name.to_s.chomp('?').to_sym
    end

    def setter?(name)
      name.to_s.end_with?('=')
    end

    def set_attribute(name, value)
      attr_name = name.to_s.chomp('=')
      unless attribute?(attr_name)
        logger.warn "Setting unknown attribute: #{attr_name} #{self.class.name}"
      end
      parser = self.class.attribute_parser(attr_name)
      attributes[attr_name] = parser.parse(value)
    end

    def inspect_attributes
      attributes.map { |k, v| "#{k}: #{v.inspect}" }.join(' ')
    end
  end
end

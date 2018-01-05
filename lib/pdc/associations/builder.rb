module PDC
  module Associations
    class Builder
      attr_reader :parent_class
      def initialize(parent_class, name, type, options = {})
        @parent_class = parent_class
        @name = name
        @type = type
        @options = options
      end

      def build(parent)
        @type.new(klass, parent, @name, @options)
      end

      def klass
        # @klass ||= custom_class || compute_class(@name)
        @klass ||= custom_class
      end

      private

      def custom_class
        @options[:class_name].constantize if @options[:class_name]
      end

      # https://github.com/rails/rails/blob/70ac072976c8cc6f013f0df3777e54ccae3f4f8c/activerecord/lib/active_record/inheritance.rb#L132-L150
      # Can't compute class name here because the column is same as class name
      def compute_class(type_name)
        parent_name = @parent_class.to_s
        type_name = type_name.to_s.classify

        candidates = []
        parent_name.scan(/::|$/) { candidates.unshift "#{$`}::#{type_name}" }
        candidates << type_name

        puts candidates
        candidates.each do |candidate|
          constant = ActiveSupport::Dependencies.safe_constantize(candidate)
          return constant if candidate == constant.to_s
        end
        raise NameError.new("uninitialized constant #{candidates.first}", candidates.first)
      end
    end
  end
end

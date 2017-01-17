module PDC::Resource
  class AttributeStore < HashWithIndifferentAccess
    def to_params
      each_with_object({}) do |(key, value), parameters|
        parameters[key] = parse_value(value)
      end.with_indifferent_access
    end

    private

    def parse_value(value)
      if value.is_a?(PDC::Base) then value.attributes.to_params
      elsif value.is_a?(Array) then value.map { |v| parse_value(v) }
      else value
      end
    end
  end
end

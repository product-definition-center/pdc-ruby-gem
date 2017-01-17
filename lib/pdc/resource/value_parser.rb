module PDC::Resource
  # Internal
  # ValueParser takes in a value and returns the parsed form of the input
  # e.g. Hash gets converted to OpenStruct so that
  # foo: {
  #   bar: {
  #     too: 'too moo',
  #     baz: {
  #       value: 'foobarbaz'
  #     }
  #   }
  # }
  # can be accessed as foo.bar.too and foo.bar.baz.value
  class ValueParser
    class << self
      def parse(value)
        if value.is_a?(Array) then value.map { |v| parse(v) }
        elsif value.is_a?(Hash) then OpenStruct.new(parse_hash(value))
        else value
        end
      end

      private

      def parse_hash(hash)
        hash.map { |k, v| [k.to_sym, parse(v)] }.to_h
      end
    end
  end
end

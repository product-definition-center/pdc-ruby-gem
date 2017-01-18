require 'uri_template'

module PDC::Resource
  class Path
    def initialize(pattern, params = {})
      @pattern = pattern
      @params = params.symbolize_keys
    end

    def join(other_path)
      self.class.new File.join(path, other_path.to_s), @params
    end

    def to_s
      @pattern
    end

    def expanded
      path.to_s
    end

    def variables
      @variables ||= uri_template.variables.map(&:to_sym)
    end

    private

    def path
      validate_required_params!
      uri_template.expand(@params).chomp('/')
    end

    def uri_template
      @uri_template ||= URITemplate.new(:colon, pattern_with_rfc_style_parens)
    end

    def pattern_with_rfc_style_parens
      @pattern.tr('(', '{').tr(')', '}')
    end

    def validate_required_params!
      return unless missing_required_params.any?
      missing_params = missing_required_params.join(', ')
      raise PDC::InvalidPathError, "Missing required params: #{missing_params} in #{@pattern}"
    end

    def missing_required_params
      required_params - params_with_values
    end

    def params_with_values
      @params.map do |key, value|
        key if value.present?
      end.compact
    end

    def required_params
      @pattern.scan(%r{/:(\w+)}).flatten.map(&:to_sym)
    end
  end
end

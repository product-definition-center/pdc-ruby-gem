require_relative 'per_thread_registry'

module PDC::Resource
  class ScopeRegistry
    extend PerThreadRegistry

    def initialize
      @store = Hash.new { |hash, key| hash[key] = {} }
    end

    def value_for(scope_type, variable_name)
      @store[scope_type][variable_name]
    end

    def set_value_for(scope_type, variable_name, value)
      @store[scope_type][variable_name] = value
    end
  end
end

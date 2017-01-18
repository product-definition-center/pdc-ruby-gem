module PDC::Resource
  module Query
    extend ActiveSupport::Concern

    def where(conditions)
      return self if conditions.empty?

      relation = clone
      relation.params = params.merge(conditions)
      relation
    end
  end
end

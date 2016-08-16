module PDC::Resource
  PAGINATION = :pagination
  PAGINATION_KEYS = [
    :resource_count,
    :previous_page,
    :next_page,
  ].freeze

  module Pagination
    extend ActiveSupport::Concern

    PDC::Resource::PAGINATION_KEYS.each do |symbol|
      define_method(symbol) do
        result.pagination[symbol]
      end
    end

    def each_page
      return to_enum(:each_page) unless block_given?

      # results are not fetched yet so use the clone for next pages
      # and create new relation based on the next_page metadata

      relation = clone
      yield relation

      until (next_page = relation.next_page).nil?
        relation = self.class.new(klass, uri: next_page)
        yield relation
      end
    end
  end
end

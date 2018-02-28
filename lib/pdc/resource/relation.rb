require 'pdc/resource/relation/query'
require 'pdc/resource/relation/pagination'
require 'pdc/resource/relation/finder'
require 'curb'

module PDC::Resource
  class Relation
    include Enumerable
    include PDC::Logging
    include Query
    include Finder
    include Pagination

    attr_reader :klass
    attr_writer :params
    delegate :to_ary, :[], :any?, :empty?, :last, :size, :metadata, to: :contents!

    alias all to_a

    def initialize(klass, options = {})
      @klass = klass
      @options = options
      @params = {}
    end

    def params
      @params.symbolize_keys
    end

    def uri
      @options[:uri] || klass.uri
    end

    # TODO: need to scale this so that mulitle variables in a uri can
    # be passed - e.g.
    #    ReleaseVarant.uri is 'v1/release-variant/(:release)/(:id)'
    #
    # so find(id, release: 'rel') need to work
    def find(id, vars = {})
      raise PDC::ResourceNotFound if id.blank?

      where(primary_key => id)
        .where(vars)
        .find_one!
    end

    # TODO: handle pagination here
    def each(&block)
      return to_enum(:each) unless block_given?

      each_page do |relation|
        resources = relation.contents!
        resources.each(&block)
      end
    end

    # all! returns all records of the +Resource+
    # NOTE: use this method for resources with small footprint
    def all!
      where(page_size: -1).contents!
    end

    def count
      result.pagination[:resource_count]
    end

    private

    def method_missing(name, *args, &block)
      # pass anything that relation doesn't know to the klass
      super unless klass.respond_to? name

      with_scope { klass.send(name, *args, &block) }
    end

    def respond_to_missing?(name)
      klass.respond_to? name
    end

    # Keep hold of current scope while running a method on the class
    def with_scope
      previous = klass.current_scope
      klass.current_scope = self
      yield
    ensure
      klass.current_scope = previous
    end
  end
end

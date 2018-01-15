module PDC
  module Minitest
    module FixtureExtentions
      # it 'looks like this_and_that' -> 'looks_like_this_and_that'
      def fixture_name
        name.split('_').from(2).join('_').gsub(/\s+/, '_')
      end
    end
  end
end

module Minitest
  class Spec
    include PDC::Minitest::FixtureExtentions
  end
end

# fixtures for testing the PDC::Resource::Modules
module Fixtures
  class EmptyModel
    include ActiveModel::Naming
  end

  class ModelWithIdentity
    extend ActiveModel::Naming

    include PDC::Logging
    include PDC::Resource::Attributes
    include PDC::Resource::Identity
    include PDC::Resource::Scopes
    include PDC::Resource::Associations
  end

  class CustomPrimaryKeyModel
    extend ActiveModel::Naming

    include PDC::Logging
    include PDC::Resource::Attributes
    include PDC::Resource::Identity
    include PDC::Resource::Scopes
    include PDC::Resource::Associations

    self.primary_key = :foobar
  end

  class ModelBase
    extend ActiveModel::Naming

    include PDC::Logging
    include PDC::Resource::Identity
    include PDC::Resource::Attributes
    include PDC::Resource::Scopes
    include PDC::Resource::Associations
  end

  class Model < ModelBase; end

  module V1
    class Foobar
      extend ActiveModel::Naming

      include PDC::Logging
      include PDC::Resource::Identity
      include PDC::Resource::Attributes
      include PDC::Resource::Scopes
      include PDC::Resource::Associations
    end
  end
end

# stub pdc
module Fixtures
  class JSONParser < Faraday::Response::Middleware
    def parse(body)
      json = MultiJson.load(body, symbolize_keys: true)
      {
        data: json[:data],
        metadata: json[:metadata],
        errors: json[:errors]
      }
    rescue MultiJson::ParseError => exception
      { errors: { base: [error: exception.message] } }
    end
  end

  class Base < PDC::Base
    # stub the connection
    SITE = 'http://pdc.eng.redhat.com'.freeze
    self.connection = Faraday.new(url: SITE) do |faraday|
      faraday.request   :json
      faraday.use       JSONParser
      faraday.adapter   Faraday.default_adapter
    end
  end

  class Product < Base
    attributes :name, :description
  end

  class ProductVariant < Base
    self.primary_key = :v_id
  end

  class NestedModel < Base
    attributes :name, :description, :nested
    # nested will be a hash
  end

  class FixNumParser
    class << self
      def parse(value)
        value.to_i
      end
    end
  end
  class CustomParserModel < Base
    attributes :name, :body, :age
    attribute  :age, parser: FixNumParser
  end
end

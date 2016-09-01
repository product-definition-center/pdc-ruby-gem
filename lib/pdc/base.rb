module PDC
  class Base
    extend ActiveModel::Naming

    include PDC::Logging
    include PDC::TokenFetcher
    include PDC::Resource::Identity
    include PDC::Resource::Attributes
    include PDC::Resource::Scopes
    include PDC::Resource::RestApi

    scope :page, ->(value) { where(:page => value) }
    scope :page_size, ->(value) { where(:page_size => value) }
  end
end

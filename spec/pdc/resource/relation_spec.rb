require 'spec_helper'

class SearchableModel < Fixtures::Base
  attributes :name, :product

  ### NOTE: where() will have no impact since the data is hardcoded
  def self.fake_data
    [
      { name: 'foobar-1', product: 'prod' },
      { name: 'foobar-2', product: 'prod' },
      { name: 'foobar-3', product: 'prod' }
    ]
  end

  def self.fetch(_params)
    response = OpenStruct.new(
      body: { data: fake_data },
      status: 200,
      env: OpenStruct.new(url: 'http://foobar')
    )

    PDC::Http::Result.new(response)
  end
end

describe SearchableModel do
  subject { SearchableModel }

  describe '#where' do
    it 'returns a scope with params' do
      filters = { name: :foobar, age: 10 }
      rel = subject.where(filters)

      rel.must_be_instance_of PDC::Resource::Relation
      rel.params.must_equal(filters)
    end

    it 'can be called multiple times' do
      filter_name = { name: :foobar }
      filter_age  = { age: 10 }

      rel = subject.where(filter_name).where(filter_age)
                   .where(filter_name)
      rel.must_be_instance_of PDC::Resource::Relation

      filters = filter_name.merge(filter_age)
      rel.params.must_equal filters
    end
  end

  describe '#find' do
    let(:one_result) { [{ name: 'foobar2', product: 'prod' }] }
    let(:no_result)  { [] }

    it 'returns a record' do
      subject.stub(:fake_data, one_result) do
        result = subject.find(:foobar)
        result.must_be_instance_of SearchableModel
      end
    end

    it 'raises MultipleResultsError more than a record exists' do
      -> { subject.find(:foobar) }.must_raise PDC::MultipleResultsError
    end

    it 'raise ResourceNotFound when no record exists' do
      subject.stub(:fake_data, no_result) do
        -> { subject.find(:foobar) }.must_raise PDC::ResourceNotFound
      end
    end
  end

  it 'can call first' do
    first = subject.first
    first.must_be_instance_of subject
    first.name.must_equal subject.fake_data.first[:name]
  end

  describe 'relation' do
    it 'can call all on a relation' do
      relation = subject.where(name: :foobar)
      relation.must_be_instance_of PDC::Resource::Relation
      results = relation.all
      results.length.must_equal subject.fake_data.length
      results.first.must_be_instance_of subject
    end

    it 'all works with resource' do
      results = subject.all
      results.length.must_equal subject.fake_data.length
    end
  end
end

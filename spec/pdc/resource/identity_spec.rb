require 'spec_helper'
require 'ap'

describe ModelWithIdentity do
  subject { ModelWithIdentity }

  describe '##primary_key' do
    it 'must exist' do
      class_methods = subject.methods - subject.instance_methods
      class_methods.must_include :primary_key
    end

    it 'must default to class_name_id' do
      subject.primary_key.must_equal 'model_with_identity_id'
    end
  end

  describe 'uri' do
    it 'must have a default uri' do
      subject.uri.wont_be_nil
      subject.uri.must_equal 'fixtures/model-with-identities/(:model_with_identity_id)'
    end

    it 'returns path with variables expanded for an object' do
      instance = subject.new(subject.primary_key => :foobar)
      expected_uri = PDC::Resource::Path.new('fixtures/model-with-identities/foobar').expanded
      instance.uri.must_equal expected_uri
    end
  end

  describe 'new' do
    it 'returns nil for id' do
      object = subject.new
      object.id.must_be_nil
    end

    it 'can accept primary_key' do
      pkey = subject.primary_key
      instance = subject.new(pkey => 'something')
      instance.id.must_equal 'something'
      instance.model_with_identity_id.must_equal 'something'
    end
  end
end

describe CustomPrimaryKeyModel do
  subject { CustomPrimaryKeyModel }

  describe '##primary_key' do
    it 'can be set' do
      subject.primary_key.must_equal :foobar
    end
  end

  it 'can accept primary_key' do
    pkey = subject.primary_key
    object = subject.new(pkey => 'something')
    object.id.must_equal 'something'
    object.foobar.must_equal 'something'
  end

  describe 'uri' do
    it 'must use custom primary_key' do
      subject.uri.must_equal 'fixtures/custom-primary-key-models/(:foobar)'
    end
  end
end

describe V1::Foobar do
  subject { V1::Foobar }
  it 'must have a pkey' do
    subject.primary_key.must_equal 'foobar_id'
  end

  it 'must have a uri' do
    subject.uri.must_equal 'fixtures/v1/foobars/(:foobar_id)'
  end
end

describe 'attributes' do
  it 'base must have primary key' do
    ModelBase.new.id.must_be_nil
    base = ModelBase.new(model_base_id: 1)
    base.id.must_equal 1
    base.attributes.must_include :model_base_id
  end

  it 'sub must not have primary key of base' do
    Model.new.id.must_be_nil
    model = Model.new(model_id: 3)
    model.id.must_equal 3
    model.attributes.must_include :model_id
    model.attributes.wont_include :model_base_id
  end
end

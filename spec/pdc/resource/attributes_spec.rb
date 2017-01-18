require 'spec_helper'

describe PDC::Resource::AttributeStore do
  subject { PDC::Resource::AttributeStore }

  it '#to_params' do
    attr = PDC::Resource::AttributeStore.new(
      id: 3, 'title' => 'Fish',
      groups: [
        { name: 'Dessert' }
      ]
    )
    attr.to_params.must_equal(
      'id'     => 3,
      'title'  => 'Fish',
      'groups' => [{ 'name' => 'Dessert' }]
    )
  end
end

describe PDC::Resource::Attributes do
  it 'returns all attributes' do
    Product.attributes.wont_be_empty
  end

  it 'primary_key will be in attributes by default' do
    Product.attributes.must_include Product.primary_key
  end

  it 'allows block initialization' do
    prod = Product.new do |p|
      p.name = 'RHEL'
      p.description = 'Enterprise Linux'
    end
    assert_equal 'RHEL', prod.name
    assert_equal 'Enterprise Linux', prod.description
  end

  it 'can handle predicate' do
    stub_get('products/1').to_return_json(data: [{ id: 1, name: 'RHEL' }])
    product = Product.find(1)
    assert_equal true, product.name?
    assert_equal false, product.description?
  end

  it 'can assign a hash' do
    product = Product.new(id: 2)
    product.attributes = { name: 'RHEL' }

    product.name.must_equal 'RHEL'
    product.id.must_equal 2
  end

  it 'can get and set value' do
    product = Product.new
    product.name = 'RHEL'
    product.name.must_equal 'RHEL'
  end

  it 'works with []' do
    product = Product.new(name: 'Fedora')
    product[:name].must_equal 'Fedora'
  end

  it 'works with []=' do
    product = Product.new
    product[:name] = 'bar'
    product.name.must_equal 'bar'
  end

  it 'allows assigning unknown attributes' do
    product = Product.new

    product.wont_respond_to :foobar
    product.must_respond_to :foobar=

    product.foobar = 'bar'
    product.foobar.must_equal 'bar'
  end

  describe '#respond_to' do
    it 'returns true for known attributes' do
      stub_get('products/1').to_return_json(data: [{ id: 1, name: 'RHEL' }])

      product = Product.find(1)
      product.must_respond_to :name
    end

    it 'returns false for unknown attributes that are not set' do
      stub_get('products/1').to_return_json(data: [{ id: 1, name: 'RHEL' }])

      product = Product.find(1)
      product.wont_respond_to :title
    end

    it 'returns true for unknown attributes after it is set' do
      product = Product.new
      product.wont_respond_to :foobar

      product.foobar = 'bar'
      product.must_respond_to :foobar
      Product.attributes.wont_include :foobar
    end
  end
end

describe 'nested hash attributes' do
  it 'returns OpenStruct for nested hash' do
    allowed_tags = %w(foo bar baz)
    stub_get('nested-models/1').to_return_json(
      data: [{
        id: 1, name: 'RHEL',
        nested: {
          tag: 'foobar',
          allowed_tags: allowed_tags.clone
        }
      }]
    )

    model = NestedModel.find(1)
    model.must_respond_to :nested
    model.nested.must_be_instance_of OpenStruct
    model.nested.must_respond_to :tag
    model.nested.must_respond_to :allowed_tags
    model.nested.tag.must_equal 'foobar'
    model.nested.allowed_tags.must_equal allowed_tags
  end

  it 'returns OpenStruct for deep nested hash' do
    stub_get('nested-models/1').to_return_json(
      data: [{
        id: 1, name: 'RHEL',
        nested: {
          second_level: {
            value: 'deep'
          }
        }
      }]
    )

    model = NestedModel.find(1)
    model.must_respond_to :nested

    model.nested.must_respond_to :second_level
    model.nested.second_level.must_be_instance_of OpenStruct
    model.nested.second_level.must_respond_to :value
    model.nested.second_level.value.must_equal 'deep'
  end

  it 'returns OpenStruct for even unregistered attributes' do
    stub_get('nested-models/1').to_return_json(
      data: [{
        id: 1, name: 'RHEL',
        unregistered_nested: {
          value: 'unregistered'
        }
      }]
    )

    model = NestedModel.find(1)
    model.must_respond_to :unregistered_nested
    model.unregistered_nested.must_be_instance_of OpenStruct
    model.unregistered_nested.must_respond_to :value
    model.unregistered_nested.value.must_equal 'unregistered'
  end
end

describe 'Custom ValueParser' do
  subject { CustomParserModel }
  it 'must return fixnum for age' do
    stub_get('custom-parser-models/1').to_return_json(
      data: [{
        id: 1, name: 'RHEL', age: '20'
      }]
    )

    model = subject.find(1)
    model.must_respond_to :age
    model.age.must_be_instance_of Fixnum
    model.age.must_equal 20
  end
end

# class AttributesTest < MiniTest::Test

# def test_equality
# assert_equal Product.new(id: 2, title: 'Fish'), Product.new(id: 2, title: 'Fish')
# refute_equal Product.new(id: 2, title: 'Fish'), Product.new(id: 1, title: 'Fish')
# refute_equal Product.new(id: 2, title: 'Fish'), 'not_a_spyke_object'
# refute_equal Product.new(id: 2, title: 'Fish'), Image.new(id: 2, title: 'Fish')
# refute_equal Product.new, Product.new
# refute_equal StepImage.new(id: 1), Image.new(id: 1)
# end

# def test_uniqueness
# product_1 = Product.new(id: 1)
# product_2 = Product.new(id: 1)
# product_3 = Product.new(id: 2)
# image_1 = Image.new(id: 2)
# records = [product_1, product_2, product_3, image_1]
# assert_equal [product_1, product_3, image_1], records.uniq
# end

# def test_super_with_explicit_attributes
# assert_equal nil, Product.new.description
# end

# def test_inheriting_explicit_attributes
# assert_equal nil, Image.new.description
# assert_equal nil, Image.new.caption
# assert_raises NoMethodError do
# Image.new.note
# end
# assert_equal nil, StepImage.new.description
# assert_equal nil, StepImage.new.caption
# assert_equal nil, StepImage.new.note
# end

# def test_inspect
# product = Product.new(id: 2, title: 'Pizza', description: 'Delicious')
# output = '#<Product(products/(:id)) id: 2 title: "Pizza" description: "Delicious">'
# assert_equal output, product.inspect
# product = Product.new
# assert_equal '#<Product(products/(:id)) id: nil >', product.inspect
# require 'pry'; binding.pry
# user = Product.new.build_user
# assert_equal '#<User(users/:uuid) id: nil >', user.inspect
# group = Product.new.groups.build
# assert_equal '#<Group(products/:product_id/groups/(:id)) id: nil product_id: nil>', group.inspect
# end
# end

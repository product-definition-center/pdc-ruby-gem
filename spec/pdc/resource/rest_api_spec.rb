require 'spec_helper'

describe :find do
  it 'finds a specific resource' do
    stub_get('products/1')
      .to_return_json(data: [{ product_id: 1, title: 'foobar' }])

    product = Fixtures::Product.find(1)
    product.id.must_equal 1
    product.product_id.must_equal 1
    product.title.must_equal 'foobar'
  end

  it 'must work when primary_key is user defined' do
    stub_get('product-variants/v2')
      .to_return_json(data: [{ v_id: 'v2', title: 'variant' }])

    variant = Fixtures::ProductVariant.find('v2')
    variant.id.must_equal 'v2'
    variant.v_id.must_equal 'v2'
    variant.title.must_equal 'variant'
  end

  describe 'url' do
    it 'returns url for resources fetched from remote' do
      stub_get('products/1')
        .to_return_json(data: [{ product_id: 1, title: 'foobar' }])
      instance = Fixtures::Product.find(1)
      expected_url = Fixtures::Base.connection.build_url('fixtures/products/1').to_s
      instance.url.must_equal expected_url
    end
  end
end

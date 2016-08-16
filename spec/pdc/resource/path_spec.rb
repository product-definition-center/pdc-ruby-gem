require 'spec_helper'

describe PDC::Resource::Path do
  subject { PDC::Resource::Path }

  it 'can handle optional variables' do
    assert_equal '/recipes/(:id)', subject.new('/recipes/(:id)').to_s
    assert_equal '/recipes', subject.new('/recipes/(:id)').expanded
    assert_equal '/recipes/2', subject.new('/recipes/(:id)', id: 2).expanded
  end

  it 'nested collections' do
    path = subject.new('/users/:user_id/recipes/(:id)',
                       user_id: 1, status: 'published')

    assert_equal [:user_id, :id], path.variables
    assert_equal '/users/1/recipes', path.expanded
  end


  it 'nested_resource_path' do
    assert_equal '/users/1/recipes/2', subject.new('/users/:user_id/recipes/:id', user_id: 1, id: 2).expanded
  end

  it 'raises if required_params are missing' do
    lambda {
      subject.new('/users/:user_id/recipes/(:id)', id: 2).expanded
    }.must_raise PDC::InvalidPathError, 'Missing required params: user_id in /users/:user_id/recipes/(:id)'
  end
end

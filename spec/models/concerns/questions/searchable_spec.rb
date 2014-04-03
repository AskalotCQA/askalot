require 'spec_helper'
require 'models/concerns/searchable_spec'

shared_examples_for Questions::Searchable do
  it_behaves_like Searchable
end

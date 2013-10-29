require 'spec_helper'

describe Category do
  it 'requires name' do
    category = build :category, name: ''

    expect(category).not_to be_valid

    category = build :category, name: 'Category'

    expect(category).to be_valid
  end

  it 'has unique name' do
    create :category, name: 'Category'

    category = build :category, name: 'Category'

    expect(category).not_to be_valid
  end
end

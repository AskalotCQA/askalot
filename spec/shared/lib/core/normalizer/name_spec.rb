require 'spec_helper'
require 'shared/core/normalizer/name'

describe Shared::Core::Normalizer::Name do
  subject { described_class }

  it 'parses simple name' do
    value = subject.normalize('Peter Parker')

    expect(value).to eql(
      unprocessed: 'Peter Parker',
      value:       'Peter Parker',
      prefix:      nil,
      first:       'Peter',
      middle:      nil,
      last:        'Parker',
      suffix:      nil,
      addition:    nil,
      flags:       []
    )
  end

  it 'parses middle name' do
    value = subject.normalize('Peter John Parker')

    expect(value).to eql(
      unprocessed: 'Peter John Parker',
      value:       'Peter John Parker',
      prefix:      nil,
      first:       'Peter',
      middle:      'John',
      last:        'Parker',
      suffix:      nil,
      addition:    nil,
      flags:       []
    )
  end

  it 'parses name with degrees' do
    value = subject.normalize('Bc. Peter John Parker')

    expect(value).to eql(
      unprocessed: 'Bc. Peter John Parker',
      value:       'Bc. Peter John Parker',
      prefix:      'Bc.',
      first:       'Peter',
      middle:      'John',
      last:        'Parker',
      suffix:      nil,
      addition:    nil,
      flags:       []
    )
  end

  it 'parses complex name with degrees' do
    value = subject.normalize('doc. JUDr. Robert Fico, CSc.')

    expect(value).to eql(
      unprocessed: 'doc. JUDr. Robert Fico, CSc.',
      value:       'doc. JUDr. Robert Fico, CSc.',
      prefix:      'doc. JUDr.',
      first:       'Robert',
      middle:      nil,
      last:        'Fico',
      suffix:      'CSc.',
      addition:    nil,
      flags:       []
    )
  end
end

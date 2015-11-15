require 'spec_helper'

describe Probe::Mapper do
  let(:mapper) { Probe::Mapper.new }

  describe '#mapper' do
    before :each do
      mapper.define title: -> { title.downcase }
    end

    it 'maps instances by definitions' do
      instance = OpenStruct.new(title: 'Westside')

      result = mapper.map(instance)

      expect(result[:title]).to eql('westside')
    end
  end
end

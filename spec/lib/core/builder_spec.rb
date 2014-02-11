require 'spec_helper'

describe Core::Builder do
  subject { described_class }

  describe '.create_<model>_by' do
    let(:attributes) { { first: 'Peter', last: 'Parker', role: :admin } }

    context 'with single find condition' do
      it 'creates new record' do
        model  = double(:model)
        record = double(:record)

        stub_const('Model', model)

        expect(model).to receive(:find_or_initialize_by).with(first: 'Peter').and_return(record)
        expect(record).to receive(:update_attributes!).with(attributes).and_return(true)

        expect(subject.create_model_by(:first, attributes)).to eql(record)
      end
    end

    context 'with multiple conditions' do
      it 'creates a new record' do
        model  = double(:model)
        record = double(:record)

        stub_const('Model', model)

        expect(model).to receive(:find_or_initialize_by).with(first: 'Peter', last: 'Parker').and_return(record)
        expect(record).to receive(:update_attributes!).with(attributes).and_return(true)

        expect(subject.create_model_by(:first, :last, attributes)).to eql(record)
      end
    end

    context 'when model does not exists' do
      it 'raises an error' do
        expect { subject.create_very_bogus_model_by(name: 'Bogus') }.to raise_error(ArgumentError, 'Cannot find model \'VeryBogusModel\'.')
      end
    end
  end
end

require 'spec_helper'

describe Slido::Questions::Parser do
  subject { described_class }

  it 'parses questions' do
    data = fixture('slido/questions.json').read

    questions = subject.parse(data)

    expect(questions.size).to eql(7)

    question = questions.first

    expect(question.title).to eql('What is the purpose of Life?')
    expect(question.text).to  eql('What is the purpose of Life?')
  end
end

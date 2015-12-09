require 'spec_helper'
require 'shared/slido/questions/parser'

describe Shared::Slido::Questions::Parser do
  subject { described_class }

  it 'parses questions' do
    data = fixture('shared/slido/questions.json').read

    questions = subject.parse(data)

    expect(questions.size).to eql(7)

    question = questions.first

    expect(question.title).to               eql('What is the purpose of Life?')
    expect(question.text).to                eql('What is the purpose of Life?')
    expect(question.slido_event_uuid).to    eql(1257)
    expect(question.slido_question_uuid).to eql(15807)
  end
end

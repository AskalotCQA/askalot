require 'spec_helper'

describe Slido::Wall::Parser do
  subject { described_class }

  it 'parses slido event information' do
    data = fixture('slido/wall.html').read

    event = subject.parse(data)

    expect(event.name).to      eql('Askalot')
    expect(event.starts_at).to eql(Time.new(2014, 2, 8, 1, 0, 0))
    expect(event.ends_at).to   eql(Time.new(2014, 2, 9, 1, 0, 0))
  end
end

require 'spec_helper'

describe Slido::Wall::Parser do
  subject { described_class }

  it 'parses slido event information' do
    data = fixture('slido/wall.html').read

    event = subject.parse(data)

    expect(event.uuid).to        eql(1257)
    expect(event.identifier).to  eql('4w17')
    expect(event.name).to        eql('Askalot')
    expect(event.started_at).to  eql(Time.new(2014, 2, 8, 0, 0, 0))
    expect(event.ended_at).to    eql(Time.new(2014, 2, 9, 0, 0, 0))
    expect(event.url).to         eql('https://www.sli.do/4w17')
  end
end

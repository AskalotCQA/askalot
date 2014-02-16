require 'spec_helper'

describe Slido::Scraper do
  it 'scrapes slido questions with event' do
    builder    = double(:builder)
    finder     = double(:finder)
    downloader = double(:dowloader)
    response   = double(:response, last_effective_url: 'https://www.sli.do/doge/woow')

    category  = double(:category, id: 1, slido_username: 'doge', slido_event_prefix: 'such')
    event     = double(:event, to_h: { uuid: 123, identifier: 'woow', name: 'such event' })
    questions = [
      double(:question, to_h: { title: 'Wow?' })
    ]

    questions_parser = double(:questions_parser)
    wall_parser      = double(:wall_parser)

    expect(downloader).to       receive(:download).with('https://www.sli.do/doge', with_response: true).and_return(response)
    expect(downloader).to       receive(:download).with('https://www.sli.do/doge/woow/questions/load').and_return(:json)
    expect(questions_parser).to receive(:parse).with(:json).and_return(questions)
    expect(downloader).to       receive(:download).with('https://www.sli.do/doge/woow/wall').and_return(:html)
    expect(wall_parser).to      receive(:parse).with(:html).and_return(event)
    expect(finder).to           receive(:find_user_by).with(login: :slido).and_return(double(:author, id: 2))
    expect(builder).to          receive(:create_slido_event_by).with(:uuid, uuid: 123, identifier: 'woow', name: 'such event', category_id: 1).and_return(double.as_null_object)
    expect(builder).to          receive(:create_question_by).with(:slido_question_uuid, title: 'Wow?', category_id: 1, author_id: 2).and_return(double.as_null_object)

    stub_const('Scout::Downloader', downloader)
    stub_const('Slido::Wall::Parser', wall_parser)
    stub_const('Slido::Questions::Parser', questions_parser)
    stub_const('Core::Builder', builder)
    stub_const('Core::Finder', finder)

    Slido::Scraper.run(category)
  end
end

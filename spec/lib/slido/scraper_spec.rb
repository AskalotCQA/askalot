require 'spec_helper'

describe Slido::Scraper do
  it 'scrapes slido questions with event' do
    downloader = double(:dowloader)
    response   = double(:response, last_effective_url: 'https://www.sli.do/doge/woow')

    category  = double(:category, id: 1)
    event     = double(:event, to_h: { uuid: 123, identifier: 'woow' })
    questions = [
      double(:question, to_h: { title: 'Wow?' })
    ]

    questions_parser = double(:questions_parser)
    wall_parser      = double(:wall_parser)
    category_model   = double(:category)
    event_model      = double(:event)
    question_model   = double(:question)

    expect(downloader).to       receive(:download).with('https://www.sli.do/doge', with_response: true).and_return(response)
    expect(downloader).to       receive(:download).with('https://www.sli.do/doge/woow/questions/load').and_return(:json)
    expect(questions_parser).to receive(:parse).with(:json).and_return(questions)
    expect(downloader).to       receive(:download).with('https://www.sli.do/doge/woow/wall').and_return(:html)
    expect(wall_parser).to      receive(:parse).with(:html).and_return(event)
    expect(category_model).to   receive(:find_by).with(slido_username: 'doge').and_return(category)
    expect(event_model).to      receive(:create!).with(uuid: 123, identifier: 'woow')
    expect(question_model).to   receive(:create!).with(category_id: 1, title: 'Wow?')

    stub_const('Scout::Downloader', downloader)
    stub_const('Slido::Wall::Parser', wall_parser)
    stub_const('Slido::Questions::Parser', questions_parser)
    stub_const('Category', category_model)
    stub_const('SlidoEvent', event_model)
    stub_const('Question', question_model)

    Slido::Scraper.run('doge')
  end
end

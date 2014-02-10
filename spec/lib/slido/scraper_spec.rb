require 'spec_helper'

describe Slido::Scraper do
  it 'scrapes slido questions with event' do
<<<<<<< HEAD
    builder    = double(:builder)
    downloader = double(:dowloader)
    response   = double(:response, last_effective_url: 'https://www.sli.do/doge/woow')

    category  = double(:category, id: 1, slido_username: 'doge')
=======
    downloader = double(:dowloader)
    response   = double(:response, last_effective_url: 'https://www.sli.do/doge/woow')

    category  = double(:category, id: 1)
>>>>>>> Add Slido scraper and few utilities into Gemfile
    event     = double(:event, to_h: { uuid: 123, identifier: 'woow' })
    questions = [
      double(:question, to_h: { title: 'Wow?' })
    ]

    questions_parser = double(:questions_parser)
    wall_parser      = double(:wall_parser)
<<<<<<< HEAD
=======
    category_model   = double(:category)
    event_model      = double(:event)
    question_model   = double(:question)
>>>>>>> Add Slido scraper and few utilities into Gemfile

    expect(downloader).to       receive(:download).with('https://www.sli.do/doge', with_response: true).and_return(response)
    expect(downloader).to       receive(:download).with('https://www.sli.do/doge/woow/questions/load').and_return(:json)
    expect(questions_parser).to receive(:parse).with(:json).and_return(questions)
    expect(downloader).to       receive(:download).with('https://www.sli.do/doge/woow/wall').and_return(:html)
    expect(wall_parser).to      receive(:parse).with(:html).and_return(event)
<<<<<<< HEAD
    expect(builder).to          receive(:create_slido_event_by).with(:uuid, uuid: 123, identifier: 'woow', category_id: 1).and_return(double.as_null_object)
    expect(builder).to          receive(:create_question_by).with(:slido_uuid, title: 'Wow?', category_id: 1).and_return(double.as_null_object)
=======
    expect(category_model).to   receive(:find_by).with(slido_username: 'doge').and_return(category)
    expect(event_model).to      receive(:create!).with(uuid: 123, identifier: 'woow')
    expect(question_model).to   receive(:create!).with(category_id: 1, title: 'Wow?')
>>>>>>> Add Slido scraper and few utilities into Gemfile

    stub_const('Scout::Downloader', downloader)
    stub_const('Slido::Wall::Parser', wall_parser)
    stub_const('Slido::Questions::Parser', questions_parser)
<<<<<<< HEAD
    stub_const('Core::Builder', builder)

    Slido::Scraper.run(category)
=======
    stub_const('Category', category_model)
    stub_const('SlidoEvent', event_model)
    stub_const('Question', question_model)

    Slido::Scraper.run('doge')
>>>>>>> Add Slido scraper and few utilities into Gemfile
  end
end

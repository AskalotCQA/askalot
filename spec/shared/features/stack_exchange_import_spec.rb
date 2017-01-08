require 'spec_helper'
require 'shared/stack_exchange'

describe 'Stack Exchange Import', type: :feature do
  it 'imports stack exchange beer dataset' do
    Shared::StackExchange.import_from(fixture('shared/stack_exchange/beer').path)

    question = Shared::Question.find_by(title: 'Do IPAs cause worse hangovers?')

    expect(question.title).to eql('Do IPAs cause worse hangovers?')
    expect(question.text).to eql("I usually drink strong Belgian Ales, particularly Triples, Quads and Trappists, so I'm no stranger to strong beer.  But I've noticed that I get far, far worse hangovers when drinking IPAs.  \n\nIs there anything about IPAs that would make this possible?  The lower quality places like ask.com or Yahoo answers usually say no, that only ABV produces hangovers, though one source did seem to imply that IPAs have special ingredients that make this a possibility. \n\nSo I want to ask the experts here: do IPAs have ingredients that other strong beers lack, that could exacerbate hangovers? \n")
    expect(question.stack_exchange_uuid).to eql(11)
    expect(question.created_at.to_s).to eql(Time.parse('2014-01-21 20:41:10').to_s)
    expect(question.updated_at.to_s).to eql(Time.parse('2014-01-21 20:41:10').to_s)
    expect(question.answers.count).to eql(2)

    answer = question.answers.order(:created_at).first

    expect(answer.text).to eql("I suspect this really boils down to each persons' chemistry.  IPA's don't have any real negative impact on me in terms of hangovers but Budweiser (as a prime example) has a much faster onset of hangover for me and I suffer far worse from it.\n\nThe \"Ice Beers\" that became popular in the early 90's really caused me to have a lot of problems but, again, IPA's of all stripes typically don't bother me at all.\n")
    expect(answer.stack_exchange_uuid).to eql(23)
    expect(answer.votes.count).to eql(1)
    expect(answer.created_at.to_s).to eql(Time.parse('2014-01-21 20:50:43').to_s)

    comments = question.answers.find_by(stack_exchange_uuid: 107).comments

    expect(comments.count).to eql(1)
    expect(comments.first.text).to eql('I had wondered whether the excessive hops in IPAs could cause (worse) hangovers.')
    expect(comments.first.stack_exchange_uuid).to eql(79)

    vote = answer.votes.first

    expect(vote.stack_exchange_uuid).to eql(219)
    expect(vote.created_at.to_s).to eql(Time.parse('2014-01-21 20:51:43').to_s)

    labeling = Shared::Labeling.find_by(stack_exchange_uuid: 65)

    expect(labeling.answer.stack_exchange_uuid).to eql(19)
    expect(labeling.created_at).to eql(labeling.answer.created_at + 1.minute)
    expect(labeling.label.value).to eql(:best)

    favorite = Shared::Favorite.find_by(stack_exchange_uuid: 141)

    expect(favorite.question.stack_exchange_uuid).to eql(63)
    expect(favorite.created_at).to eql(favorite.question.created_at + 1.minute)
    expect(favorite.favorer.stack_exchange_uuid).to eql(7)
  end
end

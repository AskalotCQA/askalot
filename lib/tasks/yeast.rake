require 'yeast'
require_relative '../../app/services/events/dispatcher'

namespace :yeast do
  desc 'Prepare dispatcher'
  task feed: :environment do
    Events::Dispatcher.unsubscribe_all

    # TODO (smolnar) order matters: AF, QF, UF
    Events::Dispatcher.subscribe Yeast::AnswerFeeder
    Events::Dispatcher.subscribe Yeast::QuestionFeeder
    Events::Dispatcher.subscribe Yeast::UserFeeder

    Yeast.run
  end

  desc 'Evaluate detecion'
  task evaluate: :environment do
    Events::Dispatcher.unsubscribe_all
    Events::Dispatcher.subscribe Yeast::EvaluationFeeder

    Yeast.run
  end

  namespace :evaluate do
    desc 'Evaluate with TF-IDF'
    task tf_ifd: :environment do
      Events::Dispatcher.unsubscribe_all
      Events::Dispatcher.subscribe Yeast::EvaluationFeeder

      Yeast::EvaluationFeeder.strategy = ->(question, terms) {
        {
          sort: {
            _script: {
              script: "
              result = doc.score;
              size   = _index.numDocs();

              foreach(term : terms) {
                frequency       = _index['title'][term].tf() + _index['text'][term].tf() + _index['tags'][term].tf();
                total_frequency = _index['title'][term].ttf() + _index['text'][term].ttf() + _index['tags'][term].ttf();

                if (frequency > 0 && total_frequency > 0) {
                  result += frequency * log((size / total_frequency) + 1);
                }
              }

              return result;
              ",
                type: :number,
                order: :desc,
                params: {
                  terms: terms
                }
            }
          }
        }
      }

      Yeast.run
    end

    desc 'Evaluate with TF-IDF and interest'
    task tf_ifd_with_interest: :environment do
      Events::Dispatcher.unsubscribe_all
      Events::Dispatcher.subscribe Yeast::EvaluationFeeder

      Yeast::EvaluationFeeder.strategy = -> (question, terms) {
        tags = question.author.profiles.where(property: :interest).order(:value).limit(10).map { |p| { name: p.targetable.name, value: p.value } }

        {
          sort: {
            _script: {
              script: "
              result = doc.score;
              size   = _index.numDocs();

              foreach(term : terms) {
                frequency       = _index['title'][term].tf() + _index['text'][term].tf() + _index['tags'][term].tf();
                total_frequency = _index['title'][term].ttf() + _index['text'][term].ttf() + _index['tags'][term].ttf();

                if (frequency > 0 && total_frequency > 0) {
                  result += frequency * log((size / total_frequency) + 1);
                }
              }

              foreach(tag : tags) {
                name = tag['name'];

                if (_index['tags'][name].tf() > 0) {
                  result += tag['value'];
                }
              }

              return result;
              ",
                type: :number,
                order: :desc,
                params: {
                  terms: terms,
                  tags: tags
                }
            }
          }
        }
      }

      Yeast.run
    end
  end
end

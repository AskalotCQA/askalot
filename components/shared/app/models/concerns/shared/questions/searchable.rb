module Shared::Questions
  module Searchable
    extend ActiveSupport::Concern

    included do
      include ::Shared::Searchable

      probe.index.name = :"questions_#{Rails.env}"
      probe.index.type = :question

      probe.index.settings = {
        index: {
          number_of_shards: 1,
          number_of_replicas: 0
        },

        # TODO (smolnar) stemming, stopwords
        analysis: {
          analyzer: {
            text: {
              type: :custom,
              tokenizer: :standard,
              filter: [:asciifolding, :lowercase, :trim]
            },

            tags: {
              type: :custom,
              tokenizer: :tag,
              filter: [:asciifolding]
            },

            answers: {
              type: :custom,
              tokenizer: :standard,
              filter: [:asciifolding, :lowercase, :trim]
            },

            comments: {
              type: :custom,
              tokenizer: :standard,
              filter: [:asciifolding, :lowercase, :trim]
            }
          },

          tokenizer: {
            tag: {
              type: :pattern,
              pattern: '-*(\w+)-*',
              group: 0
            }
          },

          filter: {
            stop_en: {
              type: :stop,
              lang: :english
            }
          }
        }
      }

      probe.index.mappings = {
        question: {
          properties: {
            id: {
              type: :integer
            },

            title: {
              type: :multi_field,
              fields: {
                title: {
                  type: :string,
                  analyzer: :text,
                },
                untouched: {
                  type: :string,
                  index: :not_analyzed
                }
              }
            },

            text: {
              type: :multi_field,
              fields: {
                text: {
                  type: :string,
                  analyzer: :text,
                },
                untouched: {
                  type: :string,
                  index: :not_analyzed
                }
              }
            },

            tags: {
              type: :multi_field,
              fields: {
                tags: {
                  type: :string,
                  analyzer: :tags,
                },
                untouched: {
                  type: :string,
                  index: :not_analyzed
                }
              }
            },

            answers: {
              type: :multi_field,
              fields: {
                answers: {
                  type: :string,
                  analyzer: :answers,
                },
                untouched: {
                  type: :string,
                  index: :not_analyzed
                }
              }
            },

            comments: {
              type: :multi_field,
              fileds: {
                comments: {
                  type: :string,
                  analyzer: :comments,
                },
                untouched: {
                  type: :string,
                  index: :not_analyzed
                }
              }
            },

            topics: {
              type: :float
            }
          }
        }
      }

      probe.index.mapper.define(
        id:         ->  { id },
        title:      ->  { title },
        text:       ->  { text },
        tags:       ->  { tags.pluck(:name) },
        answers:    ->  { answers.pluck(:text) },
        comments:    -> { comments.pluck(:text) + answers.map { |answer| answer.comments.pluck(:text) }},
        evaluations: -> { evaluations.pluck(:text) + answers.map { |answer| answer.evaluations.pluck(:text) }},

        topics: -> { profiles.where(source: :LDA).order(:property).pluck(:value) }
      )

      probe.index.create
    end

    module ClassMethods
      def search_by(params)
        search(
          query: {
            query_string: {
              query: probe.sanitizer.sanitize_query("*#{params[:q]}*"),
              default_operator: :and,
              fields: [:title, :text, :tags, :answers, :comments, :evaluations]
            }
          }
        )
      end
    end
  end
end

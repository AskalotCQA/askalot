module Answers
  module Searchable
    extend ActiveSupport::Concern

    included do
      include ::Searchable

      probe.index.name = :"answers_#{Rails.env}"
      probe.index.type = :answer

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
        answer: {
          properties: {
            id: {
              type: :integer
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
            }
          }
        }
      }

      probe.index.mapper.define(
        id: -> { id },
        text: -> { text }
      )

      probe.index.create
    end

    module ClassMethods
      def search_by(params)
        search(
          page: params[:page],
          per_page: params[:per_page],
          query: {
            query_string: {
              query: probe.sanitizer.sanitize_query(params[:q]),
              default_operator: :and,
              fields: [:text]
            }
          }
        )
      end
    end
  end
end

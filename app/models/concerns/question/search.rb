class Question
  module Search
    extend ActiveSupport::Concern

    included do
      include Searchable

      probe.index.name = :"questions_#{Rails.env}"
      probe.index.type = :question

      probe.index.settings = {
        index: {
          number_of_shards: 1,
          number_of_replicas: 0
        },

        analysis: {
          analyzer: {
            text: {
              type: :custom,
              tokenizer: :keyword,
              filter: [:asciifolding, :lowercase, :trim]
            },

            tags: {
              type: :custom,
              tokenizer: :tag,
              filter: [:asciifolding]
            }
          },

          tokenizer: {
            tag: {
              type: :pattern,
              pattern: '-*(\w+)-*',
              group: 0
            }
          }
        }
      }

      probe.index.mappings = {
        question: {
          properties: {
            doc: {
              properties: {
                id: {
                  type: :integer
                },
                title: {
                  type: :string,
                  analyzer: :text
                },
                text: {
                  type: :string,
                  analyzer: :text
                },
                tags: {
                  type: :string,
                  analyzer: :tags
                }
              }
            }

          }
        }
      }

      probe.index.mapper.define(
        id:    -> { id },
        title: -> { title },
        text:  -> { text },
        tags:  -> { tags.map(&:name) }
      )
    end
  end
end

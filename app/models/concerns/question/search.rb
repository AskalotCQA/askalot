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

        # TODO (smolnar) stemming, stopwords
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
                  type: :multi_field,
                  fields: {
                    title: {
                      type: :string,
                      analyzer: :text,
                      store: :yes
                    },
                    untouched: {
                      include_in_all: false,
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
                      store: :yes
                    },
                    untouched: {
                      include_in_all: false,
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
                      store: :yes
                    },
                    untouched: {
                      include_in_all: false,
                      type: :string,
                      index: :not_analyzed
                    }
                  }
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

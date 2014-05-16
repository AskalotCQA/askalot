module Categories
  module Searchable
    extend ActiveSupport::Concern

    included do
      include ::Searchable

      probe.index.name = :"category_#{Rails.env}"
      probe.index.type = :category

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
        category: {
          properties: {
            id: {
              type: :integer
            },
            name: {
              type: :multi_field,
              fields: {
                name: {
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
        id:    -> { id },
        name: -> { name }
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
              fields: [:name]
            }
          }
        )
      end
    end
  end
end

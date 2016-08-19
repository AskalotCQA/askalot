module Shared::Categories
  module Searchable
    extend ActiveSupport::Concern

    included do
      include ::Shared::Searchable

      probe.index.name = :"categories_#{Rails.env}"
      probe.index.type = :category

      probe.index.settings = {
        index: {
          number_of_shards: 1,
          number_of_replicas: 0
        },

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
            },

            context: {
                type: :integer
            }
          }
        }
      }

      probe.index.mapper.define(
        id:   -> { id },
        name: -> { full_public_name },
        context: -> { related_contexts.pluck(:id) }
      )

      probe.index.create
    end

    module ClassMethods
      def search_by(params, context = Shared::Context::Manager.current_context_id)
        search(
          query: {
            query_string: {
              query: probe.sanitizer.sanitize_query("*#{params[:q]}*"),
              default_operator: :and,
              fields: [:name]
            }
          },
          filter: {
            term: {
              context: context
            }
          },
          sort: {
            :'name.untouched' => :asc
          }
        )
      end
    end
  end
end

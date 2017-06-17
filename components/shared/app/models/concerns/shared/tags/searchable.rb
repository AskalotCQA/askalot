module Shared::Tags
  module Searchable
    extend ActiveSupport::Concern

    included do
      include ::Shared::Searchable

      probe.index.name = :"tags_#{Rails.env}"
      probe.index.type = :tag

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
        tag: {
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

            created_at: {
              type: :date
            },

            count: {
              type: :integer
            },

            context: {
              type: :integer
            }
          }
        }
      }

      probe.index.mapper.define(
        id:         -> { id },
        name:       -> { name },
        created_at: -> { created_at },
        count:      -> { taggings.count },
        context:    -> { related_contexts.pluck(:id) }
      )

      probe.index.create
    end

    module ClassMethods
      def search_by(params, context = Shared::Context::Manager.current_context_id)
        search(
          query: {
            query_string: {
              query: probe.sanitizer.sanitize_query("*#{params[:q]}*"),
              analyzer: :text,
              analyze_wildcard: true,
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
            :'count' => :desc
          }
        )
      end
    end
  end
end

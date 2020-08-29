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
              type: :text,
              fields: {
                name: {
                  type: :text,
                  analyzer: :text,
                },
                untouched: {
                  type: :keyword
                }
              }
            },

            description: {
                type: :text,
                fields: {
                    description: {
                        type: :text,
                        analyzer: :text,
                    },
                    untouched: {
                        type: :keyword
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
        description: -> { description },
        context: -> { related_contexts.pluck(:id) }
      )

      probe.index.create
    end

    module ClassMethods
      def search_by(params, context = Shared::Context::Manager.current_context_id)
        search(
          query: {
            bool: {
              must: {
                query_string: {
                  query: probe.sanitizer.sanitize_query("*#{params[:q]}*"),
                  analyzer: :text,
                  analyze_wildcard: true,
                  default_operator: :and,
                  fields: [:name, :description]
                }
              },
              filter: {
                term: {
                  context: context
                }
              },
            },
          },
          sort: {
            :'name.untouched' => :asc
          },
          page: params[:page].to_i
        )
      end
    end
  end
end

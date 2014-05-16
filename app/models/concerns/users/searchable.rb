module Users
  module Searchable
    extend ActiveSupport::Concern

    included do
      include ::Searchable

      probe.index.name = :"user_#{Rails.env}"
      probe.index.type = :user

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
        user: {
          properties: {
            id: {
              type: :integer
            },
            nick: {
              type: :multi_field,
              fields: {
                nick: {
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
            }
          }
        }
      }

      probe.index.mapper.define(
        id:    -> { id },
        nick: -> { name },
        created_at: -> { created_at },
      )

      probe.index.create
    end

    module ClassMethods
      def search_by(params)
        query = {
          query: {
            query_string: {
              query: probe.sanitizer.sanitize_query("*#{params[:q]}*"),
              default_operator: :and,
              fields: [:name]
            }
          }
        }

        if params[:recent]
          query.deep_merge!(
            query: {
              filtered: {
                filter: {
                  range: {
                    created_at: {
                      from: 1.month.ago,
                      to: Time.now
                    }
                  }
                }
              },

            },
            sort: {
              created_at: { order: :desc }
            }
          )
        end

        search(query)
      end
    end
  end
end

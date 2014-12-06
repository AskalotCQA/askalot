module StackExchange
  class Mapper
    def self.reload!
      @tags      = nil
      @questions = nil
      @users     = nil
    end

    def self.tags
      @tags ||= Tag.all.inject(Hash.new) do |hash, tag|
        hash[tag.name] = {
           id: tag.id
        }

        hash
      end
    end

    def self.questions
      @questions ||= Question.connection.execute('SELECT id, stack_exchange_uuid, created_at FROM questions').to_a.inject(Hash.new) do |hash, attributes|
        hash[attributes['stack_exchange_uuid'].to_s] = {
          id: attributes['id'],
          created_at: Time.parse(attributes['created_at'] + ' UTC')
        }

        hash
      end
    end

    def self.users
      @users ||= User.connection.execute('SELECT id, stack_exchange_uuid FROM users').to_a.inject(Hash.new) do |hash, attributes|
        hash[attributes['stack_exchange_uuid'].to_s] = {
          id: attributes['id']
        }

        hash
      end
    end

    def self.answers
      @answers ||= Answer.connection.execute('SELECT id, stack_exchange_uuid, created_at FROM answers').to_a.inject(Hash.new) do |hash, attributes|
        hash[attributes['stack_exchange_uuid'].to_s] = {
          id: attributes['id'],
          created_at: Time.zone.parse(attributes['created_at'] + ' UTC')
        }

        hash
      end
    end
  end
end

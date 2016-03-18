require 'shared/core/normalizer/name'

module Shared::Stuba
  class User
    def initialize(data)
      @data = data
    end

    def uid
      @uid ||= @data[:uisid].first
    end

    def login
      @login ||= @data[:uid].first
    end

    def email
      @email ||= @data[:mail].find { |mail| mail =~ /@stuba.sk\z/ }
    end

    def name
      normalized_name[:value]
    end

    def first
      normalized_name[:first]
    end

    def middle
      normalized_name[:middle]
    end

    def last
      normalized_name[:last]
    end

    def role
      @role ||= ((value = @data[:employeetype].first.to_sym) == :staff ? :teacher : :student)
    end

    def alumni?
      @alumni ||= @data[:accountstatus].exclude? 'uis:active'
    end

    def to_params
      {
        ais_uid: uid,
        ais_login: login,
        login: login,
        name: name,
        email: email,
        first: first,
        middle: middle,
        last: last,
        role: role,
        alumni: alumni?
      }
    end

    private

    def normalized_name
      @normalized_name ||= Shared::Core::Normalizer::Name.normalize(@data[:cn].first)
    end
  end
end

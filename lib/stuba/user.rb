module Stuba
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
      @name ||= @data[:cn].first
    end

    def first
      @first ||= @data[:givenname].first
    end

    def last
      @last ||= @data[:sn].first
    end

    def role
      @role ||= @data[:employeetype].first.to_sym
    end

    def to_params
      {
        ais_uid: uid,
        ais_login: login,
        login: login,
        email: email,
        name: name,
        first: first,
        last: last,
        role: role
      }
    end
  end
end

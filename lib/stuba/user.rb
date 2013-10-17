module Stuba
  class User
    def initialize(data)
      @data = data
    end

    def login
      @login ||= @data[:uid].first
    end

    def uid
      @uid ||= @data[:uisid].first
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

    def middle
      # TODO (smolnar) find example of AIS middle name
    end

    def last
      @last ||= @data[:sn].first
    end

    def to_params
      {
        login: login,
        email: email,
        ais_uid: uid,
        ais_login: login,
        name: name,
        first: first,
        middle: middle,
        last: last
      }
    end
  end
end

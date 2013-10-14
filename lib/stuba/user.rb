module Stuba
  class User
    def initialize(data)
      @data = data
    end

    def login
      @data[:uid].first
    end

    def email
      @data[:mail].find { |mail| mail =~ /@stuba.sk\z/ }
    end
  end
end

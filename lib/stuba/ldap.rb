module Stuba
  class LDAP
    def self.build(options)
      Net::LDAP.new options
    end

    def self.build_filter(type, left, right)
      fail "#{type} is not a valid filter" unless Net::LDAP::Filter.respond_to? type

      Net::LDAP::Filter.send type, left, right
    end
  end
end

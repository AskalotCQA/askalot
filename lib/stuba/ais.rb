module Stuba
  class Ais
    def self.authenticate(username, password)
      request = Net::Ldap.new({
        host: 'ldap.stuba.sk',
        port: 389,
        auth: {
          method: :simple,
          username: "uid=#{username},ou=People,dc=stuba,dc=sk",
        password: password
        }
      })

      treebase = 'dc=stuba, dc=sk'
      filter   = Net::LDAP::Filter.eq('uid', username)

      entries = request.search(base: treebase, filter: filter, return_result: true)

      Stuba::User.new(entries.first) if entries.any?
    end
  end
end

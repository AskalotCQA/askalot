module Stuba
  class Ais
    def self.authenticate(username, password)
      request = Stuba::LDAP.build({
        host: 'ldap.stuba.sk',
        port: 389,
        auth: {
          method: :simple,
          username: "uid=#{username},ou=People,dc=stuba,dc=sk",
        password: password
        }
      })

      treebase = 'dc=stuba, dc=sk'
      filter   = Stuba::LDAP.build_filter(:eq, 'uid', username)

      entries = request.search(base: treebase, filter: filter, return_result: true)

      Stuba::User.new(entries.first) if entries.present?
    end
  end
end

require 'timeout'

module Stuba
  class AIS
    def self.authenticate(username, password, options = {})
      request = Stuba::LDAP.build({
        host: 'ldap.stuba.sk',
        port: 389,
        auth: {
          method: :simple,
          username: "uid=#{username},ou=People,dc=stuba,dc=sk",
        password: password
        }
      })

      treebase = 'dc=stuba,dc=sk'
      filter   = Stuba::LDAP.build_filter :eq, 'uid', username

      begin
        Timeout.timeout(options[:timeout] || 3) do
          # TODO (smolna) resolve exception
          begin
            entries = request.search base: treebase, filter: filter, return_result: true rescue nil
          end

          Stuba::User.new(entries.first) if entries.present?
        end
      rescue Timeout::Error
      end
    end
  end
end

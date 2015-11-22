require 'timeout'
require 'shared/stuba/ldap'
require 'shared/stuba/user'

module Shared::Stuba
  module AIS
    extend self

    def authenticate(username, password, options = {})
      request = Shared::Stuba::LDAP.build(
        host: 'ldap.stuba.sk',
        port: 636,
        base: 'ou=People,dc=stuba,dc=sk',
        encryption: :simple_tls,
        auth: {
          method: :simple,
          username: "uid=#{username},ou=People,dc=stuba,dc=sk",
          password: password
        }
      )

      treebase = 'dc=stuba,dc=sk'
      filter   = Shared::Stuba::LDAP.build_filter :eq, 'uid', username

      begin
        Timeout.timeout(options[:timeout] || 3) do
          # TODO (smolnar) resolve exception
          begin
            entries = request.search base: treebase, filter: filter, return_result: true rescue nil

            Shared::Stuba::User.new(entries.first) if entries.present?
          end
        end
      rescue Timeout::Error
      end
    end

    def alumni?(username, options = {})
      request = Shared::Stuba::LDAP.build(
        host: 'ldap.stuba.sk',
        port: 636,
        base: 'ou=People,dc=stuba,dc=sk',
        encryption: :simple_tls
      )

      treebase = 'dc=stuba,dc=sk'
      filter = Shared::Stuba::LDAP.build_filter :eq, 'uid', username

      begin
        Timeout.timeout(options[:timeout] || 3) do
          begin
            entries = request.search base: treebase, filter: filter, return_result: true rescue nil
            user = Shared::Stuba::User.new(entries.first) if entries.present?

            return user.alumni? if entries.present?
            false
          end
        end
      rescue Timeout::Error
        nil
      end
    end
  end
end

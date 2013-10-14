require 'spec_helper'

describe Stuba::Ais do
  describe '.authenticate' do
    it 'gains credentials for a user' do
      ldap    = double(:ldap)
      request = double(:request)

      options = {
        host: 'ldap.stuba.sk',
        port: 389,
        auth: {
          method: :simple,
          username: 'uid=xuser1,ou=People,dc=stuba,dc=sk',
          password: 'password'
        }
      }

      expect(ldap).to receive(:build).with(options).and_return(request)
      expect(ldap).to receive(:build_filter).with(:eq, 'uid', 'xuser1').and_return('filter')

      query = {
        base: 'dc=stuba, dc=sk',
        filter: 'filter',
        return_result: true
      }

      expect(request).to receive(:search).with(query).and_return([{ uid: ['xuser1'] }])

      stub_const('Stuba::LDAP', ldap)

      user = Stuba::Ais.authenticate('xuser1', 'password')

      expect(user.login).to eql('xuser1')
    end
  end
end

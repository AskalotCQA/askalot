require 'spec_helper'

describe Stuba::Ais do
  describe '.authenticate' do
    it 'should gain credentials for a user' do
      ldap    = double(:ldap)
      request = double(:request)

      ldap.should_receive(:new).with({
        host: 'ldap.stuba.sk',
        port: 389,
        auth: {
          method: :simple,
          username: 'uid=username,ou=People,dc=stuba,dc=sk',
          password: 'password'
        }
      }).and_return(request)

      request.should_receive(:search).with({
        base: 'dc=stuba, dc=sk',
        filter: Net::LDAP::Filter.eq('uid', 'username'),
        return_result: true
      }).and_return([{ uid: ['username'] }])

      stub_const('Net::Ldap', ldap)

      user = Stuba::Ais.authenticate 'username', 'password'

      user.login.should eql('username')
    end
  end
end

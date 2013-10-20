require 'spec_helper'

describe Stuba::AIS do
  describe '.authenticate' do
    let(:ldap) { double(:ldap) }
    let(:request) { double(:request) }
    let(:options) do
      {
        host: 'ldap.stuba.sk',
        port: 389,
        auth: {
          method: :simple,
          username: 'uid=xuser1,ou=People,dc=stuba,dc=sk',
          password: 'password'
        }
      }
    end

    let(:query) do  
      {
        base: 'dc=stuba,dc=sk',
        filter: 'filter',
        return_result: true
      }
    end

    before :each do
      stub_const('Stuba::LDAP', ldap)
    end

    context 'when service is available' do
      it 'gains credentials for a user' do
        expect(ldap).to receive(:build).with(options).and_return(request)
        expect(ldap).to receive(:build_filter).with(:eq, 'uid', 'xuser1').and_return('filter')

        expect(request).to receive(:search).with(query).and_return([{ uid: ['xuser1'] }])

        user = Stuba::AIS.authenticate('xuser1', 'password')

        expect(user.login).to eql('xuser1')
      end
    end

    context 'when service is not available' do
      it 'rejects credentials for a user' do
        expect(ldap).to receive(:build).with(options).and_return(request)
        expect(ldap).to receive(:build_filter).with(:eq, 'uid', 'xuser1').and_return('filter')

        expect(request).to receive(:search).with(query) do
          sleep 300
        end

        user = Stuba::AIS.authenticate('xuser1', 'password')

        expect(user).to be_nil
      end
    end
  end
end

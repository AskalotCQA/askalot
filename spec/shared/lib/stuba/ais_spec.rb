require 'spec_helper'
require 'shared/stuba/ais'

describe Shared::Stuba::AIS do
  describe '.authenticate' do
    let(:ldap) { double(:ldap) }
    let(:request) { double(:request) }
    let(:options) do
      {
        host: 'ldap.stuba.sk',
        port: 636,
        base: 'ou=People,dc=stuba,dc=sk',
        encryption: :simple_tls,
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
      stub_const('Shared::Stuba::LDAP', ldap)
    end

    context 'when service is available' do
      it 'gains credentials for a user' do
        expect(ldap).to receive(:build).with(options).and_return(request)
        expect(ldap).to receive(:build_filter).with(:eq, 'uid', 'xuser1').and_return('filter')

        expect(request).to receive(:search).with(query).and_return([{ uid: ['xuser1'], accountstatus: ['fiit_student'] }])

        user = Shared::Stuba::AIS.authenticate('xuser1', 'password')

        expect(user.login).to eql('xuser1')
      end
    end

    context 'when service is not available' do
      it 'rejects credentials for a user' do
        expect(ldap).to receive(:build).with(options).and_return(request)
        expect(ldap).to receive(:build_filter).with(:eq, 'uid', 'xuser1').and_return('filter')

        expect(request).to receive(:search).with(query) do
          sleep 10
        end

        user = Shared::Stuba::AIS.authenticate('xuser1', 'password', timeout: 0.1)

        expect(user).to be_nil
      end
    end
  end

  describe '.alumni' do
    let(:ldap) { double(:ldap) }
    let(:request) { double(:request) }
    let(:options) do
      {
        host: 'ldap.stuba.sk',
        port: 636,
        base: 'ou=People,dc=stuba,dc=sk',
        encryption: :simple_tls
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
      stub_const('Shared::Stuba::LDAP', ldap)
    end

    context 'when service is available' do
      it 'identifies active user' do
        expect(ldap).to receive(:build).with(options).and_return(request)
        expect(ldap).to receive(:build_filter).with(:eq, 'uid', 'xuser1').and_return('filter')

        expect(request).to receive(:search).with(query).and_return([{ uid: ['xuser1'], accountstatus: ['uis:active'] }])

        alumni = Shared::Stuba::AIS.alumni?('xuser1')

        expect(alumni).to eql(false)
      end

      it 'identifies alumni user' do
        expect(ldap).to receive(:build).with(options).and_return(request)
        expect(ldap).to receive(:build_filter).with(:eq, 'uid', 'xuser1').and_return('filter')

        expect(request).to receive(:search).with(query).and_return([{ uid: ['xuser1'], accountstatus: ['uis:pending,neznamo'] }])

        alumni = Shared::Stuba::AIS.alumni?('xuser1')

        expect(alumni).to eql(true)
      end
    end

    context 'when service is not available' do
      it 'skips user' do
        expect(ldap).to receive(:build).with(options).and_return(request)
        expect(ldap).to receive(:build_filter).with(:eq, 'uid', 'xuser1').and_return('filter')

        expect(request).to receive(:search).with(query) do
          sleep 10
        end

        alumni = Shared::Stuba::AIS.alumni?('xuser1', timeout: 0.1)

        expect(alumni).to be_nil
      end
    end
  end
end

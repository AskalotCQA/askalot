require 'spec_helper'

describe Users::Authentication do
  subject { Users::Authentication.new(service, params) }

  let(:params) { { login: 'user', password: 'password' } }
  let(:service) { double(:service) }
  let(:service_user) { double(:service_user) }

  before :each do
  end

  describe '#authorized?' do
    it 'validates user authorization' do
      expect(service).to receive(:authenticate).with('user', 'password').and_return(service_user)

      expect(subject).to be_authorized
    end
  end

  describe '#authenticate!' do
    let(:factory) { double(:factory) }
    let(:instance) { double(:instance) }

    context 'with valid credentials' do
      it 'authenticates user from service' do
        subject.factory = factory

        attributes = {
          login: 'user',
          email: 'example@gmail.com',
          ais_uid: '1234',
          ais_login: 'user'
        }

        expect(service).to receive(:authenticate).with('user', 'password').and_return(service_user)
        expect(factory).to receive(:find_by).with(login: 'user')
        expect(factory).to receive(:create_without_confirmation!).with(attributes)
        expect(service_user).to receive(:to_params).and_return(attributes)

        subject.authenticate!
      end
    end

    context 'with invalid credentials' do
      it 'raises an exception' do
        subject.factory = factory

        attributes = {
          login: 'user',
          email: 'example@gmail.com',
          ais_uid: '1234',
          ais_login: 'user'
        }

        expect(service).to receive(:authenticate).with('user', 'password').and_return(nil)

        expect { subject.authenticate! }.to raise_error RuntimeError, /Unauthorized access/
      end
    end
  end
end

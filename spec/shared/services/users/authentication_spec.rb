require 'spec_helper'

describe Shared::Users::Authentication do
  subject { Shared::Users::Authentication.new(service, params) }

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
        user = double(:user)

        allow(factory).to receive(:where).and_return([nil])

        subject.factory = factory

        attributes = {
          login: 'user',
          email: 'example@gmail.com',
          ais_uid: '1234',
          ais_login: 'user',
          role: :student
        }

        expect(service).to receive(:authenticate).with('user', 'password').and_return(service_user)
        expect(factory).to receive(:where).with('lower(login) = ?', 'user')
        expect(factory).to receive(:create_without_confirmation!).with(attributes).and_return(user)
        expect(user).to receive(:update_attributes!).with(attributes.except(:email, :role)).and_return(true)
        expect(service_user).to receive(:to_params).and_return(attributes).twice

        subject.authenticate!
      end
    end

    context 'with invalid credentials' do
      it 'raises an exception' do
        subject.factory = factory

        expect(service).to receive(:authenticate).with('user', 'password').and_return(nil)

        expect { subject.authenticate! }.to raise_error RuntimeError, /Unauthorized access/
      end
    end
  end
end

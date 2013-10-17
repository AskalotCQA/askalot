require 'spec_helper'

describe Users::Authentication do
  subject { Users::Authentication.new(service, params) }

  let(:params) { { login: 'user', password: 'password' } }
  let(:service) { double(:service) }
  let(:service_user) { double(:service_user) }

  before :each do
    expect(service).to receive(:authenticate).with('user', 'password').and_return(service_user)
  end

  describe '#authorized?' do
    it 'validates user authorization' do
      expect(subject).to be_authorized
    end
  end

  describe '#authenticate!' do
    let(:factory) { double(:factory) }
    let(:instance) { double(:instance) }

    it 'authenticates user from service' do
      subject.factory = factory

      attributes = {
        login: 'user',
        email: 'example@gmail.com',
        ais_uid: '1234',
        ais_login: 'user'
      }

      expect(factory).to receive(:find_by).with(login: 'user')
      expect(factory).to receive(:create_without_confirmation!).with(attributes)
      expect(service_user).to receive(:to_params).and_return(attributes)

      subject.authenticate!
    end
  end
end

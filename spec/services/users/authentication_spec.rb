require 'spec_helper'

describe Users::Authentication do
  describe '#valid?' do
    it 'validates user authorization' do
      params  = { login: 'user', password: 'password' }
      service = double(:service)
      session = double(:session)

      authorization = Users::Authentication.new(service, session, params)

      expect(service).to receive(:authenticate).with('user', 'password').and_return(double.as_null_object)

      expect(authorization).to be_valid
    end
  end

  describe '#create_user!' do
    it 'creates user with session' do
    end
  end
end

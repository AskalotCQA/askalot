require 'spec_helper'

describe User do
  let(:user) { create :user }

  it 'requires login' do
    user = build :user, login: ''

    expect(user).not_to be_valid

    user = build :user, login: 'tra-lala'

    expect(user).not_to be_valid
  end

  context 'with AIS credentials' do
    it 'does not require password' do
      user = build :user, :with_ais, password: nil, password_confirmation: nil

      expect(user.encrypted_password).to be_empty
      expect(user).to be_valid
    end
  end

  describe '.create_without_confirmation!' do
    it 'creates user without confirmation' do
      params = { login: 'user', email: 'email@example.com', password: 'password' }

      user = User.create_without_confirmation!(params)

      expect(user.login).to eql('user')
      expect(user.email).to eql('email@example.com')
      expect(user.encrypted_password).not_to be_nil
      expect(user).to be_confirmed
    end
  end

  describe '.find_first_by_auth_conditions' do
    context 'with login' do
      it 'finds user by login' do
        other = User.find_first_by_auth_conditions(login: user.login)

        expect(other).to eql(user)

        other = User.find_first_by_auth_conditions(login: user.login.upcase)

        expect(other).to eql(user)
      end
    end

    context 'with email' do
      it 'finds user by email' do
        other = User.find_first_by_auth_conditions(login: user.email)

        expect(other).to eql(user)
      end
    end
  end
end

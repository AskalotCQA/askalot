require 'spec_helper'

describe User do
  let(:user) { create :user }

  it 'requires login' do
    user = build :user, login: ''
    expect(user).not_to be_valid

    user = build :user, login: 'tra-lala'
    expect(user).not_to be_valid

    user = build :user, login: 'userlogin'
    expect(user).to be_valid
  end

  it 'requires nick' do
    user = build :user, nick: ''
    expect(user).not_to be_valid

    user = build :user, nick: 'bad-nick?'
    expect(user).not_to be_valid

    user = build :user, nick: 'nickName123'
    expect(user).to be_valid
  end

  it 'requires correct email' do
    user = build :user, email: 'mail.mailer.com'
    expect(user).not_to be_valid

    user = build :user, gravatar_email: 'gravatar.mailer.com'
    expect(user).not_to be_valid

    user = build :user, email: 'mail@mailer.com'
    expect(user).to be_valid

    user = build :user, gravatar_email: 'gravatar@mailer.com'
    expect(user).to be_valid
  end

  it 'requires correct name' do
    user = build :user, first: '12First'
    expect(user).not_to be_valid

    user = build :user, last: '21Last'
    expect(user).not_to be_valid

    user = build :user, first: 'First'
    expect(user).to be_valid

    user = build :user, last: 'Last'
    expect(user).to be_valid

    user = build :user, first: 'Peťo', last: 'Šťastný'
    expect(user).to be_valid
  end

  it 'requires correct social links' do
    user = build :user, facebook: 'http://www.facebook.com'
    expect(user).not_to be_valid

    user = build :user, twitter: 'http://twitter.com'
    expect(user).not_to be_valid

    user = build :user, linkedin: 'http://www.linkedin.com/in/'
    expect(user).not_to be_valid

    user = build :user, facebook: 'http://www.facebook.com/username'
    expect(user).to be_valid

    user = build :user, twitter: 'http://twitter.com/username'
    expect(user).to be_valid

    user = build :user, linkedin: 'http://www.linkedin.com/in/username'
    expect(user).to be_valid
  end

  context 'when login is set' do
    it 'requires nick' do
      user = build :user, login: 'peter'

      expect(user).to      be_valid
      expect(user.nick).to eql('peter')
    end
  end

  context 'when login is not set' do
    it 'does not require nick' do
      user = build :user, login: nil

      expect(user).not_to        be_valid
      expect(user.errors).to     include(:login)
      expect(user.errors).not_to include(:nick)
    end
  end

  context 'with AIS credentials' do
    it 'does not require password' do
      user = build :user, :as_ais

      expect(user).to be_valid
      expect(user.encrypted_password).to be_empty
    end
  end

  describe 'Abilities' do
    let(:ability) { Ability.new(user) }

    context 'with AIS credentials' do
      let(:user) { build :user, :as_ais }

      it 'disallows changing of first name' do
        expect(ability).not_to be_able_to(:change_name, user)
      end

      it 'disallows changing of last name' do
        expect(ability).not_to be_able_to(:change_name, user)
      end

      it 'disallows changing of password' do
        expect(ability).not_to be_able_to(:change_password, user)
      end
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

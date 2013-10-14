require 'spec_helper'

describe User do
  let(:user) { create :user }

  it 'requires login' do
    user = build :user, login: ''

    expect(user).not_to be_valid

    user = build :user, login: 'tra-lala'

    expect(user).not_to be_valid
  end

  describe '.find_first_by_auth_conditions' do
    context 'when providing login' do
      it 'finds user by login' do
        other = User.find_first_by_auth_conditions(login: user.login)

        expect(other).to eql(user)

        other = User.find_first_by_auth_conditions(login: user.login.upcase)

        expect(other).to eql(user)
      end
    end

    context 'when providing email' do
      it 'finds user by email' do
        other = User.find_first_by_auth_conditions(login: user.email)

        expect(other).to eql(user)
      end
    end
  end
end

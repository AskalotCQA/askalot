require 'spec_helper'

describe User do
  let(:user) { create :user }

  it 'should require login' do
    user = build :user, login: ''

    user.should_not be_valid

    user = build :user, login: 'tra-lala'

    user.should_not be_valid
  end

  describe '.find_first_by_auth_conditions' do
    context 'when providing login' do
      it 'should find user' do
        other = User.find_first_by_auth_conditions(login: user.login)

        other.should eql(user)

        other = User.find_first_by_auth_conditions(login: user.login.upcase)

        other.should eql(user)
      end
    end

    context 'when providing email' do
      it 'should find user' do
        other = User.find_first_by_auth_conditions(login: user.email)

        other.should eql(user)
      end
    end
  end
end

require 'spec_helper'

describe Shared::User, type: :model do
  let(:user) { create :user }

  it 'does not show user\'s email by default' do
    user = Mooc::User.create({ login: 'johndoe', email: 'john@doe.com' })

    expect(user).to be_valid
    expect(user.show_email).to be_falsey
  end
end

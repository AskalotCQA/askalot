require 'spec_helper'

describe Shared::UsersController, type: :controller do
  describe 'PATCH update' do
    routes { Shared::Engine.routes }

    context 'with AIS user' do
      let(:user) { create :user, :as_ais, first: 'Ali', last: 'G', password: 'password' }

      before :each do
        sign_in(user)
      end

      it 'disallows changing of first and last name' do
        patch :update, context_uuid: Shared::Context::Manager.context_category.uuid, user: { nick: 'xpeter', first: 'Peter', last: 'Pan' }

        user.reload

        expect(user.nick).to  eql('xpeter')
        expect(user.first).to eql('Ali')
        expect(user.last).to  eql('G')
      end

      it 'disallows changing of password' do
        password           = SecureRandom.hex
        encrypted_password = user.encrypted_password

        patch :update, user: { password: password, password_confirmation: password }

        user.reload

        expect(user.encrypted_password).to eql(encrypted_password)
      end
    end
  end
end

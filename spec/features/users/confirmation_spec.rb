require 'spec_helper'

describe 'User Confirmation' do
  let(:user) { create :user, :unconfirmed }

  it 'should confirm user registration' do
    visit root_path

    click_link 'Prihlásiť'
    click_link 'Nepotvrdená registrácia?'

    fill_in 'user_email', with: user.email
    click_button 'Poslať inštrukcie pre potvrdenie registrácie'

    last_email.to.should eql([user.email])
    last_email.subject.should match('Potvrdenie registrácie')

    user.reload

    visit user_confirmation_path(confirmation_token: user.confirmation_token)

    page.should have_content('Váš účet bol úspešne overený. Teraz ste prihlásený.')
  end
end

require 'spec_helper'

describe 'Account Confirmation', type: :feature do
  let(:user) { create :user, :unconfirmed }

  it 'confirms user registration' do
    visit shared.root_path

    click_link 'Prihlásiť'
    click_link 'Nepotvrdená registrácia?'

    fill_in 'user_email', with: user.email
    click_button 'Poslať inštrukcie pre potvrdenie registrácie'

    email = emails.first

    expect(email.to).to eql([user.email])
    expect(email.subject).to eql('Potvrdenie registrácie')

    user.reload

    visit shared.user_confirmation_path(confirmation_token: user.confirmation_token)

    expect(page).to have_content('Váš účet bol úspešne overený. Teraz ste prihlásený.')
  end
end

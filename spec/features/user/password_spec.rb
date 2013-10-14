require 'spec_helper'

describe 'User Password' do
  let(:user) { create :user }

  it 'allows user to change password' do
    visit root_url

    click_link 'Prihlásiť'
    click_link 'Zabudli ste heslo?'

    fill_in 'user_email', with: user.email
    click_button 'Poslať inštrukcie pre obnovenie hesla'

    user.reload

    visit edit_user_password_path(reset_password_token: user.reset_password_token)

    fill_in 'user_password', with: 'new_password'
    fill_in 'user_password_confirmation', with: 'new_password'

    click_button 'Zmeniť'

    expect(page).to have_content('Vaše heslo bolo úspešne zmenené. Teraz ste prihlásený.')
  end
end

require 'spec_helper'

describe 'User Confirmation' do
  let(:user) { create :user, :unconfirmed }

  it 'should send confirmation email to user' do
    visit root_url

    click_link 'Prihlásiť'
    click_link 'Nepotvrdená registrácia?'

    fill_in 'user_email', with: user.email
    click_button 'Poslať inštrukcie pre potvrdenie registrácie'

    last_email.to.should eql([user.email])
    last_email.subject.should match('Potvrdenie registrácie')
  end
end

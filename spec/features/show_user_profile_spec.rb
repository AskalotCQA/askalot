require 'spec_helper'

describe 'Show user profile' do
  let!(:author) { create :user }
  let!(:user)   { create :user }
  let!(:question) { create :question, :anonymous, author: author }

  context 'when logged in as anonymous question author' do
    before :each do
      login_as author
    end

    it 'shows anonymous question' do
      visit user_path(author.nick)

      list = all('#questions > ol > li')

      expect(list).to have(1).items
    end
  end

  context 'when not logged in as anonymous question author' do
    before :each do
      login_as user
    end

    it 'does not show anonymous question' do
      visit user_path(author.nick)

      list = all('#questions > ol > li')

      expect(list).to have(0).items
    end
  end
end

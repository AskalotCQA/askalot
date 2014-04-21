require 'spec_helper'

describe 'View user profile' do
  let!(:author) { create :user }
  let!(:user)   { create :user }
  let!(:question) { create :question, :anonymous, author: author }

  context 'logged in as anonymous question author' do
    before :each do
      login_as author
    end

    it 'can see own anonymous question' do
      visit user_path(author.nick)

      list = all('#questions > ol > li')

      expect(list).to have(1).items
    end
  end

  context 'logged in as not anonymous question author' do
    before :each do
      login_as user
    end

    it 'can not see other user anonymous question' do
      visit user_path(author.nick)

      list = all('#questions > ol > li')

      expect(list).to have(0).items
    end
  end
end

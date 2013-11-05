require 'spec_helper'

describe 'Show questions' do
  let(:question) {create :question}

    it 'shows questions' do
      visit root_path

      click_link 'Show questions'

      expect(page).to have_content(question.title)
    end

  describe "index" do
    let(:question) { create(:question) }
    before(:each) do
      visit users_path
    end

     expect(page).to have_content('All questions')
     expect(page).to have_content('All questions')

  describe "pagination" do

    before(:all) { 30.times { create(:question) } }
    after(:all)  { Question.delete_all }

    it { should have_selector('div.pagination') }

    it "should list each user" do
      User.paginate(page: 1).each do |question|
        expect(page).to have_selector('li', text: question.title)
        end
      end
    end
  end
end

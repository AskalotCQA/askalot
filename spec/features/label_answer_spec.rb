require 'spec_helper'

# TODO (smolnar) pavolzbell, resolve specs for helpful

describe 'Label Answer', js: true do
  let(:user) { create :user }
  let(:author) { create :user }
  let(:teacher) { create :teacher }

  let!(:question) { create :question, author: author }
  let!(:answer) { create :answer, question: question }

  context 'with question author' do
    before :each do
      login_as author
    end

    it 'labels answers as best' do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-best a").click

      wait_for_remote

      expect(answer).to be_labeled_by(author, :best)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-best a.answer-labeled-best")
      # expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a")
    end

    it 'labels answer as helpful' do
      pending

      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-helpful a").click

      wait_for_remote

      expect(answer).to be_labeled_by(author, :helpful)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a.answer-labeled-helpful")
    end

    it 'removes best label from answer' do
      answer.toggle_labeling_by! author, :best

      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-best a.answer-labeled-best").click

      wait_for_remote

      expect(answer).not_to be_labeled_by(author, :best)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-best a:not(.answer-labeled-best)")
      # expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a")
    end

    it 'removes helpful label from answer' do
      pending

      answer.toggle_labeling_by! author, :helpful

      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-helpful a.answer-labeled-helpful").click

      wait_for_remote

      expect(answer).not_to be_labeled_by(author, :helpful)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a:not(.answer-labeled-helpful)")
    end
  end

  context 'with another user' do
    before :each do
      login_as user
    end

    it 'visits question with best answer' do
      answer.toggle_labeling_by! author,  :best
      answer.toggle_labeling_by! author,  :helpful

      visit root_path

      click_link 'Otázky'
      click_link question.title

      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-best span")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful span")

      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-best a")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a")
    end

    it 'visits question with helpful answer' do
      pending

      answer.toggle_labeling_by! author,  :helpful

      visit root_path

      click_link 'Otázky'
      click_link question.title

      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-best span")
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful span")

      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-best a")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a")
    end
  end
end

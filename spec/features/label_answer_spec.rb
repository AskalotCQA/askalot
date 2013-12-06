require 'spec_helper'

describe 'Label Answer' do
  let(:user) { create :user }
  let(:author) { create :user }
  let(:teacher) { create :user, :as_teacher }

  let!(:question) { create :question, author: author }
  let!(:answer) { create :answer, question: question }

  context 'when user is question author' do
    before :each do
      login_as author
    end

    it 'adds best label to answer', js: true do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-best a").click

      wait_for_remote

      expect(answer).to be_labeled_by(author, :best)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-best a.answer-labeled-best")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a")
    end

    it 'adds helpful label to answer', js: true do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-helpful a").click

      wait_for_remote

      expect(answer).to be_labeled_by(author, :helpful)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a.answer-labeled-helpful")
    end

    it 'removes best label from answer', js: true do
      answer.toggle_labeling_by! author, :best

      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-best a.answer-labeled-best").click

      wait_for_remote

      expect(answer).not_to be_labeled_by(author, :best)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-best a:not(.answer-labeled-best)")
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a")
    end

    it 'removes best helpful from answer', js: true do
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

  context 'when user is not question author' do
    before :each do
      login_as user
    end

    it 'visits question with best and verified answer', js: true do
      answer.toggle_labeling_by! author,  :best
      answer.toggle_labeling_by! author,  :helpful
      answer.toggle_labeling_by! teacher, :verified

      visit root_path

      click_link 'Otázky'
      click_link question.title

      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-best span")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful span")
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-verified span")

      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-best a")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-verified a")
    end

    it 'visits question with helpful and verified answer', js: true do
      answer.toggle_labeling_by! author,  :helpful
      answer.toggle_labeling_by! teacher, :verified

      visit root_path

      click_link 'Otázky'
      click_link question.title

      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-best span")
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful span")
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-verified span")

      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-best a")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-helpful a")
      expect(page).not_to have_css("#answer-#{answer.id}-labeling .answer-labeling-verified a")
    end
  end

  context 'when user is teacher' do
    before :each do
      login_as teacher
    end

    it 'adds verified label to answer', js: true do
      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-verified a").click

      wait_for_remote

      expect(answer).to be_labeled_by(teacher, :verified)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-verified a.answer-labeled-verified")
    end

    it 'removes verified label from answer', js: true do
      answer.toggle_labeling_by! teacher, :verified

      visit root_path

      click_link 'Otázky'
      click_link question.title

      find("#answer-#{answer.id}-labeling .answer-labeling-verified a.answer-labeled-verified").click

      wait_for_remote

      expect(answer).not_to be_labeled_by(teacher, :verified)
      expect(page).to have_css("#answer-#{answer.id}-labeling .answer-labeling-verified a:not(.answer-labeled-verified)")
    end
  end
end

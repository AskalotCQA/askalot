require 'spec_helper'

describe 'Teacher administration', type: :feature do
  let(:user) { create :user }
  let(:teacher) { create :teacher }
  let(:administrator) { create :administrator }
  let(:category) { create :category, parent_id: nil }
  let(:category_lti) { create :category, parent_id: nil, lti_id: '123' }

  context 'teacher' do
    it 'has teacher administration link' do
      login_as teacher

      visit shared.root_path

      find(:xpath, "(//a[text()='Administrácia'])[1]").click

      expect(page).to have_content('Administrácia kategórií')
      expect(page).not_to have_content('Roly používateľov')
    end

    it 'can manage category' do
      Shared::Assignment.create({category_id: category.id, role_id: 2, user_id: teacher.id})
      Shared::Assignment.create({category_id: category_lti.id, role_id: 2, user_id: teacher.id})

      login_as teacher

      visit mooc.teacher_administration_root_path(context_uuid: category.uuid)

      expect(page).to have_content('Administrácia kategórií')
      expect(find('.administration-categories')).to have_content(category.name)
      expect(find('.administration-categories')).not_to have_content(category_lti.name)

      category_edit_link     = mooc.edit_teacher_administration_category_path(category, context_uuid: category.uuid)

      find(:xpath, "//a[@href='#{category_edit_link}']").click

      expect(page).to have_content('Upraviť kategóriu - ' + category.name)
      expect(page).to have_selector("input#category_name")

      fill_in 'category_name', with: 'Lorem ipsum title'

      click_button 'Upraviť'

      expect(page).to have_content('Lorem ipsum title')
    end

    it 'cannot edit name for LTI category' do
      Shared::Assignment.create({category_id: category_lti.id, role_id: 2, user_id: teacher.id})

      login_as teacher

      visit mooc.edit_teacher_administration_category_path(category_lti, context: category_lti.id)

      expect(page).to have_content('Upraviť kategóriu - ' + category_lti.name)
      expect(page).not_to have_selector("input#category_name")
    end
  end

  context 'user' do
    it 'does not have administration link' do
      login_as user

      visit shared.root_path

      expect(page).not_to have_content('Administrácia')
    end
  end

  context 'administrator' do
    it 'has administration link' do
      login_as administrator

      visit shared.root_path

      find(:xpath, "(//a[text()='Administrácia'])[1]").click

      expect(page).to have_content('Roly používateľov')
      expect(page).to have_content('Kategórie')
      expect(page).to have_content('Protokoly zmien')
      expect(page).to have_content('Hromadný e-mail')
    end
  end
end

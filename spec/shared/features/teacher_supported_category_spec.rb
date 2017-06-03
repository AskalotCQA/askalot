require 'spec_helper'

describe 'Teacher Supported Category', type: :feature do

  let(:user) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }
  let(:category) { create :category }
  let!(:question) { create :question, :with_tags, author: user, category: category }

  before :each do
    login_as user
  end

  it 'shows icons if it contains 1 teacher' do
    Shared::Assignment.create({ category_id: category.id, role_id: 2, user_id: user.id })

    expect(category.teachers.count).to eql(1)

    visit shared.root_path

    click_link 'Kategórie'

    list = all('#all i.fa-graduation-cap')

    expect(list.count).to eql(1)
    expect(list[0][:title]).to eql('Podporovaná učiteľom: ' + user.name)

    click_link 'Otázky'

    list = all('i.fa-graduation-cap')

    expect(list.count).to eql(1)
    expect(list[0][:title]).to eql('Podporovaná učiteľom: ' + user.name)

    click_link 'Pridať otázku', match: :first

    list = all('#question_category_id option')

    expect(list.count).to eql(3)
    expect(list[1][:'data-icon']).to eql('<i title="Podporovaná učiteľom: John Nash" data-toggle="tooltip" data-placement="top" data-trigger="hover" class="fa fa-graduation-cap supported-category-icon-lg"></i>')
  end

  it 'shows icons if it contains 2 teachers' do
    Shared::Assignment.create({ category_id: category.id, role_id: 2, user_id: user.id })
    Shared::Assignment.create({ category_id: category.id, role_id: 3, user_id: user2.id })
    Shared::Assignment.create({ category_id: category.id, role_id: 2, user_id: user3.id })

    expect(category.teachers.count).to eql(2)

    visit shared.root_path

    click_link 'Kategórie'

    list = all('#all i.fa-graduation-cap')

    expect(list.count).to eql(1)
    expect(list[0][:title]).to eql('Podporovaná učiteľmi: ' + user.name + ', ' + user3.name)

    click_link 'Otázky'

    list = all('i.fa-graduation-cap')

    expect(list.count).to eql(1)
    expect(list[0][:title]).to eql('Podporovaná učiteľmi: ' + user.name + ', ' + user3.name)

    click_link 'Pridať otázku', match: :first

    list = all('#question_category_id option')

    expect(list.count).to eql(3)
    expect(list[1][:'data-icon']).to eql('<i title="Podporovaná učiteľmi: John Nash, John Nash" data-toggle="tooltip" data-placement="top" data-trigger="hover" class="fa fa-graduation-cap supported-category-icon-lg"></i>')
  end

  it 'doesn\'t show icons if it contains only administrators and students' do
    Shared::Assignment.create({ category_id: category.id, role_id: 3, user_id: user.id })
    Shared::Assignment.create({ category_id: category.id, role_id: 1, user_id: user2.id })
    Shared::Assignment.create({ category_id: category.id, role_id: 3, user_id: user3.id })

    expect(category.teachers.count).to eql(0)

    visit shared.root_path

    click_link 'Kategórie'

    list = all('i.fa-graduation-cap')

    expect(list.count).to eql(0)

    click_link 'Otázky'

    list = all('i.fa-graduation-cap')

    expect(list.count).to eql(0)

    click_link 'Pridať otázku', match: :first

    list = all('#question_category_id option')

    expect(list.count).to eql(3)
    expect(list[1][:'data-icon']).to eq('')
  end

  it 'doesn\'t show icons if it has no users' do
    expect(category.teachers.count).to eql(0)

    visit shared.root_path

    click_link 'Kategórie'

    list = all('i.fa-graduation-cap')

    expect(list.count).to eql(0)

    click_link 'Otázky'

    list = all('i.fa-graduation-cap')

    expect(list.count).to eql(0)

    click_link 'Pridať otázku', match: :first

    list = all('#question_category_id option')

    expect(list.count).to eql(3)
    expect(list[1][:'data-icon']).to eq('')
  end

end

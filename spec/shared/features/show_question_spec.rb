require 'spec_helper'

describe 'Show Question', type: :feature do
  let(:question) { create :question, :with_tags, title: 'PostgreSQL setup' }

  before :each do
    login_as question.author
  end

  it 'shows new question' do
    visit shared.root_path

    click_link 'Otázky'

    click_link 'PostgreSQL setup'

    expect(page).to have_content('PostgreSQL setup')
    expect(page).to have_content(question.text)
    expect(page).to have_content(question.category.name)
    expect(page).to have_content(question.author.nick)

    question.tags.pluck(:name).each { |tag| expect(page).to have_content(tag) }
  end

  context 'when selecting a tag' do
    let(:question) { create :question, title: 'PostgreSQL indices', tag_list: 'ruby' }

    before :each do
      3.times { create :question, tag_list: 'ruby' }
      5.times { create :question }
    end

    it 'searches questions by the tag' do
      visit shared.root_path

      click_link 'Otázky'

      click_link 'PostgreSQL indices'

      within '#question-title .nav-labels' do
        click_link 'ruby'
      end

      expect(current_path).to   eql(shared.questions_path)
      expect(current_params).to eql(tags: 'ruby')

      list = all('#questions > ol > li')

      expect(list.size).to eq(4)

      within '#questions > ol' do
        expect(page).to have_content('PostgreSQL indices')
        expect(page).to have_content('ruby')
      end
    end
  end

  context 'when selecting a category' do
    let(:category) { create :category, name: 'Elasticsearch', tags: [:elasticsearch, :lucene], public_tags: [:elasticsearch, :lucene] }
    let(:question) { create :question, title: 'Elasticsearch config', category: category }

    before :each do
      3.times { create :question, category: category }
      5.times { create :question }
    end

    it 'searches questions by category tags' do
      visit shared.root_path

      click_link 'Otázky'

      click_link 'Elasticsearch config'

      within '#question-title .nav-labels' do
        click_link 'Elasticsearch'
      end

      expect(current_path).to   eql(shared.questions_path)
      expect(current_params).to eql(category: category.id.to_s)

      list = all('#questions > ol > li')

      expect(list.size).to eq(4)

      within '#questions > ol' do
        expect(page).to have_content('Elasticsearch config')
        expect(page).to have_content('Elasticsearch')

        category.tags.each do |tag|
          expect(page).to have_content(/#{tag}/i)
        end
      end
    end
  end
end

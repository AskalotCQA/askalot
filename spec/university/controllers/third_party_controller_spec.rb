require 'spec_helper'

describe University::ThirdPartyController, type: :controller do
  let(:user) { create :user }
  let!(:category) { create :category }
  let!(:third_party_category) { create :category, third_party_hash: 'hash' }
  let!(:question) { create :question, category: category }

  routes { University::Engine.routes }

  before(:each) do
    sign_in user
  end

  describe 'GET index' do
    it 'creates new category under allowed category' do
      categories_count = Shared::Category.all.size

      get :index, { hash: 'hash', name: 'test'}

      expect(response.status).to eq(200)
      expect(Shared::Category.all.size).to eq(categories_count + 1)
      expect(Shared::Category.last.name).to eq('test')
      expect(Shared::Category.last.parent_id).to eq(third_party_category.id)
    end

    it 'returns 404 if category is not registered for third party integration' do


      expect { get :index, { hash: 'incompatible', name: 'test'}}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET show' do
    it 'shows question page if all objects exists' do
      get :index, { hash: 'hash', name: 'test' }
      get :show, { hash: 'hash', name: 'test', id: question.id }
      expect(response.status).to eq(200)
    end

    it 'returns 404 if some category or question does not exits' do
      expect { get :show, { hash: 'incompatible', name: 'test', id: question.id }}.to raise_error(ActiveRecord::RecordNotFound)

      expect { get :show, { hash: 'hash', name: 'test', id: question.id }}.to raise_error(ActiveRecord::RecordNotFound)

      get :index, { hash: 'hash', name: 'test'}

      get :show, { hash: 'hash', name: 'test', id: question.id }
      expect(response.status).to eq(200)

      expect { get :show, { hash: 'hash', name: 'test', id: -1 }}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

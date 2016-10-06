require 'spec_helper'

describe Shared::QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:category) { create :category }

  routes { Shared::Engine.routes }

  describe 'GET index' do
    it 'creates activity about listing questions in category' do
      sign_in user

      get :index, category: category.id, context_uuid: Shared::Context::Manager.context_category.uuid

      expect(Shared::List.all.count).to eq(1)
      expect(Shared::List.last.unit_view).to eql(false)

      category.reload

      expect(category.lists_count).to eql(1)
    end
  end
end

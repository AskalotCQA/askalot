require 'spec_helper'

describe Shared::TagsController, type: :controller do
  let(:user) { create :user }

  routes { Shared::Engine.routes }

  before :each do
    sign_in user
  end

  describe 'GET suggest' do
    before :each do
      Shared::Tag.autoimport = true

      Shared::Tag.probe.index.reload do
        create :question, tag_list: 'test,testing,elasticsearch'

        tags_string = ''

        20.times { |n| tags_string += "tag ##{n}," }
        create :question, tag_list: tags_string[0..-2]
      end
    end

    it 'suggests tags' do
      get :suggest, q: 'test', format: :json, context: Shared::Context::Manager.default_context

      tags = assigns(:tags)

      expect(tags.map(&:name).sort).to eql(['test', 'testing'])

      json = {
        results: [
          { id: 'test', text: 'test (1)' },
          { id: 'testing', text: 'testing (1)' }
        ]
      }.to_json

      expect(response.body).to eql(json)
    end

    it 'suggest only 10 tags'  do
      get :suggest, q: 'tag', format: :json, context: Shared::Context::Manager.default_context

      tags = assigns(:tags)

      expect(tags.size).to eql(10)
    end
  end
end

require 'spec_helper'

describe TagsController do
  let(:user) { create :user }

  before :each do
    sign_in user
  end

  describe 'GET suggest' do
    before :each do
      Tag.autoimport = true

      Tag.probe.index.reload do
        create :tag, name: 'test'
        create :tag, name: 'testing'
        create :tag, name: 'elasticsearch'
      end
    end

    it 'suggests tags' do
      get :suggest, q: 'test', format: :json

      tags = assigns(:tags)

      expect(tags.map(&:name).sort).to eql(['test', 'testing'])

      json = {
        results: [
          { id: 'test', text: 'test (0)' },
          { id: 'testing', text: 'testing (0)' }
        ]
      }.to_json

      expect(response.body).to eql(json)
    end

    it 'suggest only 10 tags'  do
      20.times { |n| create :tag, name: "tag ##{n}" }

      get :suggest, q: 'tag', format: :json

      tags = assigns(:tags)

      expect(tags.size).to eql(10)
    end
  end
end

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
    end
  end
end

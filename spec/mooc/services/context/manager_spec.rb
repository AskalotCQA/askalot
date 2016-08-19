require 'spec_helper'

describe Shared::Context::Manager do
  let!(:second_context) { create :category, uuid: 'second_context' }

  after :each do
    Shared::Context::Manager.current_context_id = Shared::Context::Manager.default_context_id
  end

  describe 'self.context_url_prefix' do
    it 'returns correct url prefix' do
      context_category = Shared::Context::Manager.context_category
      url_prefix = Shared::Context::Manager.context_url_prefix

      expect(url_prefix).to eql("/#{context_category.uuid}")

      Shared::Context::Manager.current_context_id = second_context.id
      url_prefix = Shared::Context::Manager.context_url_prefix

      expect(url_prefix).to eql('/second_context')
    end
  end

  describe 'self.regex_context_url_prefix' do
    it 'returns correct regex url prefix' do
      context_category = Shared::Context::Manager.context_category
      url_prefix = Shared::Context::Manager.regex_context_url_prefix

      expect(url_prefix).to eql("\\/#{context_category.uuid}")

      Shared::Context::Manager.current_context_id = second_context.id
      url_prefix = Shared::Context::Manager.regex_context_url_prefix

      expect(url_prefix).to eql('\/second_context')
    end
  end
end

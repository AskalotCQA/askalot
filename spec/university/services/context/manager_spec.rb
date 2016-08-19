require 'spec_helper'

describe Shared::Context::Manager do
  after :each do
    Shared::Context::Manager.current_context_id = Shared::Context::Manager.default_context_id
  end

  describe 'self.regex_context_url_prefix' do
    it 'returns nothing as regex url prefix' do
      url_prefix = Shared::Context::Manager.regex_context_url_prefix

      expect(url_prefix).to eql('')

      Shared::Context::Manager.current_context_id = 2
      url_prefix = Shared::Context::Manager.regex_context_url_prefix

      expect(url_prefix).to eql('')
    end
  end

  describe 'self.current_context_id' do
    it 'returns current academic year category as context' do
      context_id = Shared::Context::Manager.default_context_id
      category = Shared::Category.find_by(name: Shared::Tag.current_academic_year_value)

      expect(context_id).to eql(category.id)
    end
  end
end

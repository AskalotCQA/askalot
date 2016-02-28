require 'spec_helper'

describe Shared::Context::Manager do
  after :each do
    Shared::Context::Manager.current_context = Shared::Context::Manager.default_context
  end

  describe 'self.current_context=' do
    it 'updates current context' do
      context = Shared::Context::Manager.default_context

      expect(Shared::Context::Manager.current_context).to eql(context)

      Shared::Context::Manager.current_context = 'test'

      expect(Shared::Context::Manager.current_context).to eql('test')
    end
  end

  describe 'self.current_context' do
    it 'returns current context' do
      context = Shared::Context::Manager.default_context

      expect(Shared::Context::Manager.current_context).to eql(context)

      Shared::Context::Manager.current_context = 'test'

      expect(Shared::Context::Manager.current_context).to eql('test')
    end
  end

  describe 'self.default_context' do
    it 'returns default context' do
      context = Shared::Context::Manager.default_context

      expect(context).to eql(Shared::Category.find_by(parent_id: nil).name)
    end
  end

  describe 'self.context_category' do
    it 'returns category for default context' do
      category = Shared::Context::Manager.context_category

      expect(category.class.name).to eql('Shared::Category')
      expect(category.name).to eql(Shared::Context::Manager.current_context)
    end

    it 'returns category for current context' do
      Shared::Category.create name: :test

      Shared::Context::Manager.current_context = 'test'

      category = Shared::Context::Manager.context_category

      expect(category.class.name).to eql('Shared::Category')
      expect(category.name).to eql(Shared::Context::Manager.current_context)
    end

    it 'returns category for specific context' do
      Shared::Category.create name: :linux

      category = Shared::Context::Manager.context_category(:linux)

      expect(category.class.name).to eql('Shared::Category')
      expect(category.name).to eql('linux')
    end
  end
end

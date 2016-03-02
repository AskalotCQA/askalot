require 'spec_helper'

describe Shared::Context::Manager do
  after :each do
    Shared::Context::Manager.current_context = Shared::Context::Manager.default_context
  end

  describe 'self.current_context=' do
    it 'updates current context' do
      context = Shared::Context::Manager.default_context

      expect(Shared::Context::Manager.current_context).to eql(context)

      Shared::Context::Manager.current_context = 7

      expect(Shared::Context::Manager.current_context).to eql(7)
    end
  end

  describe 'self.current_context' do
    it 'returns current context' do
      context = Shared::Context::Manager.default_context

      expect(Shared::Context::Manager.current_context).to eql(context)

      Shared::Context::Manager.current_context = 7

      expect(Shared::Context::Manager.current_context).to eql(7)
    end
  end

  describe 'self.default_context' do
    it 'returns default context' do
      context = Shared::Context::Manager.default_context

      expect(context).to eql(1)
    end
  end
end

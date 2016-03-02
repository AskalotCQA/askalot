require 'spec_helper'

describe Shared::Context::Manager do
  after :each do
    Shared::Context::Manager.current_context = Shared::Context::Manager.default_context
  end

  describe 'self.context_url_prefix' do
    it 'returns correct url prefix' do
      context = Shared::Context::Manager.current_context
      url_prefix = Shared::Context::Manager.context_url_prefix

      expect(url_prefix).to eql("/#{context}")

      Shared::Context::Manager.current_context = 7
      url_prefix = Shared::Context::Manager.context_url_prefix

      expect(url_prefix).to eql('/7')
    end
  end

  describe 'self.regex_context_url_prefix' do
    it 'returns correct regex url prefix' do
      context = Shared::Context::Manager.current_context
      url_prefix = Shared::Context::Manager.regex_context_url_prefix

      expect(url_prefix).to eql("\\/#{context}")

      Shared::Context::Manager.current_context = 7
      url_prefix = Shared::Context::Manager.regex_context_url_prefix

      expect(url_prefix).to eql('\/7')
    end
  end

  describe 'self.question_context' do
    it 'returns the same context for questions and page context' do
      context = Shared::Context::Manager.default_context
      question_context = Shared::Context::Manager.default_question_context

      expect(question_context).to eql(context)
    end
  end

  describe 'self.question_context=' do
    it 'updates question context' do
      context = Shared::Context::Manager.default_question_context

      expect(Shared::Context::Manager.question_context).to eql(context)

      Shared::Context::Manager.question_context = 7

      expect(Shared::Context::Manager.question_context).to eql(7)
    end
  end

  describe 'self.default_question_context' do
    it 'returns default question context' do
      context = Shared::Context::Manager.default_question_context

      expect(context).to eql(1)
    end
  end
end

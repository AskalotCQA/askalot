require 'spec_helper'

describe Shared::Context::Manager do
  after :each do
    Shared::Context::Manager.current_context = Shared::Context::Manager.default_context
  end

  describe 'self.context_url_prefix' do
    it 'returns correct url prefix' do
      url_prefix = Shared::Context::Manager.context_url_prefix

      expect(url_prefix).to eql('')

      Shared::Context::Manager.current_context = 'test'
      url_prefix = Shared::Context::Manager.context_url_prefix

      expect(url_prefix).to eql('')
    end
  end

  describe 'self.regex_context_url_prefix' do
    it 'returns correct regex url prefix' do
      url_prefix = Shared::Context::Manager.regex_context_url_prefix

      expect(url_prefix).to eql('')

      Shared::Context::Manager.current_context = 'test'
      url_prefix = Shared::Context::Manager.regex_context_url_prefix

      expect(url_prefix).to eql('')
    end
  end

  describe 'self.question_context' do
    it 'returns different context for questions and page context' do
      context = Shared::Context::Manager.default_context
      question_context = Shared::Context::Manager.default_question_context

      expect(question_context).not_to eql(context)
      expect(context).to eql('root')
      expect(question_context).to eql(Shared::Tag.current_academic_year_value)
    end
  end

  describe 'self.question_context=' do
    it 'updates question context' do
      context = Shared::Context::Manager.default_question_context

      expect(Shared::Context::Manager.question_context).to eql(context)

      Shared::Context::Manager.question_context = 'test'

      expect(Shared::Context::Manager.question_context).to eql('test')
    end
  end

  describe 'self.default_question_context' do
    it 'returns default question context' do
      context = Shared::Context::Manager.default_question_context

      expect(context).to eql(Shared::Tag.current_academic_year_value)
    end
  end
end

require 'spec_helper'
require 'shared/redcurtain/markdown'

describe Shared::Redcurtain::Markdown do
  let(:markdown) { Class.new { include Shared::Redcurtain::Markdown }.new }

  after :each do
    markdown.renderers = nil
  end

  describe '#render' do
    it 'checks renderer chaining' do
      options = { a: { key: 0 }, b: { key: 1 }, c: { key: 2 } }

      a = double(:renderer, name: 'Renderer::A')
      b = double(:renderer, name: 'Renderer::B')
      c = double(:renderer, name: 'Renderer::C')

      markdown.renderers = [a, b, c]

      expect(a).to receive(:render).with('a', { key: 0 }).and_return('b')
      expect(b).to receive(:render).with('b', { key: 1 }).and_return('c')
      expect(c).to receive(:render).with('c', { key: 2 }).and_return('d')

      expect(markdown.render('a', options)).to eql('d')
    end
  end

  describe '#strip' do
    it 'renders plain text from markdown' do
      html = "# Hello, [google](https://google.com)"
      text = "Hello, google (https://google.com)\n"

      expect(markdown.strip(html)).to eql(text)
    end
  end
end

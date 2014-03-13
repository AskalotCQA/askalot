require 'spec_helper'

describe Redcurtain::Markdown do
  let(:markdown) { Class.new { include Redcurtain::Markdown }.new }

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

    it 'renders markdown' do
      options = {
        gemoji: {
          class: 'doge-class',
          path: '/assets',
          title: false
        }
      }

      text = "`code` :dog: ```ruby\ndoge.code```\nhello :unknown-doge:"
      html = "<p><code>code</code> <img class=\"doge-class\" src=\"/assets/dog.png\" alt=\"dog\"/> <code>ruby\ndoge.code</code>\nhello :unknown-doge:</p>"

      markdown.renderers = [
        Redcurtain::Renderer::Redcarpet,
        Redcurtain::Renderer::Gemoji,
        Redcurtain::Renderer::Pygments
      ]

      expect(markdown.render(text, options)).to eql(html)
    end
  end

  describe '#strip' do
    it 'renders plain text from markdown' do
      html = "# Hello, [google](https://google.com)"
      text = "Hello, google\n"

      expect(markdown.strip(html)).to eql(text)
    end
  end
end

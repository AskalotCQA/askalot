require 'spec_helper'

describe Redcurtain::Markdown do
  let(:markdown) { described_class }

  after :each do
    Redcurtain::Markdown.setup!
  end

  describe '#render' do
    it 'renders markdown' do
      renderer    = double(:renderer)
      highlighter = double(:highlighter)

      markdown.renderer    = renderer
      markdown.highlighter = highlighter

      html = "<pre lang=\"ruby\">puts 'Hello, world.'</pre>"

      expect(renderer).to    receive(:render).with('text').and_return(html)
      expect(highlighter).to receive(:highlight).with("puts 'Hello, world.'", language: :ruby).and_return('<pre>highlighted code</pre>')

      expect(markdown.render('text')).to include('<pre>highlighted code</pre>')
    end
  end

  describe '#strip' do
    it 'renders plain text from markdown' do
      renderer    = double(:renderer)
      highlighter = double(:highlighter)

      markdown.renderer    = renderer
      markdown.highlighter = highlighter

      html = "<pre lang=\"ruby\">puts 'Hello, world.'</pre>"

      expect(renderer).to    receive(:render).with('text').and_return(html)
      expect(highlighter).to receive(:highlight).with("puts 'Hello, world.'", language: :ruby).and_return('<pre>highlighted code</pre>')

      expect(markdown.render('text')).to include('highlighted code')
    end
  end
end

require 'spec_helper'

describe Redcurtain::Renderer::Pygments do
  subject { described_class }

  describe '.render' do
    it 'highlights code in content' do
      html     = '<pre lang="ruby">code</pre>'
      pygments = double(:pygments)

      expect(pygments).to receive(:highlight).with('code', lexer: 'ruby').and_return('<pre>highlighted code</pre>')

      stub_const('::Pygments', pygments)

      content = subject.render(html)

      expect(content).to include('<pre>highlighted code</pre>')
    end
  end
end

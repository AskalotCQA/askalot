require 'spec_helper'

describe Redcurtain::Renderer::Pygments do
  subject { described_class }

  describe '.render' do
    it 'highlights code in content' do
      html     = '<code lang="ruby">code</code>'
      pygments = double(:pygments)

      expect(pygments).to receive(:highlight).with('code', lexer: 'ruby').and_return('<code>highlighted code</code>')

      stub_const('::Pygments', pygments)

      content = subject.render(html)

      expect(content).to eql('<code>highlighted code</code>')
    end
  end
end

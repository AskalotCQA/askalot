require 'spec_helper'
require 'shared/redcurtain/renderer/pygments'

describe Shared::Redcurtain::Renderer::Pygments do
  subject { described_class }

  describe '.render' do
    it 'highlights code in content' do
      html     = '<pre><code class="ruby">code</code></pre>'
      pygments = double(:pygments)

      expect(pygments).to receive(:highlight).with('code', lexer: 'ruby').and_return('<pre><code>highlighted code</code></pre>')

      stub_const('::Pygments', pygments)

      content = subject.render(html)

      expect(content).to eql('<pre><code>highlighted code</code></pre>')
    end
  end
end

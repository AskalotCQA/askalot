require 'spec_helper'

describe Redcurtain::Renderer::Replacer do
  subject { described_class.new(:replacer) }

  describe '.render' do
    let(:replacer) { lambda { |match| "@#{match}" } }

    it 'replaces occurance of regex' do
      text = 'such doge, wow'

      result = subject.render(text, replacer: replacer, regex: /doge/)

      expect(result.to_s).to include('such @doge, wow')
    end
  end
end

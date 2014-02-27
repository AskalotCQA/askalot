require 'spec_helper'

describe Redcurtain::Renderer::Gemoji do
  subject { described_class }

  describe '.render' do
    let(:content) { ":poop:" }

    before :each do
      Emoji.stub(:names) { ['dancer', 'poop'] }
    end

    it 'renders emoji icons' do
      result = subject.render(content)

      expect(result.strip).to eql('<img class="gemoji" src="/images/gemoji/poop.png" alt="poop" />')
    end

    it 'renders emoji icons with custom classes' do
      result = subject.render(content, class: [:class1, :class2])

      expect(result.strip).to eql('<img class="class1 class2" src="/images/gemoji/poop.png" alt="poop" />')
    end

    it 'renders emoji icons with custom path' do
      result = subject.render(content, path: '/assets/images/')

      expect(result.strip).to eql('<img class="gemoji" src="/assets/images/poop.png" alt="poop" />')
    end
  end
end

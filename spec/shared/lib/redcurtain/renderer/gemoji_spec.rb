require 'spec_helper'
require 'shared/redcurtain/renderer/gemoji'

describe Redcurtain::Renderer::Gemoji do
  subject { described_class }

  describe '.render' do
    let(:content) { ":poop:" }

    before :each do
      allow(Emoji).to receive(:names) { ['dancer', 'poop'] }
    end

    it 'renders emoji icons' do
      result = subject.render(content, title: false)

      expect(result.to_s).to eql('<img class="gemoji" src="/images/gemoji/poop.png" alt="poop" />')
    end

    it 'renders emoji icons with custom classes' do
      result = subject.render(content, class: [:class1, :class2], title: false)

      expect(result.to_s).to eql('<img class="class1 class2" src="/images/gemoji/poop.png" alt="poop" />')
    end

    it 'renders emoji icons with custom path' do
      result = subject.render(content, path: '/assets/images/', title: false)

      expect(result.to_s).to eql('<img class="gemoji" src="/assets/images/poop.png" alt="poop" />')
    end

    it 'respects markdown codespan' do
      result = subject.render('you can embed icons with `:poop:`', title: false)

      result = result.to_s.gsub(/\s+/, ' ')

      expect(result.to_s.strip).to eql("you can embed icons with `:poop:`")
    end
  end
end

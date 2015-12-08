require 'spec_helper'
require 'shared/redcurtain/renderer/linker'

describe Shared::Redcurtain::Renderer::Linker do
  subject { described_class.new(:linker) }

  describe '#render' do
    let(:linker) { lambda { |nick| "/users/#{nick.strip}" } }

    it 'requires linker' do
      expect { subject.render('Hey, @smolnar.') }.to raise_error(ArgumentError)
    end

    it 'replaces references by respecting links' do
      content = subject.render('Hey, @smolnar, look at this.', linker: linker)

      expect(content).to eql('Hey, /users/@smolnar, look at this.')
    end

    it 'replaces references with more complex names' do
      content = subject.render('Hey, @doge_weather, look at this.', linker: linker)

      expect(content).to eql('Hey, /users/@doge_weather, look at this.')
    end

    it 'replaces references with custom regex' do
      content = subject.render('Hey, -user-doge_weather, look at this.', linker: linker, reference: /-user-/, regex: /-user-\w+/)

      expect(content).to eql('Hey, /users/-user-doge_weather, look at this.')
    end

    it 'respects spaces' do
      linker = lambda { |nick| "##{nick.strip}" }

      content = subject.render('Hey, @smolnar, look at this.', linker: linker)

      expect(content).to eql('Hey, #@smolnar, look at this.')
    end

    context 'when linker returns nil' do
      it 'does not replace reference' do
        linker = lambda { |user| nil }

        content = subject.render('Hey, @smolnar, look at this.', linker: linker)

        expect(content).to eql('Hey, @smolnar, look at this.')
      end
    end
  end
end

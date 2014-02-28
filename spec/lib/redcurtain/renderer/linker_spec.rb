require 'spec_helper'

describe Redcurtain::Renderer::Linker do
  subject { described_class }

  describe '.render' do
    let(:linker) { lambda { |nick| "/users/#{nick}" } }

    it 'replaces references by respecting links' do
      content = subject.render('Hey, @smolnar, look at this.', linker: linker)

      expect(content).to eql('Hey, /users/smolnar, look at this.')
    end

    it 'replaces references with more complex names' do
      content = subject.render('Hey, @doge_weather, look at this.', linker: linker)

      expect(content).to eql('Hey, /users/doge_weather, look at this.')
    end

    it 'replaces references with custom reference character' do
      content = subject.render('Hey, $doge_weather, look at this.', linker: linker, reference: /\$/)

      expect(content).to eql('Hey, /users/doge_weather, look at this.')
    end

    it 'replaces references with custom reference regex' do
      content = subject.render('Hey, $user-doge_weather, look at this.', linker: linker, reference: /\$user-/, regex: /\$user-/)

      expect(content).to eql('Hey, /users/doge_weather, look at this.')
    end
  end
end

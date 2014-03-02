require 'spec_helper'

module Redcurtain::Renderer::Redcarpet
  describe Factory do
    describe '.create' do
      it 'creates renderer' do
        renderer = Factory.create

        Factory::TAGS.each do |tag|
          expect(renderer).not_to respond_to(tag)
        end
      end

      it 'creates renderer with allowed tags' do
        renderer = Factory.create(allowed_tags: Factory::TAGS - [:highlight])

        expect(renderer).to respond_to(:highlight)
        expect(renderer.highlight('a')).to eql('a')
      end

      context 'with irregular tags' do
        it 'handles striping tags correctly' do
          renderer = Factory.create(allowed_tags: Factory::TAGS - [:link, :header])

          expect(renderer.header('a')).to eql("a\n")

          link = renderer.link('https://askalot.fiit.stuba.sk', nil, 'askalot')

          expect(link).to eql('askalot')
        end
      end
    end
  end
end

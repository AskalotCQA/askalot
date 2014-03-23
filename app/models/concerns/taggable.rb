# TODO(zbell) drop polymorphic from taggable

module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings

    scope :tagged_with, lambda { |values, options = {}| Scope.new(self).build(values, options) }

    after_save :generate_tags!
  end

  def tag_list
    @tag_list ||= TagList.new(self.class.taggable, tags.pluck(:name))
  end

  def tag_list=(values)
    @tag_list = TagList.new(self.class.taggable, values)
  end

  private

  # TODO(zbell) rename -> create_tags
  def generate_tags!
    tag_list.each do |name|
      tag = Tag.find_or_create_by! name: name

      Tagging.find_or_create_by! tag_id: tag.id, taggable_id: self.id, taggable_type: self.class.base_class.name
    end

    taggings.each(&:destroy) if tag_list.empty?

    flush_tags!
  end

  # TODO(zbell) rename -> update_tags
  def flush_tags!
    taggings.includes(:tag).references(:tags).where('tags.name not in (?)', tag_list.tags).each(&:destroy)
    reload
  end

  module ClassMethods
    def taggable
      @taggable ||= Class.new do
        include Squire::Base

        config.extractor = TagList::Extractor
      end
    end
  end

  class Scope
    attr_accessor :relation

    def initialize(relation)
      @relation = relation
    end

    def build(values, options = {})
      tags = Taggable::TagList.new(relation.taggable, values).tags

      if options[:any]
        relation.where tags: { name: tags }
      else
        # TODO(smolnar) REFACTOR, resolve why reference to class is scoped!
        # TODO(zbell) rm questions dependency
        ids   = []
        scope = relation.base_class

        tags.each do |name|
          questions = scope.joins(:tags).where(tags: { name: name })

          ids   = ids.empty? ? questions.map(&:id) : ids & questions.map(&:id)
          scope = scope.where(questions: { id: ids })
        end

        relation.where(questions: { id: ids })
      end
    end
  end

  class TagList
    include Enumerable

    attr_reader :values

    attr_accessor :base, :extractor

    def initialize(base, values = [])
      @base   = base
      @values = values
    end

    def extractor
      @extractor ||= base.extractor? ? base.extractor : TagList::Extractor
    end

    def each
      tags.each { |value| yield value }
    end

    def tags
      @tags ||= extractor.extract(values)
    end

    def +(values)
      @tags = tags + extractor.extract(values)
    end

    def to_s
      tags.join(',')
    end

    def empty?
      values.empty?
    end

    class Extractor
      def self.extract(values)
        (values.is_a?(Array) ? values.map(&:to_s) : values.to_s.split(/,/)).map(&:strip)
      end
    end
  end
end

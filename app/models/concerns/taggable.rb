module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    scope :tagged_with, lambda { |values, options = {}| Scope.new(self).build(values, options) }

    after_save :create_tags!
  end

  def tag_list
    @tag_list ||= TagList.new(self.class.taggable.extractor, tags.pluck(:name))
  end

  def tag_list=(values)
    tag_list.values = values
  end

  def changed?
    super || (tag_list.tags - tags.pluck(:name)).any?
  end

  private

  #TODO(zbell) tagging author can be question author, deletor or editor; for now question author is always used

  def create_tags!
    # TODO(zbell) add unmark_as_deleted here

    tag_list.each do |name|
      tag = Tag.find_or_create_by! name: name

      Tagging.find_or_create_by! author: author, question: self, tag: tag
    end

    update_tags!
  end

  def update_tags!
    relation = taggings
    relation = relation.includes(:tag).references(:tags).where('tags.name not in (?)', tag_list.tags) unless tag_list.empty?

    relation.each { |tagging| tagging.mark_as_deleted_by! author }

    taggings.reload
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
      tags = Taggable::TagList.new(relation.taggable.extractor, values).tags

      if options[:any]
        relation.where tags: { name: tags }
      else
        # TODO(smolnar) refactor: resolve why reference to class is scoped, propose another solution for AND search
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

    attr_accessor :extractor, :values

    def initialize(extractor, values = [])
      @extractor = extractor
      @values    = values
    end

    def values=(values)
      @values = values
      @tags   = nil
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

module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    scope :tagged_with, lambda { |values, options = {}| Scope.new(self).build(values, options) }

    after_save :resolve_tags!, if: :tags_changed?
  end

  def tag_list
    @tag_list ||= TagList.new(self.class.taggable.extractor, tags.pluck(:name))
  end

  def tag_list=(values)
    tag_list.values = values
  end

  def changed?
    super || tags_changed?
  end

  private

  def tags_changed?
    Set.new(tag_list.tags) != Set.new(tags.pluck :name)
  end

  def resolve_tags!
    create_tags!
    delete_tags!

    reload
  end

  #TODO(zbell) author or editor can create tagging; for now question author is always used

  def create_tags!
    (tag_list.tags - tags.pluck(:name)).each do |name|
      tag     = Tag.find_or_create_by!(name: name)
      tagging = Tagging.deleted_or_new(author: author, question: self, tag: tag).mark_as_undeleted!

      self.class.taggable.dispatcher.dispatch :create, author, tagging, for: watchers
    end
  end

  #TODO(zbell) deletor or editor can delete tagging; for now author is always used

  def delete_tags!
    relation = taggings
    relation = relation.includes(:tag).references(:tags).where.not(tags: { name: tag_list.tags }) unless tag_list.empty?

    relation.each do |tagging|
      tagging.mark_as_deleted_by! author

      self.class.taggable.dispatcher.dispatch :delete, author, tagging, for: watchers
    end
  end

  module ClassMethods
    def taggable
      @taggable ||= Class.new do
        include Squire::Base

        config.dispatcher = Events::Dispatcher
        config.extractor  = Tags::Extractor
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

  # TODO (zbell) should TagList extend Set?
  class TagList
    include Enumerable

    attr_reader :extractor

    def initialize(extractor = TagList::Extractor, values = [])
      @extractor = extractor

      self.values = values
    end

    def tags
      @tags ||= []
    end

    def values=(values)
      @tags = extract(values)
    end

    def +(values)
      @tags += extract(values)
    end

    def each
      tags.each { |name| yield name }
    end

    def empty?
      tags.empty?
    end

    def size
      tags.size
    end

    def to_s
      tags.join(',')
    end

    private

    def extract(values)
      extractor.extract(values).uniq
    end
  end
end

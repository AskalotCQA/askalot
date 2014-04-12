module Deletable
  extend ActiveSupport::Concern

  included do
    belongs_to :deletor, class_name: :User

    scope :deleted,   lambda { where(deleted: true) }
    scope :undeleted, lambda { where(deleted: false) }

    default_scope -> { undeleted }
  end

  module ClassMethods
    def deleted_or_new(params)
      #TODO(poizl) when at rails 4.1 refractor to unscope(:deleted)
      self.unscoped.find_or_initialize_by(params)
    end
  end

  def mark_as_deleted_by!(user, datetime = DateTime.now.in_time_zone)
    self.transaction(requires_new: true) do
      self.mark_as_deleted_recursive!(user, datetime)

      self.deleted    = true
      self.deletor    = user
      self.deleted_at = datetime

      deleted_changed = self.deleted_changed?

      self.save!

      self.decrement_counter_caches! if deleted_changed
    end

    self
  end

  def unmark_as_deleted!
    self.transaction do
      self.deleted    = false
      self.deletor    = nil
      self.deleted_at = nil

      deleted_changed = self.deleted_changed?

      self.save!

      self.increment_counter_caches! if deleted_changed
    end

    self
  end

  def toggle_deleted_by!(user)
    if self.deleted? || self.new_record?
      unmark_as_deleted!
    else
      mark_as_deleted_by! user
    end
  end

  protected

  def mark_as_deleted_recursive!(user, datetime)
    self.reflections.each do |key, target|
      if mark_as_deleted? target
        self.send(key.to_s).each do |child|
          child.mark_as_deleted_by!(user, datetime)
        end
      end
    end
  end

  def mark_as_deleted?(model)
    model.options[:dependent] == :destroy && model.macro == :has_many && model.klass.column_names.include?('deleted')
  end

  def increment_counter_caches!
    self.reflections.each do |key, target|
      if target.macro == :belongs_to && target.options[:counter_cache] == true
        owner  = self.send(key.to_s)
        column = target.counter_cache_column.to_sym

        if owner
          owner.class.increment_counter(column, owner.id)
          owner.increment column
        end
      end
    end
  end

  def decrement_counter_caches!
    self.reflections.each do |key, target|
      if target.macro == :belongs_to && target.options[:counter_cache] == true
        owner  = self.send(key.to_s)
        column = target.counter_cache_column.to_sym

        if owner
          owner.class.decrement_counter(column, owner.id)
          owner.decrement column
        end
      end
    end
  end
end

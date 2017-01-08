module Shared::Deletable
  extend ActiveSupport::Concern

  included do
    belongs_to :deletor, class_name: :'Shared::User'

    scope :deleted,   lambda { unscope(where: :deleted).where(deleted: true) }
    scope :undeleted, lambda { unscope(where: :deleted).where(deleted: false) }

    default_scope -> { undeleted }
  end

  module ClassMethods
    def deleted_or_new(params)
      self.unscope(where: :deleted).find_or_initialize_by(params)
    end
  end

  def mark_as_deleted_by!(user, time = DateTime.now.in_time_zone)
    self.transaction(requires_new: true) do
      self.mark_as_deleted_recursive!(user, time)

      self.deleted = true

      deleted_changed = self.deleted_changed?

      self.deletor, self.deleted_at = user, time if deleted_changed

      self.save!

      self.decrement_counter_caches! if deleted_changed
    end

    self
  end

  def mark_as_undeleted!
    self.transaction do
      self.deleted = false

      deleted_changed = self.deleted_changed?

      self.deletor, self.deleted_at = nil, nil if deleted_changed

      self.save!

      self.increment_counter_caches! if deleted_changed
    end

    self
  end

  def toggle_deleted_by!(user)
    if self.new_record? || self.deleted?
      mark_as_undeleted!
    else
      mark_as_deleted_by! user
    end
  end

  protected

  def mark_as_deleted?(model)
    model.options[:dependent] == :destroy && model.macro == :has_many && model.klass.column_names.include?('deleted')
  end

  def mark_as_deleted_recursive!(user, time)
    self._reflections.each do |key, target|
      if mark_as_deleted? target
        self.send(key.to_s).reload.each do |child|
          child.mark_as_deleted_by!(user, time)
        end
      end
    end
  end

  def increment_counter_caches!
    update_counter_caches! :increment
  end

  def decrement_counter_caches!
    update_counter_caches! :decrement
  end

  def update_counter_caches!(action)
    self._reflections.each do |key, target|
      if target.macro == :belongs_to && target.options[:counter_cache]
        owner  = self.send(key.to_s)
        column = target.counter_cache_column.to_sym

        if owner
          owner.class.send("#{action}_counter", column, owner.id)
          owner.send(action.to_s, column)
        end
      end
    end
  end
end

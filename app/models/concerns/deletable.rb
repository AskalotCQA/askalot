module Deletable
  extend ActiveSupport::Concern

  included do
    belongs_to :deletor, class_name: :User

    # TODO(zbell) rm when on rails 4.1.0 since belongs_to -> { unscoped / unscope(:where) } does not work in 4.0.x
    scope :deleted_or_not, lambda { where(deleted: [true, false]) }

    scope :deleted,   lambda { where(deleted: true) }
    scope :undeleted, lambda { where(deleted: false) }

    default_scope -> { undeleted }
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

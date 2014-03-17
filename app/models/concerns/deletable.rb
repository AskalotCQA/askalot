module Deletable
  extend ActiveSupport::Concern

  included do
    belongs_to :deletor, class_name: :User

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

      self.save!

      self.decrement_counter_caches!
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
        self.send(key.to_s).class.decrement_counter((self.class.name.classify.downcase + "s_count").to_sym, self.send(key.to_s).id)
      end
    end
  end
end

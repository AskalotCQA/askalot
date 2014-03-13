module Deletable
  extend ActiveSupport::Concern

  included do
    belongs_to :deletor, class_name: :User

    scope :deleted,   lambda { where(deleted: true) }
    scope :undeleted, lambda { where(deleted: false) }

    default_scope -> { undeleted }

    after_save  :recursion_mark_as_deleted!

    end

  def mark_as_deleted_by!(user)
    self.deleted    = true
    self.deletor    = user
    self.deleted_at = DateTime.now

    self.save!
  end

  def recursion_mark_as_deleted!
    if self.deleted?
      self.reflections.each do |key, target_child|
        if can_delete target_child
          self.send(key.to_s).each do |recursion_child|
            recursion_child.mark_as_deleted! self.deletor
          end
        end
      end
    end
  end

  def can_delete(model)
    model.options[:dependent] == :destroy && model.macro == :has_many && model.klass.column_names.include?('deleted')
  end
end

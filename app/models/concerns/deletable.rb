module Deletable
  extend ActiveSupport::Concern

  included do
    belongs_to :deletor, class_name: :User

    scope :deleted,   lambda { where(deleted: true) }
    scope :undeleted, lambda { where(deleted: false) }

    default_scope -> { undeleted }

    after_save :mark_as_deleted_recursive!
  end

  def mark_as_deleted_by!(user)
    self.deleted    = true
    self.deletor    = user
    self.deleted_at = DateTime.now

    self.save!
  end

  private

  def mark_as_deleted_recursive!
    if self.deleted?
      self.reflections.each do |key, target|
        if mark_as_deleted? target
          self.send(key.to_s).each do |child|
            child.mark_as_deleted_by! self.deletor
          end
        end
      end
    end
  end

  def mark_as_deleted?(model)
    model.options[:dependent] == :destroy && model.macro == :has_many && model.klass.column_names.include?('deleted')
  end
end

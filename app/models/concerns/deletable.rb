module Deletable
  extend ActiveSupport::Concern

  def mark_as_deleted!(deletion)
    deletion.deleted = true
    deletion.save!
  end
end

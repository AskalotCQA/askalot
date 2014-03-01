module Deletable
  extend ActiveSupport::Concern

  def delete_object!(deletion)
    deletion.deleted = true
    deletion.save!
  end
end

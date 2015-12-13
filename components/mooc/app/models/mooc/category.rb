module Mooc
  class Category < Shared::Category
    has_many :questions, dependent: :restrict_with_exception
  end
end

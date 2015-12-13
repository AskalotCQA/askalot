module Mooc
  class Question < Shared::Question
    def labels
      tags
    end
  end
end

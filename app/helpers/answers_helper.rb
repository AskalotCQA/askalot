module AnswersHelper
  def answer_highlighted?(resource)
      resource.author.role?(:teacher) && !resource.author.role?(:administrator)
  end
end

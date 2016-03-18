$(document).ready ->
  $('#question-<%= @question.id %>-favoring').replaceWith("<%= escape_javascript render('shared/questions/favoring', model: :question, question: @question) %>")

  fixes()

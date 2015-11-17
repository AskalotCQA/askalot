$(document).ready ->
  $('#question-<%= @question.id %>-favoring').replaceWith("<%= escape_javascript render('university/questions/favoring', model: :question, question: @question) %>")

  fixes()

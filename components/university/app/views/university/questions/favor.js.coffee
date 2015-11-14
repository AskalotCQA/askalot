$(document).ready ->
  $('#question-<%= @question.id %>-favoring').replaceWith("<%= escape_javascript render('questions/favoring', model: :question, question: @question) %>")

  fixes()

$(document).ready ->
  $('#question-<%= @question.id %>-favoring').replaceWith("<%= escape_javascript render('questions/favoring', question: @question) %>")

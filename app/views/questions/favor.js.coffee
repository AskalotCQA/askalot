$(document).ready ->
  $('#question-favoring-<%= @question.id %>').replaceWith("<%= escape_javascript render('questions/favoring', question: @question) %>")

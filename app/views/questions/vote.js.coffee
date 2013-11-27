$(document).ready ->
  $('#question-<%= @question.id %>-voting').replaceWith("<%= escape_javascript render('questions/voting', question: @question) %>")
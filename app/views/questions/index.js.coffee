$(document).ready ->
  $('#questions').replaceWith("<%= escape_javascript render('questions', questions: @questions) %>")

$(document).ready ->
  $('.question-favoring').replaceWith("<%= escape_javascript render('questions/favoring', question: @question) %>")

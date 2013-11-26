$(document).ready ->
  $('.question-favouring').replaceWith("<%= escape_javascript render('questions/favouring', question: @question) %>")

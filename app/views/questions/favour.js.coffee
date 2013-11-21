$(document).ready ->
  $('.question-favouring').html("<%= escape_javascript render('questions/favouring', question: @question) %>")

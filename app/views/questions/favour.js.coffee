$(document).ready ->
  $('.question-favouring').html("<%= escape_javascript render('questions/favorite', question: @question) %>")

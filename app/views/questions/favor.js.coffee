$(document).ready ->
  $('.question-favoring').html("<%= escape_javascript render('questions/favouring', question: @question) %>")

  window.fixes()

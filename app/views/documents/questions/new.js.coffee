$(document).ready ->
  $('#document-content').replaceWith("<%= escape_javascript render('documents/questions/new', question: @question) %>")

  fixes()

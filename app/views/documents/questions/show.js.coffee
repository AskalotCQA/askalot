$(document).ready ->
  $('#document-content').replaceWith("<%= escape_javascript render('documents/questions/show', question: @question) %>")

  fixes()

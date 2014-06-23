$(document).ready ->
  $('#document-content').replaceWith("<%= escape_javascript render('documents/questions/questions', questions: @questions) %>")

  fixes()

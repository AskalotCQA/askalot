$(document).ready ->
  $('#question-filter').replaceWith("<%= escape_javascript render('filter') %>")
  $('#question-controls').replaceWith("<%= escape_javascript render('controls') %>")
  $('#questions').replaceWith("<%= escape_javascript render('questions', questions: @questions) %>")

  fixes()

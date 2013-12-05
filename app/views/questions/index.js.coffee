$(document).ready ->
  $('#questions-filter').replaceWith("<%= escape_javascript render('filter') %>")
  $('#questions-controls').replaceWith("<%= escape_javascript render('controls') %>")
  $('#questions').replaceWith("<%= escape_javascript render('questions', questions: @questions) %>")

  fixes()

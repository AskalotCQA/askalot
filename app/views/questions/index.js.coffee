$(document).ready ->
  $('#questions-controls').replaceWith("<%= escape_javascript render('controls') %>")
  $('#questions').replaceWith("<%= escape_javascript render('questions', questions: @questions) %>")

  Form.of('#filter_questions').setParams(<%= raw params.slice(:tab, :poll).to_json %>)

  fixes()

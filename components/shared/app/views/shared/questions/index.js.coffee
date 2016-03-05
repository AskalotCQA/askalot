$(document).ready ->
  $('#flash').remove()
  $('body > .container, body > .container-fluid').prepend("<%= escape_javascript flash_messages %>")
  $('#questions-controls').replaceWith("<%= escape_javascript render('controls') %>")
  $('#questions').replaceWith("<%= escape_javascript render('questions', questions: @questions, remote: true) %>")

  Form.of('#filter_questions').setParams(<%= raw params.slice(:tab, :poll).to_json %>)

  fixes()

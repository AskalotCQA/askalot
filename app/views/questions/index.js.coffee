$(document).ready ->
  $('#questions').replaceWith("<%= escape_javascript render('questions', questions: @questions) %>")

  Form.of('#filter_questions').set(<%= raw params.slice(:tab).to_json %>)

  fixes()

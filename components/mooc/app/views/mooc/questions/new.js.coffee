$(document).ready ->
  $('#form-messages').html('<%= escape_javascript render("shared/errors/form_messages", resource: @question) %>')

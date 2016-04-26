$(document).ready ->
  $('#form-messages').html('<%= escape_javascript render("errors/form_messages", resource: @question) %>')

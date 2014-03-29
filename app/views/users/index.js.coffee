$(document).ready ->
  $('#flash').remove()
  $('body > .container').prepend("<%= escape_javascript flash_messages %>")
  $('#users').replaceWith("<%= escape_javascript render('users', users: @users) %>")

  fixes()

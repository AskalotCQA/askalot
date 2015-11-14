$(document).ready ->
  $('#flash').remove()
  $('body > .container').prepend("<%= escape_javascript flash_messages %>")
  $('#tags').replaceWith("<%= escape_javascript render('tags', tags: @tags, remote: true) %>")

  fixes()

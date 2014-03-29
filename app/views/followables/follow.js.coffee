$(document).ready ->
  $('#user-<%= @followee.id %>-following').replaceWith("<%= escape_javascript render('followables/following', followee: @followee) %>")

  fixes()

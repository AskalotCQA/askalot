$(document).ready ->
  $('#user-<%= @followee.id %>-following').replaceWith("<%= escape_javascript render('followables/following', model: :user, followable: @followee) %>")

  fixes()

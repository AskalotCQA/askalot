$(document).ready ->
  $('#user-<%= @followee.id %>-following').replaceWith("<%= escape_javascript render('shared/followables/following', model: :user, followable: @followee) %>")

  fixes()

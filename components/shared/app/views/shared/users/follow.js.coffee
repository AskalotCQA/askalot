$(document).ready ->
  $('#user-<%= @followee.id %>-following').replaceWith("<%= escape_javascript render('university/followables/following', model: :user, followable: @followee) %>")

  fixes()

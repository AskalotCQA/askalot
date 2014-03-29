$(document).ready ->
  $('#user-<%= @followee.id %>-following').replaceWith("<%= escape_javascript render('followables/following', followee: @followee) %>")
  $('#profile-<%= @followee.id %>-following').replaceWith("<%= escape_javascript render('followables/following_profile', followee: @followee) %>")
  fixes()

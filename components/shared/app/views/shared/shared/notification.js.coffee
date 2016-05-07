$(document).ready ->
  $('#dropdown-notification-<%= @notification.id %>').replaceWith("<%= escape_javascript render('shared/shared/notification', notification: @notification) %>")

  fixes()

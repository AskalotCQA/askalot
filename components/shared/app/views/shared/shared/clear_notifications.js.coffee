$(document).ready ->
  <% @notifications.each do |notification| %>
    $('#dropdown-notification-<%= notification.id %>').replaceWith("<%= escape_javascript render('shared/shared/notification', notification: notification) %>")
  <% end %>

  fixes()

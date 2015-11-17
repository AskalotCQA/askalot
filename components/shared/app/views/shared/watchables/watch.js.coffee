$(document).ready ->
  $('#<%= @model %>-<%= @watchable.id %>-watching').replaceWith("<%= escape_javascript render('university/watchables/watching', model: @model, watchable: @watchable) %>")

  fixes()

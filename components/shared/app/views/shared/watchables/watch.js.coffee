$(document).ready ->
  $('#<%= @model %>-<%= @watchable.id %>-watching').replaceWith("<%= escape_javascript render('shared/watchables/watching', model: @model, watchable: @watchable) %>")

  fixes()

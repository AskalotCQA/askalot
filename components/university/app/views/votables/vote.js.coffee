$(document).ready ->
  $('#<%= @model %>-<%= @votable.id %>-voting').replaceWith("<%= escape_javascript render('votables/voting', model: @model, votable: @votable) %>")

  fixes()

$(document).ready ->
  $('#<%= @model %>-<%= @votable.id %>-voting').replaceWith("<%= escape_javascript render('shared/votables/voting', model: @model, votable: @votable) %>")

  fixes()

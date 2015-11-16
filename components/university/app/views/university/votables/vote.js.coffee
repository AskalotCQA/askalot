$(document).ready ->
  $('#<%= @model %>-<%= @votable.id %>-voting').replaceWith("<%= escape_javascript render('university/votables/voting', model: @model, votable: @votable) %>")

  fixes()

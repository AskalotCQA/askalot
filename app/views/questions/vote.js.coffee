$(document).ready ->
  $('#question-<%= @votable.id %>-voting').replaceWith("<%= escape_javascript render('questions/voting', question: @votable) %>")
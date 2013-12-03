$(document).ready ->
  $('#answer-<%= @votable.id %>-voting').replaceWith("<%= escape_javascript render('answers/voting', answer: @votable) %>")
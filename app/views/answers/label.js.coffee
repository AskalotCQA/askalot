$(document).ready ->
  $('#answer-<%= @answer.id %>-labeling').replaceWith("<%= escape_javascript render('answers/labeling', answer: @answer) %>")

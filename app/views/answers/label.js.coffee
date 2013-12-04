$(document).ready ->
  <% @answers.each do |answer| %>
    $('#answer-<%= answer.id %>-labeling').replaceWith("<%= escape_javascript render('answers/labeling', answer: answer) %>")
  <% end %>

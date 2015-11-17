$(document).ready ->
  <% @answers.each do |answer| %>
    $('#answer-<%= answer.id %>-labeling').replaceWith("<%= escape_javascript render('shared/answers/labeling', answer: answer) %>")
  <% end %>

  fixes()

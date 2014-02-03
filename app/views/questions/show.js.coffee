$(document).ready ->
  <% @answers = @question.answers_ordered %>
  $('#answers').replaceWith("<%= escape_javascript render('questions/answers', answers: @answers) %>")

  fixes()

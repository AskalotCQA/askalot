$(document).ready ->
  $('#question-answers').replaceWith("<%= escape_javascript render('questions/answers', answers: @question.answers_ordered) %>")

  fixes()

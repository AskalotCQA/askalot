$(document).ready ->
  $('#document-content').replaceWith("<%= escape_javascript render('documents/questions/new', question: @question) %>")

  $('.well-active').attr class: 'well'
  $('#document-<%= @document.id %>').attr class: 'well well-active'

  fixes()

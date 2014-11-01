$(document).ready ->
  $('#document-content').replaceWith("<%= escape_javascript render('documents/questions/questions', questions: @questions) %>")

  $('.well-active').attr class: 'well'
  $('#document-<%= @document.id %>').attr class: 'well well-active'
  $('#document-content').css 'margin-top', $('#document-<%= @document.id %>').position().top

  fixes()

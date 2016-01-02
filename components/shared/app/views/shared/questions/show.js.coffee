$(document).ready ->
  $('#document-content').replaceWith("<%= escape_javascript render('university/documents/questions/show', question: @question) %>")

  $('.well-active').attr class: 'well'
  $('#document-<%= @question.document_id %>').attr class: 'well well-active'
  $('#document-content').css 'margin-top', $('#document-<%= @question.document_id %>').position().top

  $('.modal-backdrop').remove()

  $('#flash').remove()
  $('#main').prepend("<%= escape_javascript render('shared/shared/flash_messages', messages: flash_to_messages) %>")

  fixes()

  new Select()

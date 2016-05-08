$('#new-unit-question-title, #new-unit-forum-title').click ->
  type_id = String $(this).data('default-question-type-id')

  $('#new_question').slideToggle() unless $('#new_question').is(":visible") && $('#question_question_type_id').val() != type_id
  $('#question_question_type_id').select2 'val', type_id

$('#new-unit-question-title').click ->
  $('#new_question').slideToggle()

$('#unit-view #new_question').submit ->
  lockoutSubmit($(this).find('button[type=submit]'))

lockoutSubmit = (button) ->
  oldValue = button.text()
  button.attr('disabled', true)
  button.text('...processing...')

  setTimeout (->
    button.text(oldValue)
    button.removeAttr('disabled')
    return
  ), 2000
  return

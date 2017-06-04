$('.treetable').on 'click', '.treetable-expander', ->
  id = $(this).data 'id'

  if $(this).hasClass 'treetable-expander-expanded'
    $(this).removeClass 'treetable-expander-expanded'
    $(this).addClass 'treetable-expander-collapsed'
    $('.treetable-parent-' + id).hide()
  else
    $(this).removeClass 'treetable-expander-collapsed'
    $(this).addClass 'treetable-expander-expanded'
    $('.treetable-parent-' + id).show()

$('.treetable').on 'click', '.treetable-checkbox', (e) ->
  id = $(this).val()
  name = $(this).attr 'name'
  checked = $(this).prop 'checked'

  if (e.ctrlKey)
    $('.treetable-parent-' + id + ' input[name="' + name + '"]').prop 'checked', checked

$('.treetable .default-collapsed .treetable-expander').each (index, element) ->
  id = $(element).data 'id'
  $(element).removeClass 'treetable-expander-expanded'
  $(element).addClass 'treetable-expander-collapsed'
  $('.treetable-parent-' + id).hide()
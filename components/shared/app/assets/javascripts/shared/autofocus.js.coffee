$(document).ready ->
  for element in $('[data-collapse-autofocus]')
    $("#{$(element).attr('data-target')}").on 'shown.bs.collapse', (e) ->
      e.preventDefault()
      $(this).find("textarea:first").focus()

  for element in $('[data-click-focus]')
    $(element).on 'click', (e) ->
      e.preventDefault()
      $("#{$(this).attr('data-click-focus')}").focus()
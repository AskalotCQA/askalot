$(document).ready ->
  $('#question-filter').on 'change', ->
    $(this).closest('form').submit()

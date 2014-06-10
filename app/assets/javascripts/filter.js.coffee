$(document).ready ->
  $('#fulltext-search').hide()

  $('.filter-button').click (event) ->
    event.preventDefault()
    $('#filtered-search').show()
    $('#fulltext-search').hide()

  $('.fulltext-button').click (event) ->
    event.preventDefault()
    $('#filtered-search').hide()
    $('#fulltext-search').show()

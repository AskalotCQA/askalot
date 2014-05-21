$(document).ready ->
  $('.collapse').collapse({ toggle: false })
  $('#filtered-search').collapse('show')

  $('.filter-button').click (event) ->
    event.preventDefault()
    $('#filtered-search').collapse('show')
    $('#fulltext-search').collapse('hide')

  $('.fulltext-button').click (event) ->
    event.preventDefault()
    $('#fulltext-search').collapse('show')
    $('#filtered-search').collapse('hide')

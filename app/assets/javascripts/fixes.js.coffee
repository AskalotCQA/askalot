$(document).ready ->
  window.defined = (value) ->
    typeof(value) != 'undefined'

  window.fixes = ->
    $('[data-toggle="popover"]').popover()
    $('[data-toggle="tooltip"]').tooltip()

    $('a[href="#"]').click (event) ->
      event.preventDefault()

  fixes()

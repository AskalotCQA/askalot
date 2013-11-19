$(document).ready ->
  window.defined = (value) ->
    typeof(value) != 'undefined'

  window.fixes = ->
    $('[data-toggle="popover"]').popover()
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')
    $('a[href="#"]').click (event) ->
      event.preventDefault()

  fixes()

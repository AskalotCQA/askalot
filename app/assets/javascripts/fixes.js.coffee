$(document).ready ->
  window.defined = (value) ->
    typeof(value) != 'undefined'

  window.fixes = ->
    $('[data-toggle="popover"]').popover()
    $('[data-toggle="tooltip"]').tooltip()

    $('a[href="#"]').click (event) ->
      event.preventDefault()

  window.fixTabs = ->
    $('a[data-toggle="pill"]').click (e) -> e.preventDefault()

    $('a[data-toggle="pill"]').on 'shown', (e) ->
      e.preventDefault()

      hash = $(e.target).attr('href')

      $('body').trigger(window.hashChangeEvent, hash)

    if location.hash != ''
      hash = window.getHash()
      selector = "a[href='#{hash}']"

      if $(selector).length > 0
        $(selector).tab('show')

  fixTabs()
  fixes()

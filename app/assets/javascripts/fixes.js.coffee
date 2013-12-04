#= require hash

$(document).ready ->
  window.defined = (value) ->
    typeof(value) != 'undefined'

  window.fixes = ->
    $('[data-toggle="popover"]').popover(container: 'body')
    $('[data-toggle="tooltip"]').tooltip(container: 'body')
    $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')
    $('a[href="#"]').click (event) ->
      event.preventDefault()

  window.fixTabs = ->
    $('a[data-toggle="pill"]').click (e) -> e.preventDefault()

    $('a[data-toggle="pill"]').on 'shown.bs.tab', (e) ->
      e.preventDefault()

      hash = $(e.target).attr('href')

      $('body').trigger(window.hashChangeEvent, hash)

    if location.hash != ''
      hash     = window.getHash()
      selector = "a[href='#{hash}']"

      if $(selector).length > 0
        $(selector).tab('show')

  # fixTabs()
  fixes()

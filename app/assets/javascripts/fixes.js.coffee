#= require hash

$(document).ready ->
  window.defined = (value) ->
    typeof(value) != 'undefined'

  window.fixes = ->
    $('[data-toggle="popover"]').popover()
    $('[data-toggle="tooltip"]').tooltip(container: 'body')
    $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')

    # TODO(zbell) refactor and fix properly
    $('a[data-toggle="tooltip"]').on 'click', ->
      $(this).tooltip(container: false, delay: { hide: 0 })
      $(this).tooltip('destroy')

    $('a[href="#"]').click (event) -> event.preventDefault()

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

  # TODO (smolnar) resolve
  # fixTabs()
  fixes()

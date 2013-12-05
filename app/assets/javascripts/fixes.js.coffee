#= require hash
#= require remote
#= require select

window.defined = (value) ->
  typeof(value) != 'undefined'

window.fixes = ->
  Remote.bindState()

  $('[data-toggle="popover"]').popover(container: 'body')
  $('[data-toggle="tooltip"]').tooltip(container: 'body')
  $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')

  # TODO(zbell) refactor and fix properly
  $('a[data-toggle="tooltip"]').on 'click', ->
    $(this).tooltip(container: false, delay: { hide: 0 })
    $(this).tooltip('destroy')

  $('a[href="#"]').click (event) -> event.preventDefault()

  new Select()

$(document).ready ->
  fixes()

  # TODO (smolnar) resolve automatic fixes callback for ajax requests
  # $(document).on 'ajax:success', '[data-remote=true]', -> fixes()

#= require hash
#= require remote

window.defined = (value) ->
  typeof(value) != 'undefined'

window.fixes = ->
  Remote.bindState()

  $('[data-toggle="popover"]').popover(container: 'body')
  $('[data-toggle="tooltip"]').tooltip(container: 'body')
  $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')
  $('a[href="#"]').click (event) ->
    event.preventDefault()

$(document).ready ->
  fixes()

  # TODO (smolnar) resolve automatic fixes callback for ajax requests
  $(document).on 'ajax:success', '[data-remote=true]', -> fixes()

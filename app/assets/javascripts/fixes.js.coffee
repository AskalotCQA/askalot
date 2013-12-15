#= require hash
#= require remote
#= require select
#= require poll

Remote.bindState()

window.defined = (value) ->
  typeof(value) != 'undefined'

window.fixes = ->
  Remote.initialize()
  Poll.initialize()


  $('[data-time-ago]').timeago()
  $('[data-toggle="popover"]').popover(container: 'body')
  $('[data-toggle="tooltip"]').tooltip(container: 'body')
  $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')

  # TODO(zbell) refactor and fix properly
  $('a[data-toggle="tooltip"]').on 'click', ->
    $(this).tooltip(container: false, delay: { hide: 0 })
    $(this).tooltip('destroy')

  $('a[href="#"]').click (event) -> event.preventDefault()

$(document).ready ->
  fixes()

  # TODO (smolnar) resolve automatic fixes callback for ajax requests
  # $(document).on 'ajax:success', '[data-remote=true]', -> fixes()

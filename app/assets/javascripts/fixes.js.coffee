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

  $('.popover').remove()
  $('.tooltip').remove()

  $('[data-time-ago]').timeago()

  $('[data-toggle="buttons"] [checked="checked"]').parent().addClass('active')
  $('[data-toggle="popover"]').popover(container: 'body')
  $('[data-toggle="tooltip"]').tooltip(container: 'body')
  $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')

  # TODO(zbell) refactor lol
  $('[data-toggle="buttons"] label').on 'click', ->
    icon = $(this).find('.fa')

    if $(this).hasClass('active')
      icon.removeClass('fa-check').addClass('fa-blank')
    else
      icon.removeClass('fa-blank').addClass('fa-check')

  # TODO(zbell) refactor and fix properly
  $('a[data-toggle="tooltip"]').on 'click', ->
    $(this).tooltip(container: false, delay: { hide: 0 })
    $(this).tooltip('destroy')

  $('a[href="#"]').click (event) -> event.preventDefault()

$(document).ready ->
  fixes()

  # TODO (smolnar) resolve automatic fixes callback for ajax requests
  # $(document).on 'ajax:success', '[data-remote=true]', -> fixes()

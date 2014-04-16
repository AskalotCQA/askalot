#= require hash
#= require remote
#= require date
#= require select
#= require poll
#= require markdown
#= require hash

Remote.bindState()

# Shorthand for HandlebarsTemplates
window.templates = HandlebarsTemplates

window.defined = (value) ->
  typeof(value) != 'undefined'

window.fixes = ->
  Remote.initialize()
  Poll.initialize()
  Markdown.bind()
  Hash.bind()

  $('.popover').remove()
  $('.tooltip').remove()

  $('[data-spy="affix"]').affix(offset: { top: 52 })

  $('[data-time-ago]').timeago()

  $('[data-toggle="buttons"] [checked="checked"]').parent().addClass('active')
  $('[data-toggle="popover"]').popover(container: 'body')
  $('[data-toggle="tooltip"]').tooltip(container: 'body')
  $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')

  $('[data-toggle="buttons"] label').on 'click', ->
    icon = $(this).find('.fa')

    if $(this).hasClass('active')
      icon.removeClass('fa-check').addClass('fa-blank')
    else
      icon.removeClass('fa-blank').addClass('fa-check')

  $('a[data-toggle="tooltip"]').on 'click', ->
    $(this).tooltip(container: false, delay: { hide: 0 })
    $(this).tooltip('destroy')

  $('a[href="#"]').click (event) -> event.preventDefault()

$(document).ready ->
  fixes()

  # TODO (smolnar) resolve automatic fixes callback for ajax requests
  # $(document).on 'ajax:success', '[data-remote=true]', -> fixes()

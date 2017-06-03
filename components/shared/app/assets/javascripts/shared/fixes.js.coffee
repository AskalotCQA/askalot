#= require ./hash
#= require ./remote
#= require ./date
#= require ./select
#= require ./poll
#= require ./markdown
#= require ./hash

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
  Analytics.bind()

  moment_locale = if (window.navigator.userLanguage || window.navigator.language == 'sk') then 'sk' else 'en_gb'

  moment.locale(moment_locale)

  $('.popover').remove()
  $('.tooltip').remove()

  $('[data-spy="affix"]').affix(offset: { top: 52 })

  $('[data-time-ago]').timeago()

  $('[data-toggle="buttons"] [checked="checked"]').parent().addClass('active')
  $('[data-toggle="popover"]').popover(container: 'body')
  $('[data-toggle="tooltip"]').tooltip(container: 'body')

  # To bind tooltip also for dynamically created elements (e.g. in select2 for category selection)
  $('body').tooltip({
    selector: '[data-toggle="tooltip"]',
    container: 'body'
  })

  $('[data-toggle="tooltip"]').on 'show.bs.tooltip', -> $(this).removeAttr('title')

  $('[data-toggle="buttons"] label').on 'click', ->
    icon = $(this).find('.fa')

    if $(this).hasClass('active')
      icon.removeClass('fa-check-square-o').addClass('fa-square-o')
    else
      icon.removeClass('fa-square-o').addClass('fa-check-square-o')

  $('a[data-toggle="tooltip"]').on 'click', ->
    $(this).tooltip(container: false, delay: { hide: 0 })
    $(this).tooltip('destroy')

  $('[data-toggle="collapse"][data-collapse-after="hide"]').click -> $(this).hide()

  $('a[href="#"]').click (event) -> event.preventDefault()

  $('a[data-scroll]').click (event) ->
    $('html, body').animate(scrollTop: $($(this).attr('data-scroll')).offset().top, 400)

  $('a[data-fade]').click ->
    Effects.fadeOnFilter($(this).attr('data-fade'))

  $('form:not([data-remote="true"])').submit (event) ->
    $(this).find('[type=submit]').prop('disabled', true);

$(document).ready ->
  fixes()

  # TODO (smolnar) resolve automatic fixes callback for ajax requests
  # $(document).on 'ajax:success', '[data-remote=true]', -> fixes()

class window.Effects extends window.Module
  @fadeOnFilter: (selector, options) ->
    $(selector).find('a').click (e) -> e.preventDefault()
    $(selector).find('a').addClass('disabled')

    $(selector).fadeTo('slow', options?.duration || 0.25)

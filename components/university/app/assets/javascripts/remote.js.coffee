#= require lib/module

class window.Remote extends Module
  @initialize: ->
    $('[data-remote]').each (_, element) ->
      $(element).attr('data-type', 'script') unless $(element).attr('data-type')

  @bindState: (callback) ->
    window.onpopstate = (event) -> window.location = document.location if event.state?

    $(document).on 'click submit', '[data-state=true]', (e) ->
      element = $(this)

      if element.is 'form'
        location = "#{element.attr('action')}?#{element.serialize()}"
      else
        location = element.attr 'href'

      callback?($(this))

      window.history.pushState state: true, null, location

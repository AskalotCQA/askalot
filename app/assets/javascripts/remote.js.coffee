#= require core/module

# TODO (smolnar) fix navigation back/forward by onpopstate event

$(document).ready ->
  class window.Remote extends Module
    @setup: ->
      $('[data-remote]').each (_, element) ->
        $(element).attr('data-type', 'script') unless $(element).attr('data-type')

    @bindState: (callback) ->
      $(document).on 'click submit', '[data-state=true]', (e) ->
        element = $(this)

        if element.is 'form'
          location = "#{element.attr('action')}?#{element.serialize()}"
        else
          location = element.attr 'href'

        callback?($(this))

        window.history.pushState state: true, null, location

#= require core/module

$(document).ready ->
  class window.Remote extends Module
    @bindState: (callback) ->
      $(document).on 'click submit', '[data-state=true]', (e) ->
        element = $(this)

        if element.is 'form'
          location = "#{element.attr('action')}?#{element.serialize()}"
        else
          location = element.attr 'href'

        callback?($(this))

        window.history.pushState {}, null, location

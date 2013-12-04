#= require core/module

$(document).ready ->
  class window.Remote extends Module
    @bindState: ->
      $(document).on 'click submit', '[data-state=true]', ->
        element = $(this)

        if element.is 'form'
          location = "#{element.attr('action')}?#{element.serialize()}"
        else
          location = element.attr 'href'

        window.history.pushState {}, null, location

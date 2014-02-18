#= require lib/module

class window.Poll extends Module
  @initialize: ->
    $(document).ready ->
      $('[data-poll]').each (_, element) ->
        seconds = parseInt($(element).attr('data-poll'))

        seconds = 5 unless seconds > 0
        location = $(element).attr('data-rel')

        setTimeout (-> $(element).attr('href', location).trigger('click') if jQuery.active == 0), seconds * 1000

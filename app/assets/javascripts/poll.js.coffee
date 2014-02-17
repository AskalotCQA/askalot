#= require lib/module

class window.Poll extends Module
  @initialize: ->
    $(document).ready ->
      $('[data-poll]').each (_, element) ->
        seconds = parseInt($(element).attr('data-poll'))

        seconds = 5 unless seconds > 0
        location = $(element).attr('data-rel')

        setTimeout (-> $(element).attr('href', location).trigger('click') unless jQuery.active), seconds * 1000

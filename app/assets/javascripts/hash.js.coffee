class window.Hash
  @bind: ->
    $(document).ready ->
      $(window).on 'hashchange', ->
        Hash.normalizePosition()

  @on: (regex, callback) ->
    if matches = window.location.hash.match(regex)
      callback(matches)

      Hash.normalizePosition()

  @normalizePosition: ->
    $(document).ready ->
      setTimeout (-> $(window).scrollTop($(window).scrollTop() - 51)), 100

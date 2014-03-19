class window.Hash
  @callbacks: []

  @bind: ->
    $(document).ready ->
      $(window).on 'hashchange', ->
        callback() for callback in Hash.callbacks

        Hash.normalizePosition()

  @on: (regex, callback) ->
    another = ->
      callback(matches) if matches = window.location.hash.match(regex)

    another()

    Hash.callbacks.push(another)

  @normalizePosition: ->
    $(document).ready ->
      setTimeout (-> $(window).scrollTop($(window).scrollTop() - 51)), 100

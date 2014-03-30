class window.Hash
  @callbacks: []

  @bind: ->
    $(document).ready ->
      $(window).on 'hashchange', ->
        callback() for callback in Hash.callbacks

  @on: (regex, callback) ->
    another = ->
      callback(matches) if matches = window.location.hash.match(regex)

    another()

    Hash.callbacks.push(another)

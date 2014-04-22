class window.Helper
  @highlight: (selector) ->
    $(selector).addClass('highlight-content', 250, -> $(selector).removeClass('highlight-content', 1750))

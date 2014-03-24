class window.Helper
  @highlight: (selector) ->
    $(selector).addClass('bg-warning', 200, -> $(selector).removeClass('bg-warning', 2000))

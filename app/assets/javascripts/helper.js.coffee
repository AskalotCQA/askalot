class window.Helper
  @highlight: (selector) ->
    $(selector).addClass('bg-warning', 100, 'easeInOutQuad')
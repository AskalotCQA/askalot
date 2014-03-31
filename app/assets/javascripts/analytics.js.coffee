$(document).ready ->
  $('[data-track]').click ->
    label = $(this).attr 'data-track'
    category = $(this).attr 'data-track-category'
    action = $(this).attr 'data-track-action'
    _gaq.push ['_trackEvent', category, action, label]

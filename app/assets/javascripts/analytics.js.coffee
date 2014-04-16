$(document).ready ->
  $('[data-track-label]').click ->
    label = $(this).attr 'data-track-label'
    category = $(this).attr 'data-track-category'
    action = $(this).attr 'data-track-action'
    _gaq.push ['_trackEvent', category, action, label]

$(document).ready ->
  $('[data-track-action]').click ->
    action   = $(this).attr 'data-track-action'
    category = $(this).attr 'data-track-category'

    if $(this).attr 'data-track-label'
      label = $(this).attr 'data-track-label'
    else
       $(this).attr 'id' ? label = $(this).attr 'id' : label = nil

    _gaq.push ['_trackEvent', category, action, label]

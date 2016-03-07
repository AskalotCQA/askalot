$(document).ready ->
  $('#context-change select').change ->
    # window.location.href = $(this).find(':selected').data('url')
    # TODO (ladislav.gallay) passing url did not work

    parts = window.location.href.split '/'
    parts[3] = $(this).val()
    window.location.href = parts.join '/'

$(document).ready ->
  $('#context-change select').change ->
    # window.location.href = $(this).find(':selected').data('url')
    # TODO (ladislav.gallay) passing url did not work

    current_context = '/' + $('#context-change').data('current') + '/'
    new_context = '/' + $(this).val() + '/'
    window.location.href = window.location.href.replace current_context, new_context

$(document).ready ->
  $('#context-change select').change ->
    current_context = '/' + $('#context-change').data('current') + '/'
    new_context = '/' + $(this).val() + '/'
    window.location.href = window.location.href.replace current_context, new_context

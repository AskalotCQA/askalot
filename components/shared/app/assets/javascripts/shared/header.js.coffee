$(document).ready ->
  $('#context-change select').change ->
    window.location.href = $(this).val()

$(document).ready ->
  window.languageChange = (e) ->
    window.location.href = $('#language-picker').val()

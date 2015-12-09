$('#login-url').ready ->
  url = $('#login-url').attr('href')

  setTimeout (-> window.top.location.href = url), 5000 if url != undefined

$('#askalot-url').ready ->
  url = $('#askalot-url').attr('href')

  window.top.location.href = url if url != undefined

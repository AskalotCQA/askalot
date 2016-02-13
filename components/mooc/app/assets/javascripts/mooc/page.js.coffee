$(document).ready ->
  url = $('#login-url').attr('href')

  setTimeout (-> window.top.location.href = url + '?forced_login=true'), 5000 if url != undefined

  parentIFrame.sendMessage('checkForcedLogin') if ('parentIFrame' in window)

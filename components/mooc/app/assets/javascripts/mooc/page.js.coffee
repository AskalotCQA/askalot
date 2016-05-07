$(document).ready ->
  url = $('#login-url').attr('href')
  url = url.replace(/%20/g, '+').replace(/\s/g, '+') if url

  setTimeout (-> window.top.location.href = url), 5000 if url != undefined

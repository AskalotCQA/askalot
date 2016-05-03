$(document).ready ->
  url = $('#login-url').attr('href').replace(/%20/g, '+').replace(/\s/g, '+')

  setTimeout (-> window.top.location.href = url), 5000 if url != undefined

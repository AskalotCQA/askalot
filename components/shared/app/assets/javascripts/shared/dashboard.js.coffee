if window.opener
  if window.opener.document.getElementById('facebook-joining') != null
    window.opener.location.reload true
    window.close()

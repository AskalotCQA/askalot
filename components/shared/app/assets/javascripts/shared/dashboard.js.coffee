if window.opener
  location = window.opener.location.href
  whitelisted = location.indexOf('/third_party') != -1 || location.indexOf('/administration') != -1 || location.indexOf('/facebook/') != -1

  unless whitelisted
    window.opener.location.reload true
    window.close()

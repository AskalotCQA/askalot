getCookie = (cname) ->
  name = cname + '='
  ca = document.cookie.split(';')
  i = 0
  while i < ca.length
    c = ca[i]
    while c.charAt(0) == ' '
      c = c.substring(1)
    if c.indexOf(name) == 0
      return c.substring(name.length, c.length)
    i++
  ''

sendCheckForcedLogin = ->
  setTimeout ->
    cookieSet = getCookie('askalot_signed_in') == '1'
    pageUrlPresent = $('meta[name=askalot]').data('page-url') != ''

    parentIFrame.sendMessage type: 'checkForcedLogin', pageUrl: $('meta[name=askalot]').data('page-url') if cookieSet && pageUrlPresent

    unless cookieSet
      $('.cookies_not_enabled').show()
      $('#main > *').not('.cookies_not_enabled').hide()
  , 1000

window.iFrameResizer =
  readyCallback: ->
    if 'parentIFrame' of window
      sendCheckForcedLogin() if window.location.pathname.indexOf('/units') != -1
      parentIFrame.sendMessage type: 'unreadNotifications', count: $('meta[name=askalot]').data('unread-notifications')

      if window.location.pathname.indexOf('/units') == -1
        parentIFrame.sendMessage
          type: 'reflectUrl'
          data: window.location.pathname

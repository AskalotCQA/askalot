window.iFrameResizer =
  readyCallback: ->
    if 'parentIFrame' of window
      parentIFrame.sendMessage type: 'checkForcedLogin', pageUrl: $('meta[name=askalot]').data('page-url')
      parentIFrame.sendMessage type: 'unreadNotifications', count: $('meta[name=askalot]').data('unread-notifications')

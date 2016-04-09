window.iFrameResizer =
  readyCallback: ->
    parentIFrame.sendMessage(type: 'checkForcedLogin') if 'parentIFrame' of window
    parentIFrame.sendMessage type: 'unreadNotifications', count: $('meta[name=askalot]').data('unread-notifications')

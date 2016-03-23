window.iFrameResizer =
  readyCallback: ->
    parentIFrame.sendMessage(type: 'checkForcedLogin') if 'parentIFrame' of window


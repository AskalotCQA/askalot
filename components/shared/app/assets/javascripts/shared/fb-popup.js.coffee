popupCenter = (url, width, height, name) ->
  left = screen.width / 2 - (width / 2)
  top = screen.height / 2 - (height / 2)
  window.open url, name, 'menubar=no,toolbar=no,status=no,width=' + width + ',height=' + height + ',toolbar=no,left=' + left + ',top=' + top

$('a.popup').click (e) ->
  popupCenter $(this).attr('href'), $(this).attr('data-width'), $(this).attr('data-height'), 'authPopup'
  e.stopPropagation()
  false

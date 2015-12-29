$('nav .course-tabs li:contains(Discussion)').hide()

$(document).ready ->
  getURLParameter = (name) ->
    decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) or [null, ''])[1].replace(/\+/g, '%20')) or null

  a_src = 'http://localhost:3000/questions?utf8=%E2%9C%93&amp;tab=recent&amp;poll=true'
  redirect_url = getURLParameter('redirect')
  a_src +=  if redirect_url then '&amp;redirect=' + redirect_url else null

  $('<iframe>Your browser does not support iframes!</iframe>')
    .attr('title', 'Askalot')
    .attr('src', a_src)
    .attr('width', '100%')
    .attr('height', '600')
    .attr('marginwidth', '0')
    .attr('marginheight', '0')
    .attr('frameborder', '0')
    .appendTo('#askalot-wrapper')

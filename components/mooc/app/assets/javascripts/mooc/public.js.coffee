$('nav .course-tabs li:contains(Discussion)').hide();

$(document).ready - >
  a_src = 'http://localhost:3000/questions';
  a_src += getURLParameter('redirect') ? '?&amp;redirect=' + getURLParameter('redirect') : null;

$('<iframe>Your browser does not support iframes!</iframe>')
  .attr('title', 'Askalot')
  .attr('src', a_src)
  .attr('width', '100%')
  .attr('height', '600')
  .attr('marginwidth', '0')
  .attr('marginheight', '0')
  .attr('frameborder', '0')
  .appendTo('#askalot-wrapper')

getURLParameter = (name) - >
  decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [, ""])[1].replace(/\+/g, '%20')) || null


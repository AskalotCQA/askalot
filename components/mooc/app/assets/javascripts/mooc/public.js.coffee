#= require iframeResizer.min.js

# Parse host name to askalot
host = document.querySelector('script[src$="assets/mooc/public.js"]')

if (host == null)
  for element in document.getElementsByTagName('pre')
    if element.innerHTML.indexOf('assets/mooc/public.js') > -1
      host = element.innerHTML.replace('&lt;script src="', '').replace('assets/mooc/public.js"&gt;&lt;/script&gt;', '')
else
  host = host.getAttribute('src').replace('assets/mooc/public.js', '')

# Check if on global or unit view
is_global = document.getElementsByClassName('course-content')[0] == undefined

infoParser = ->
  url = window.location.href
  pathname = window.location.pathname
  parsed = pathname.split('/')
  tree = document.getElementsByClassName('button-chapter chapter active is-open')[0]
  subtree = document.getElementsByClassName('menu-item active')[0]
  p = subtree.getElementsByTagName('p')[0]
  clone = p.cloneNode(true)
  clone.removeChild(clone.children[0])
  unit = document.getElementsByClassName('xblock xblock-student_view xmodule_display xblock-initialized')[0]
  sequence = document.getElementById('sequence-list')
  unit_content = unit.getElementsByClassName('xblock xblock-student_view xmodule_display xblock-initialized')[0]
  ltis = document.getElementsByClassName('xblock-student_view-lti xmodule_LTIModule')
  lti_element = ltis[ltis.length - 1].getElementsByClassName('lti')[0]

  data =
    course_id: unit.getAttribute('data-course-id').trim()
    course_name: document.getElementsByClassName('course-name')[0].textContent.trim()
    section_id: parsed[parsed.length-3]
    section_name: tree.getElementsByClassName('group-heading active')[0].textContent.trim()
    subsection_id: parsed[parsed.length - 2]
    subsection_name: clone.textContent.trim(),
    unit_id: unit.getAttribute('data-usage-id')
    unit_name: sequence.getElementsByClassName('active')[0].getAttribute('data-page-title').trim()
    content: unit.innerHTML
    lti_id: lti_element.id.trim()

  name_element = $('#sequence-list .active')[0]

  if name_element
    data.unit_name = name_element.getAttribute('data-page-title').trim()

  data

$('nav .course-tabs li:contains(Discussion)').hide()

$(document).ready ->
  getURLParameter = (name) ->
    decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) or [null, ''])[1].replace(/\+/g, '%20')) or null

  a_src = host + 'questions?utf8=%E2%9C%93&amp;tab=recent&amp;poll=true'
  redirect_url = getURLParameter('redirect')
  a_src += if redirect_url then '&amp;redirect=' + redirect_url else null
  login_url = $('#login-url').text()
  a_src += '&amp;login_url=' + login_url if login_url != ''

  $('<iframe>Your browser does not support iframes!</iframe>')
    .attr('title', 'Askalot')
    .attr('src', a_src)
    .attr('width', '100%')
    .attr('height', '600')
    .attr('marginwidth', '0')
    .attr('marginheight', '0')
    .attr('frameborder', '0')
    .appendTo('#askalot-wrapper')

  iFrameResize({checkOrigin: false})

  if (!is_global)
    $.ajax
      type: 'POST'
      url: host + 'parser'
      dataType: 'json'
      data: infoParser()
      success: (data) ->
        console.dir data

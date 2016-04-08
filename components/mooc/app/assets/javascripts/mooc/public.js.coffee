#= require iframeResizer.min.js

host = document.querySelector('script[src$="assets/mooc/public.js"]')

if (host == null)
  host = $($('[aria-labelledby=' + $('#seq_content').attr('aria-labelledby') + '][aria-hidden=true')).text().match('script src=\"(.*)' + 'assets/mooc/public.js')[1]
  if (host == null)
    for element in document.getElementsByTagName('pre')
      if element.innerHTML.indexOf('assets/mooc/public.js') > -1
        host = element.innerHTML.replace('&lt;script src="', '').replace('assets/mooc/public.js"&gt;&lt;/script&gt;', '')
else
  host = host.getAttribute('src').replace('assets/mooc/public.js', '')

is_global = document.getElementsByClassName('course-content')[0] == undefined

courseUuid = ->
  uuid = $('.provider').first().text().trim() + '-' + $('.course-number').first().text().trim() + '-' + $('.course-name').first().text().trim()
  uuid.replace('/', '-').replace(/\s+/g, '-').replace(/[^\w\-]+/g, '').replace(/\-\-+/g, '-')

infoParser = ->
  url = window.location.href
  pathname = window.location.pathname
  parsed = pathname.split('/')
  tree = document.getElementsByClassName('button-chapter chapter active is-open')[0]
  subtree = document.getElementsByClassName('menu-item active')[0]
  p = subtree.getElementsByTagName('p')[0]
  clone = p.cloneNode(true)
  clone.removeChild(clone.children[0])
  subsection = document.getElementsByClassName('xblock xblock-student_view xmodule_display xblock-initialized')[0]
  sequence = document.getElementById('sequence-list')
  unit_content = subsection.getElementsByClassName('xblock xblock-student_view xmodule_display xblock-initialized')[0]
  ltis = document.getElementsByClassName('xblock-student_view-lti xmodule_LTIModule')
  lti_element = ltis[ltis.length - 1].getElementsByClassName('lti')[0]
  unit_id = $('#sequence-list a.active').attr('data-id')
  path = subsection.getElementsByClassName('path')[0].textContent.trim()

  data =
    course_id: courseUuid()
    course_name: document.getElementsByClassName('course-name')[0].textContent.trim()
    section_id: parsed[parsed.length-3]
    section_name: tree.getElementsByClassName('group-heading active')[0].textContent.trim()
    subsection_id: parsed[parsed.length - 2]
    subsection_name: clone.textContent.trim(),
    unit_id: unit_id.substr(unit_id.lastIndexOf('/') + 1)
    unit_name: path.substr(path.lastIndexOf('>') + 2)
    content: subsection.innerHTML
    lti_id: lti_element.id.trim()

$('nav .course-tabs li:contains(Discussion)').hide()

$(document).ready ->
  getURLParameter = (name) ->
    decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) or [null, ''])[1].replace(/\+/g, '%20')) or null

  a_src = host + courseUuid() + '/questions?utf8=%E2%9C%93&amp;tab=recent&amp;poll=true'
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

  iFrameResize({
    checkOrigin: false,
    inPageLinks: true,
    messageCallback: (data) ->
      switch data.message.type
        when 'checkForcedLogin'
          window.history.back() if window.location.href.indexOf('forced_login=true') > -1
        when 'unreadNotifications'
          if data.message.count
            data.message.count = '99+' if data.message.count > 99

            $notification = $('<span/>').text(data.message.count).css
              position: 'absolute'
              top: 0
              right: '-8px'
              'background-color': '#FF3030'
              color: '#FFF'
              'border-radius': '10px'
              width: '20px'
              height: '20px'
              'font-size': '12px'
              'text-align': 'center'
              'font-weight': 'bold'
              'text-align': 'center'

            $('nav .course-tabs li:contains(Askalot) a').first().css('position', 'relative').append($notification)
  })

  if (!is_global)
    $.ajax
      type: 'POST'
      url: host + '1/parser'
      dataType: 'json'
      data: infoParser()
      success: (data) ->
        console.dir data
      error: (data) ->
        console.dir data

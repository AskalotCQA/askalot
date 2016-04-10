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
  uuid = document.getElementsByClassName('xblock xmodule_display')[0].getAttribute('data-course-id').replace(/\//g, "-")

infoParser = ->
  course_id = courseUuid()
  pathname = window.location.pathname
  pathname_parsed = pathname.split('/')
  section_id = pathname_parsed[pathname_parsed.length-3]
  subsection_id = pathname_parsed[pathname_parsed.length - 2]

  course_name = document.getElementsByClassName('course-name')[0].textContent.trim()
  section_name = document.getElementsByClassName('button-chapter chapter active is-open')[0].getElementsByClassName('group-heading active')[0].textContent.trim()
  subsection_name = document.getElementsByClassName('menu-item active')[0].getElementsByTagName('p')[0].textContent.replace("current section", "").trim()

  unit_content = document.getElementsByClassName('xblock xblock-student_view xmodule_display xblock-initialized')[0]
  unit_element = document.getElementsByClassName('nav-item active')[0]
  unit_id = unit_element.getAttribute('data-id').substr(unit_element.getAttribute('data-id').lastIndexOf('/')+1).substr(unit_element.getAttribute('data-id').lastIndexOf('@')+1)

  unit_name = unit_element.getAttribute('data-path').substr(unit_element.getAttribute('data-path').lastIndexOf('>') + 2)

  lti_id = document.getElementsByClassName('lti')[0].getAttribute('id')

  data =
    course_id: course_id
    course_name: course_name
    section_id: section_id
    section_name: section_name
    subsection_id: subsection_id
    subsection_name: subsection_name,
    unit_id: unit_id
    unit_name: unit_name
    lti_id: lti_id
    content: unit_content.innerHTML

$('nav .course-tabs li:contains(Discussion)').hide()

$(document).ready ->
  getURLParameter = (name) ->
    decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) or [null, ''])[1].replace(/\+/g, '%20')) or null

  a_src = host + courseUuid() + '/questions?utf8=%E2%9C%93&amp;tab=recent&amp;poll=true'

  redirect_url = getURLParameter('redirect')
  if redirect_url
    redirect_url = redirect_url.replace('/default/', '/' + courseUuid() + '/')
    a_src += '&amp;redirect=' + redirect_url

  login_url = $('#login-url').text()
  a_src += '&amp;login_url=' + login_url if login_url != ''

  $("#askalot-wrapper").css("margin", "-32px -40px 0px -40px")

  $('<iframe>Your browser does not support iframes!</iframe>')
    .attr('title', 'Askalot')
    .attr('src', a_src)
    .attr('width', '100%')
    .attr('height', '600')
    .attr('marginwidth', '0')
    .attr('marginheight', '0')
    .attr('frameborder', '0')
    .attr('name', Date.now())
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
      url: host + courseUuid() +  '/parser'
      dataType: 'json'
      data: infoParser()
      success: (data) ->
        console.dir data
      error: (data) ->
        console.dir data

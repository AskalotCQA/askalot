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

  if document.getElementsByClassName('lti').length > 0
    lti_id = document.getElementsByClassName('lti')[document.getElementsByClassName('lti').length-1].getAttribute('id')

  if document.getElementsByClassName('lti_consumer').length > 0
    lti_id = document.getElementsByClassName("lti_consumer")[document.getElementsByClassName("lti_consumer").length-1].getAttribute("id")

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

#$('nav .course-tabs li:contains(Discussion)').hide()

ignore_hash_change = false

changeIframeSrc = ->
  $('#iFrameResizer0').attr('src', url_domain(host) + window.location.hash.substring(1)) unless ignore_hash_change
  ignore_hash_change = false

url_domain = (url) ->
  matches = url.match(/(^https?\:\/\/([^\/?#]+)(?:[\/?#]|$))/i)
  matches[1]

$(document).ready ->
  if window.location.hash == ''
    a_src = host + courseUuid() + '/questions?utf8=%E2%9C%93&amp;tab=recent&amp;poll=true'
  else
    a_src = url_domain(host) + window.location.hash.replace('/default/', '/' + courseUuid() + '/').substring(2)

  login_url = $('#login-url').text()
  a_src += '?login_url=' + login_url if login_url != ''
  a_src += '&page_url=' + location.protocol + '//' + location.host + location.pathname

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
          window.location = data.message.pageUrl if window.location.href.indexOf('forced_login=true') > -1
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
        when 'reflectUrl'
          ignore_hash_change = true
          window.location.hash = data.message.data
  })

  if (is_global)
    window.addEventListener 'hashchange', changeIframeSrc

  if (!is_global)
    $.ajax
      type: 'POST'
      url: host + courseUuid() +  '/parser'
      dataType: 'json'
      data: infoParser()

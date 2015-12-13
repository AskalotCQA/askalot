#= require iframeResizer.min.js

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
    category_name: tree.getElementsByClassName('group-heading active')[0].textContent.trim()
    subcategory_name: clone.textContent.trim(),
    courseId: unit.getAttribute('data-course-id').trim()
    course_name: document.getElementsByClassName('course-name')[0].textContent.trim()
    categoryId: parsed[parsed.length-3]
    subcategoryId: parsed[parsed.length - 2]
    unitId: unit.getAttribute('data-usage-id')
    content: unit.innerHTML
    ltiId: lti_element.id.trim()
    unit_name: sequence.getElementsByClassName('active')[0].getAttribute('data-page-title').trim()

  name_element = $('#sequence-list .active')[0]

  if name_element
    data.unit_name = name_element.getAttribute('data-page-title').trim()
  data

iFrameResize()

data = infoParser()
console.log(data)

$.ajax
  type: 'POST'
  url: 'http://192.168.1.8:3000/parser'
  dataType: 'json'
  data:
    course_id: data.courseId
    course_name: data.courseId
    section_id: data.categoryId
    section_name: data.category_name
    subsection_id: data.subcategoryId
    subsection_name: data.subcategory_name
    unit_id: data.unitId
    unit_name: data.unit_name
    content: data.content
    lti_id: data.ltiId
  success: (data) ->
    console.dir data

$('nav .course-tabs li:contains(Discussion)').hide()

$(document).ready ->
  getURLParameter = (name) ->
    decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) or [null, ''])[1].replace(/\+/g, '%20')) or null

  a_src = 'https://askalot.fiit.stuba.sk/edx-staging/questions?utf8=%E2%9C%93&amp;tab=recent&amp;poll=true'
  redirect_url = getURLParameter('redirect')
  a_src += if redirect_url then '&amp;redirect=' + redirect_url else null

  $('<iframe>Your browser does not support iframes!</iframe>')
  .attr('title', 'Askalot')
  .attr('src', a_src)
  .attr('width', '100%')
  .attr('height', '600')
  .attr('marginwidth', '0')
  .attr('marginheight', '0')
  .attr('frameborder', '0')
  .appendTo('#askalot-wrapper')

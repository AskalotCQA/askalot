$('.administration-categories').on 'click', '.add-category', ->
  $('#new_category #category_parent_id').select2 'val', $(this).data('id')
  $('#new_category #category_uuid').val  $(this).data('uuid')
  $('html, body').stop().animate { scrollTop:0 }, '500'

$('.update-settings').click (e) ->
  e.preventDefault()

  $this = $(this)
  post_data $this

$('.copy-categories').click (e) ->
  e.preventDefault()

  $this = $(this)
  parent_name = $('#copy-categories-parent-id').find('.select2-chosen').text()

  if !parent_name.trim()
    alert $this.data('empty')
    return
  else
    post_data $this

post_data = (starter) ->
  original_text = starter.text()

  starter.text starter.data('wait')
  starter.prop 'disabled', true

  parent_name = $('#copy-categories-parent-id').find('.select2-chosen').text();
  data = { 'shared[]': [], 'askable[]': [], 'copied[]' : [], 'parent_name': parent_name }

  $(".treetable-checkbox:checked").each ->
    data[$(this).attr('name')].push $(this).val()

  $.post starter.data('url'), data, (response) ->
    starter.prop 'disabled', false
    starter.text original_text

    message = starter.data('success')
    $alert  = $('<div/>').addClass('alert alert-success text-left').hide().html(message)

    $('#copy-categories-parent-id').before($alert)

    $alert.slideDown 'fast'

    remove = -> $alert.remove()
    setTimeout (-> $alert.slideUp 'fast', remove), 5000

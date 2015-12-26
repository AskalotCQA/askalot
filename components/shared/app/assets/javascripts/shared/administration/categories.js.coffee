$('.administration-categories').on 'click', '.add-category', ->
  $('#new_category #category_parent_id').select2 'val', $(this).data('id')
  $('#new_category #category_uuid').val  $(this).data('uuid')
  $('html, body').stop().animate { scrollTop:0 }, '500'

$('.update-settings').click (e) ->
  e.preventDefault()

  $this = $(this)
  original_text = $this.text()

  $this.text $this.data('wait')
  $this.prop 'disabled', true

  data = { 'shared[]': [], 'askable[]': [] }

  $(".treetable-checkbox:checked").each ->
    data[$(this).attr('name')].push $(this).val()

  $.post $(this).data('url'), data, (response) ->
    $this.prop 'disabled', false
    $this.text original_text

    message = $this.data('success')
    $alert  = $('<div/>').addClass('alert alert-success text-left').hide().html(message)

    $this.before($alert)

    $alert.slideDown 'fast'

    remove = -> $alert.remove()
    setTimeout (-> $alert.slideUp 'fast', remove), 5000

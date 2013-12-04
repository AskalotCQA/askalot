$(document).ready ->
  $('#question_filter').on 'change', ->
    $(this).closest('form').submit()

  # TODO (smolnar) use better class of identification of tag in list
  $(document).on 'click', '#questions > ul > li ul.nav li a.label-info', ->
    tag  = { id: $(this).attr('data-id'), text: $(this).attr('data-text') }

    select = new Select('#question_filter')

    select.addItem tag

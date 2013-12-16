$(document).ready ->
  new Select()

  $(document).on 'change', '#question_tags', ->
    $(this).closest('form').submit()

  # TODO (smolnar) use better class of identification of tag in list
  $(document).on 'click', '#questions .question-tag, #questions .question-category', ->
    items = $(this).attr('data-id').split(',')

    select = Select.of('#question_tag')

    select.addItem id: item, text: item for item in items

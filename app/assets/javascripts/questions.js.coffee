$(document).ready ->
  new Select()

  $(document).on 'change', '#question_tags', ->
    $(this).closest('form').submit()

  # TODO (smolnar) use better class of identification of tag in list
  $(document).on 'click', '#questions .question-tag', ->
    tag = { id: $(this).attr('data-id'), text: $(this).attr('data-text') }

    select = Select.of('#question_tag')

    select.addItem tag

$(document).ready ->
  new Select()

  $(document).on 'change', '#question_tags', ->
    $(this).closest('form').submit()

  # TODO (smolnar) use better class of identification of tag in list
  $(document).on 'click', '#questions .question-tag, #questions .question-category', (e) ->
    e.preventDefault()

    items = $(this).attr('data-id').split(',')

    select = Select.of('#question_tags')

    select.addItem id: item, text: item for item in items

  select = new Select.of('#question_category_id')
  select.on 'change', (event) ->
    value = event.added.text

    html = ""
    tags = JSON.parse(select.attr('data-values'))

    html += "<li class=\"label label-info\">#{tag}</li>" for tag in tags[value]

    $('ul#category-tags').html(html)

# TODO (smolnar) refactor to filter module
onFilter = ->
  $('#questions').find('a').click (e) -> e.preventDefault()
  $('#questions').find('a').addClass('disabled')

  $('#questions').fadeTo('slow', 0.25)

$(document).ready ->
  new Select()

  $(document).on 'click', '#questions-controls a', -> onFilter()

  $(document).on 'change', '#question_tags', ->
    $(this).closest('form').submit()

    onFilter()

  # TODO (smolnar) use better class of identification of tag in list
  $(document).on 'click', '#questions .question-tag, #questions .question-category', (e) ->
    e.preventDefault()

    items  = $(this).attr('data-id').split(',')
    select = Select.of('#question_tags')

    select.addItems(items)

  select = new Select.of('#question_category_id')
  select.on 'change', (event) ->
    value = event.added.text

    html = ''
    tags = JSON.parse(select.attr('data-values'))

    html += "<li><span class=\"label label-info\">#{tag}</span></li>" for tag in tags[value]

    $('ul#question-category-tags').html(html)

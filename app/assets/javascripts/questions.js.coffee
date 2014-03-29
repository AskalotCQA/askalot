# TODO (smolnar) refactor to filter module
onFilter = ->
  $('#questions').find('a').click (e) -> e.preventDefault()
  $('#questions').find('a').addClass('disabled')

  $('#questions').fadeTo('slow', 0.25)

$(document).ready ->
  new Select()

  ##
  # Filter effect
  $(document).on 'click', '#questions-controls .nav-tabs a', -> onFilter()

  $(document).on 'change', '#question_tags', ->
    $(this).closest('form').submit()

    onFilter()

  ##
  # Filtering by category and tags for Select2
  $(document).on 'click', '#questions .question-tag, #questions .question-category', (e) ->
    e.preventDefault()

    items  = $(this).attr('data-id').split(',')
    select = Select.of('#question_tags')

    select.addItems(items)

  ##
  # Callbacks for default category tags
  select = new Select.of('#question_category_id')
  select.on 'change', (event) ->
    value = event.added.text

    tags = JSON.parse(select.attr('data-values'))
    html = templates['questions/category_tags'](tags: tags[value])

    $('ul#question-category-tags').html(html)

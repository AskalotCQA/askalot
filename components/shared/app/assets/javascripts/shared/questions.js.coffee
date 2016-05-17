$(document).ready ->
  new Select()

  ##
  # Filter effect
  $(document).on 'click', '#questions-controls .nav-tabs a', -> Effects.fadeOnFilter('#questions')

  $(document).on 'change', '#question_tags', ->
    $(this).closest('form').submit()

    Effects.fadeOnFilter('#questions')

  ##
  # Filtering by category and tags for Select2
  $(document).on 'click', '#questions .question-tag', (e) ->
    e.preventDefault()

    items  = $(this).attr('data-id').split(',')
    select = Select.of('#question_tags')

    select.addItems(items)

  ##
  # Callbacks for default category tags
  select = new Select.of('#question_category_id')
  select.on 'change', (event) ->
    value = event.added.id

    tags = JSON.parse(select.attr('data-values'))
    html = templates['questions/category_tags'](tags: tags[value])
    $('ul#question-category-tags').html(html)

    descriptions = JSON.parse(select.attr('data-descriptions'))
    $('.category-description').html(descriptions[value])

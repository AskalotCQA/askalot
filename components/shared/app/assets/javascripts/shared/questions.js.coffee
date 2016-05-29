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
  # Callbacks for question type description
  question_type_select = new Select.of('#question_question_type_id')
  question_type_select.on 'change', (event) ->
    value = event.added.id
    descriptions = JSON.parse(question_type_select.attr('data-descriptions'))
    icons = JSON.parse(question_type_select.attr('data-icons'))
    colors = JSON.parse(question_type_select.attr('data-colors'))
    icon = $('<i/>').addClass('fa').addClass(icons[value]).css('color', colors[value])

    $('.question-type-description').html(descriptions[value])
    $(this).closest('.input-group').find('.input-group-addon').html(icon)

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

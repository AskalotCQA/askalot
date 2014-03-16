# TODO (smolnar) report try errors

class window.Markdown
  url: '/markdown/preview'

  textcomplete:
    strategies:
      gemoji:
        match:    /(^|\s*):([\-+\w]*)$/
        template: (value) -> templates['markdown/textcomplete/gemoji'](icon: value)
        replace:  (value)  -> "$1:#{value}:"
        index:    2
        maxCount: 5
        search:   (term, callback) ->
          values = $.map Gemoji.names, (icon) -> if icon.indexOf(term) == 0 then icon else null

          try callback(values)

      users:
        match:    /(^|\s*)@(\w*)$/
        template: (value) -> templates['markdown/textcomplete/users'](user: value)
        replace:  (value) -> "$1@#{value.nick} "
        index:    2
        maxCount: 5
        search:   (term, callback) ->
          $.get '/users/suggest', q: term, (data) -> try callback(data)

      questions:
        match:    /(^|\s*)#(\w*)$/
        template: (value) -> templates['markdown/textcomplete/questions'](question: value)
        replace:  (value) -> "$1##{value.id} "
        index:    2
        maxCount: 5
        search: (term, callback) ->
          $.get '/questions/suggest', q: term, (data) -> try callback(data)


  @bind: ->
    $('[data-markdown]').each ->
      id = $(this).attr('id')

      markdown = new Markdown(id)

      $(this).find('.markdown-preview').click (event) ->
        markdown.preview()

  constructor: (id) ->
    @id = id

    @bindTextcomplete()

  preview: ->
    content = templates['markdown/preview'](translation: I18n.t('markdown.loading_preview'))

    $("##{@id}-preview .form-control").html(content)

    @render (html) =>
      $("##{@id}-preview .form-control").html(html)

  text: ->
    $("##{@id}-text textarea").val()

  render: (callback) ->
    text = @text()

    $.ajax
      url:  @url
      type: 'POST'
      data:
        text: text
      success: (html) -> callback(html)

  bindTextcomplete: ->
    for _, options of @textcomplete.strategies
      $("##{@id}-text textarea").textcomplete(options)

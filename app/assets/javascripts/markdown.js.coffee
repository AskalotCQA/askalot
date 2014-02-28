class window.Markdown
  url: '/markdown/preview'

  textcomplete:
    strategies:
      emoji:
        match: /\B:([\-+\w]*)$/
        search: (term, callback) ->
          values = $.map Gemoji.names, (icon) -> if icon.indexOf(term) == 0 then icon else null

          callback(values)
        template: (value) ->
          Handlebars.compile('
            <img class="gemoji" src="/images/gemoji/{{icon}}.png"></img>&nbsp;{{icon}}
          ')(icon: value)
        replace: (value)  -> ":#{value}:"
        index: 1
        maxCount: 5

  @bind: ->
    $('.markdown-tabs').each ->
      id = $(this).attr('id')

      markdown = new Markdown(id)

      $(this).find('.markdown-preview').click (event) ->
        markdown.preview()

  constructor: (id) ->
    @id = id

    @bindTextcomplete()

  preview: ->
    content = Handlebars.compile('<p class="text-muted">{{translation}}</p>')(translation: I18n.t('markdown.loading_preview'))

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

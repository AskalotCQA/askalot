class window.Markdown
  @url: '/markdown/preview'

  textcomplete:
    strategies:
      emoji:
        lal: 1


  @bind: ->
    $('.markdown-preview').click (event) ->
      id = $(this).closest('.markdown-tabs').attr('id')

      markdown = new Markdown(id)

      markdown.preview()

  constructor: (id) ->
    @id = id

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
      url: Markdown.url
      type: 'POST'
      data:
        text: text
      success: (html) -> callback(html)

  bindTextcomplete: ->


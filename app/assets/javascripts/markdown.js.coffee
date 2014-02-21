class window.Markdown
  @url: '/markdown/preview'

  @bind: ->
    $('.markdown-preview').click (event) ->
      id = $(this).closest('.markdown-tabs').attr('id')

      markdown = new Markdown(id)

      markdown.preview()

  constructor: (id) ->
    @id = id

  preview: ->
    $("##{@id}-preview").html("<p class=\"text-muted\">#{I18n.t('markdown.loading_preview')}</p>")

    @render (html) =>
      $("##{@id}-preview").html(html)

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

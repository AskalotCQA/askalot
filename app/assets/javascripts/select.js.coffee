#= require core/module

class window.Select extends Module
  defaults:
    formatSearching: ->
      "<span>#{I18n.t('question.tag.searching')}</span>"
    formatNoMatches: ->
      "<span>#{I18n.t('question.tag.no_matches_found')}</span>"
    tokenizer: (input, selection, callback, options) ->
      tokenizer = /,/

      if tokenizer.test(input)
        value = input.replace(tokenizer, '')

        callback(id: value, text: value)

      "#{input}".replace(/[\s]+/, '-') if /[\s]+/.test(input)
  roles:
    tags:
      tags: true
      multiple: true
      tokenSeparators: [',', ' ']
      initSelection: (element, callback) ->
        values = $(element).val().split(',').map (e) -> { id: e, text: e }

        callback(values)
      createSearchChoice : (term, data) -> { id: term, text: "#{term} (#{I18n.t('question.tag.new')})" } if data.length == 0
      ajax:
        url: '/tags/suggest'
        dataType: 'json'
        data: (term, page) ->
          q: term
          type: $(this).attr('data-type')
          context: $(this).attr('context')
          page: page - 1
        results: (data, page) ->
          data

  constructor: (options = {}) ->
    @selector = options.selector ?= '[data-as=select2]'

    @.bind()

  bind: ->
    $(@selector).each (i, element) =>
      role    = $(element).attr('data-role')
      options = @.options_for role

      $(element).select2 options

  options_for: (role) ->
    options = @defaults

    options = $.extend({}, options, @roles[role]) if role?

    options

new Select()

$(document).ready ->
  $('[data-as=select2]').each ->
    options = {}

    if $(this).attr('data-role') == 'tags'
      options = {
        tags: true
        multiple: true
        tokenSeparators: [',', ' ']
        createSearchChoice : (term, data) ->
          { id: term, text: term } if data.length == 0
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
      }
    $(this).select2(options)

Handlebars.registerHelper 'truncate', (string, options) ->
    length = options.hash.length || 20

    return string unless string.length > length

    result = string + ' '

    result = string.substr(0, length)
    result = string.substr(0, result.lastIndexOf(' '))

    result = if result.length > 0 then result else string.substr(0, length)

    new Handlebars.SafeString("#{result} &hellip;")

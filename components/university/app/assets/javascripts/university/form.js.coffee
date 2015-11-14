class window.Form extends Module
  @of: (selector) -> new window.Form(selector)

  constructor: (selector) ->
    @selector = selector
    @form     = $(@selector)

  setParams: (params) -> @form.find("[name=#{key}]").val(value) for key, value of params

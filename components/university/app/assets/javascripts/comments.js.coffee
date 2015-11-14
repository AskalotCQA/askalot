$(document).ready ->
  Hash.on /comment-\d+/, (matches) -> Helper.highlight("##{matches[0]}")

  $('form.new-comment').on 'submit', ->
    $(this).find('button[type="submit"]').attr('disabled', true)

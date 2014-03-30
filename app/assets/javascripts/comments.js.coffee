$(document).ready ->
  Hash.on /comment-\d+/, (matches) -> Helper.highlight("##{matches[0]}")

$(document).ready ->
  Hash.on /answer-\d+/, (matches) -> Helper.highlight("##{matches[0]}")

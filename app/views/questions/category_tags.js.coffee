$(document).ready->
  category = $('.select2-chosen').text()
  <% @tags = Category.find(category).tags %>
  $('.category-tags').replaceWith(@tags)

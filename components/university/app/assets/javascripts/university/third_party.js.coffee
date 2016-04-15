#= require iframeResizer.contentWindow.min

$('a:not([href=#], [href=#answer], [href*=third_party])').attr('target', '_blank');

$('#new-question-button').click ->
  $('#new_question').slideToggle();

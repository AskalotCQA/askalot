$(document).ready ->
  $('#users-tabs li a[data-remote-fade]').click ->
    Effects.fadeOnFilter($(this).attr('data-remote-fade'))

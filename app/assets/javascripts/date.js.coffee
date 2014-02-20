$(document).ready ->
  $('[data-as=datepicker]').datepicker
    format: 'd.m.yyyy',
    language: 'sk',
    autoclose: true,
    todayHighlight: true

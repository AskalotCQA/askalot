$(document).ready ->
  $('[data-as=datepicker]').datepicker
    autoclose: true
    format: 'd.m.yyyy'
    language: 'sk'
    todayHighlight: true
    weekStart: 1

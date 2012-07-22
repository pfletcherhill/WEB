# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.header .edit_profile').click ->
    $('.sidebar').animate({'right':'-300px'}, 400)
    $('.preferences').delay(500).animate({'right':'0px'}, 400)
  $('.preferences .close').click ->
    $('.preferences').animate({'right':'-300px'}, 400)
    $('.sidebar').delay(500).animate({'right':'0px'}, 400)
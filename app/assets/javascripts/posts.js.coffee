# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  #show form
  $(".item.new").click ->
    if $(this).hasClass 'close_form'
      $(".form textarea").val('')
      $(".form").stop().animate({"opacity":"0"}, 100).hide(250)
      $(".item.new h1").html('+')
      $(".item.new").removeClass('close_form')
      
    else
      $(".form").stop().show().css({'opacity':"0","width":"0px"}).animate({"width":"250px"}, 300).animate({"opacity":"1"}, 200)
      $(".form .text_form").hide()
      $(".button").show()
      $(".form textarea").focus()
      $(".item.new h1").html('-')
      $(".item.new").addClass('close_form')
      
  #Nav pointer
  $(".item.team").click ->
    $("#pointer").fadeIn(200).animate({"top":"146px"}, 300)
  
  $(".item.likes").click ->
    $("#pointer").fadeIn(200).animate({"top":"246px"}, 300)
      
  #Sidebar collapse
  $(".sidebar .name").click ->
    $(".collapsible.open").hide(250)
    div = $(this).parent()
    $('.collapsible', div).delay(250).show(250).addClass 'open'
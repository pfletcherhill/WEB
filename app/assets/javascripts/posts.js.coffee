# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  #show form
  $(".item.new").click ->
    if $(this).hasClass 'close_form'
      $(".container .form textarea").val('')
      $(".container .form").stop().animate({"opacity":"0"}, 100).hide(250)
      $(".item.new h1").html('+')
      $(".item.new").removeClass('close_form')
      
    else
      $(".container .form").stop().show().css({'opacity':"0","width":"0px"}).animate({"width":"250px"}, 300).animate({"opacity":"1"}, 200)
      $(".container .form .text_form").hide()
      $(".button").show()
      $(".container .form textarea").focus()
      $(".item.new h1").html('-')
      $(".item.new").addClass('close_form')
      
  #Nav pointer
  $(".item.team").click ->
    $("#pointer").fadeIn(200).animate({"top":"146px"}, 300)
  
  $(".item.likes").click ->
    $("#pointer").fadeIn(200).animate({"top":"246px"}, 300)
      
  #Sidebar collapse
  $(".sidebar .name").click ->
    $(".collapsible.open").hide(200)
    div = $(this).parent()
    if $('.collapsible', div).hasClass 'open'
      $('.collapsible.open').removeClass 'open'
    else
      $('.collapsible.open').removeClass 'open'
      $('.collapsible', div).delay(200).show(250).addClass 'open'
      $("#buckets_form .show_form").show()
      $("#buckets_form .form").hide()
      height = $(window).height() - 240
      $("#buckets").height(height + 'px')
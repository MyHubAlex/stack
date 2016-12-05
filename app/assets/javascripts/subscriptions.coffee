# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->   
  $('.Subscribe-link').click (e) ->
   	$('.subscription').html('<p>Вы подписались на данный вопрос</p>');
  $('.Unsubscribe-link').click (e) ->
   	$('.subscription').html('<p>Вы отписалсиь от данного вопроса</p>'); 
$(document).on("turbolinks:load", ready)   